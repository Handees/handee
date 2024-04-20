import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handees/apps/artisan_app/features/handee/utils/helpers.dart';
import 'package:handees/apps/customer_app/features/home/providers/booking.provider.dart';
import 'package:handees/apps/customer_app/features/tracker/providers/customer_location.provider.dart';
import 'package:handees/shared/res/constants.dart';

import 'package:handees/shared/res/shapes.dart';
import 'package:handees/shared/routes/routes.dart';
import 'package:handees/shared/ui/widgets/circle_fadeout_loader.dart';
import 'package:handees/shared/utils/utils.dart';

import 'in_progress_bottom_sheet.dart';
import 'loading_bottom_sheet.dart';

const maximumArrivalDistance = 30;

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor artisanIcon = BitmapDescriptor.defaultMarker;

  void setCustomMarkerIcon() async {
    Uint8List markerIcon =
        await Helpers.getBytesFromAsset("assets/icon/artisan_marker.png", 150);
    artisanIcon = BitmapDescriptor.fromBytes(markerIcon);

    markerIcon = await Helpers.getBytesFromAsset("assets/icon/house.png", 120);
    destinationIcon = BitmapDescriptor.fromBytes(markerIcon);
  }

  List<LatLng> polylineCoords = [];

  Future getPolyPoints(LatLng source, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConstants.kMapsApiKey,
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    polylineCoords = [];
    if (result.status == "REQUEST_DENIED") {
      ePrint(result.errorMessage!);
    }
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoords.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setCustomMarkerIcon();
    final destination = ref.read(customerLocationProvider);
    final artisan = ref.read(artisanLocationDataProvider);
    if (destination.latitude != null) {
      getPolyPoints(
          artisan, LatLng(destination.latitude!, destination.longitude!));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late final Widget bottomSheet;
    final trackingState = ref.watch(bookingProvider);
    final model = ref.watch(bookingProvider.notifier);
    final destination = ref.watch(customerLocationProvider);
    final artisanLocation = ref.watch(artisanLocationDataProvider);

    dPrint(trackingState);

    switch (trackingState) {
      case BookingState.loading:
        bottomSheet = LoadingBottomSheet(
          category: model.category,
        );
        break;
      case BookingState.inProgress:
        bottomSheet = const InProgressBottomSheet();

        break;
      case BookingState.arrived:
        bottomSheet = const ArrivedBottomSheet();
        break;
      default:
    }

    if (destination.latitude == null || destination.longitude == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: const Center(child: CircleFadeOutLoader()),
        bottomSheet: Material(
          elevation: 24,
          shadowColor: Colors.black,
          child: bottomSheet,
        ),
      );
    }

    ref.listen(artisanLocationDataProvider, (LatLng? prev, LatLng next) async {
      GoogleMapController controller = await _controller.future;
      await getPolyPoints(LatLng(next.latitude, next.longitude),
          LatLng(destination.latitude!, destination.longitude!));

      setState(() {
        controller.animateCamera(
            CameraUpdate.newLatLng(LatLng(next.latitude, next.longitude)));
      });
    });

    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('Customer Location'),
        icon: destinationIcon,
        position: LatLng(destination.latitude!, destination.longitude!),
      ),
      Marker(
        markerId: const MarkerId('Artisan'),
        position: artisanLocation,
        icon: artisanIcon,
      )
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: trackingState == BookingState.loading
          ? const Center(
              child: CircleFadeOutLoader(),
            )
          : Center(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) async {
                  Future.delayed(
                    const Duration(seconds: 1),
                    () => setState(() {
                      controller.animateCamera(CameraUpdate.newLatLngBounds(
                        Helpers.bounds(markers),
                        20,
                      ));
                    }),
                  );
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(destination.latitude!, destination.longitude!),
                  zoom: 15,
                  tilt: 0,
                  bearing: 0,
                ),
                markers: markers,
              ),
            ),
      bottomSheet: Material(
        elevation: 24,
        shadowColor: Colors.black,
        child: bottomSheet,
      ),
    );
  }
}

class ArrivedBottomSheet extends StatelessWidget {
  const ArrivedBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Your handee man is here',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8.0),
          const ProgressCard(),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('Call'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                // width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CustomerAppRoutes.chat);
                  },
                  child: const Text('Message'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 28),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jane Doe',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.money,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '₦500/hr',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            decoration: const ShapeDecoration(
              color: Color.fromRGBO(253, 223, 242, 1),
              shape: Shapes.mediumShape,
            ),
            height: 64,
            width: 64,
            child: const Center(
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(255, 125, 203, 1),
                child: Icon(Icons.abc),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
