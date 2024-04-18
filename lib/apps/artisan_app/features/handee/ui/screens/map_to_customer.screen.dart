import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handees/apps/artisan_app/features/handee/utils/helpers.dart';
import 'package:handees/apps/artisan_app/features/home/providers/current-offer.provider.dart';
import 'package:handees/apps/artisan_app/features/home/providers/artisan-location.provider.dart';
import 'package:handees/apps/artisan_app/features/home/ui/home_nav/widgets/icon_avatar.dart';
import 'package:handees/apps/artisan_app/services/sockets/artisan_socket.dart';
import 'package:handees/shared/res/constants.dart';
import 'package:handees/shared/routes/routes.dart';
import 'package:handees/shared/utils/utils.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:location/location.dart';

const maximumArrivalDistance = 30;

class MapToCustomerScreen extends ConsumerStatefulWidget {
  const MapToCustomerScreen({super.key});

  @override
  ConsumerState<MapToCustomerScreen> createState() =>
      _MapToCustomerScreenState();
}

class _MapToCustomerScreenState extends ConsumerState<MapToCustomerScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  bool hasArtisanArrived = true;
  late LatLng destination;

  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor artisanIcon = BitmapDescriptor.defaultMarker;

  List<LatLng> polylineCoords = [];

  Future getPolyPoints(LatLng source) async {
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

  void setCustomMarkerIcon() async {
    Uint8List markerIcon =
        await Helpers.getBytesFromAsset("assets/icon/artisan_marker.png", 150);
    artisanIcon = BitmapDescriptor.fromBytes(markerIcon);

    markerIcon = await Helpers.getBytesFromAsset("assets/icon/house.png", 120);
    destinationIcon = BitmapDescriptor.fromBytes(markerIcon);
  }

  @override
  void initState() {
    super.initState();
    setCustomMarkerIcon();
    final currentOffer = ref.read(currentOfferProvider);
    destination = LatLng(currentOffer.lat, currentOffer.lon);
    final location = ref.read(locationProvider);
    if (location.latitude != null && location.longitude != null) {
      getPolyPoints(LatLng(location.latitude!, location.longitude!));
    }
  }

  @override
  Widget build(BuildContext context) {
    LocationData location = ref.watch(locationProvider);
    dPrint(location.latitude);
    if (location.latitude == null || location.longitude == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    ref.listen(locationProvider, (LocationData? prev, LocationData next) async {
      GoogleMapController controller = await _controller.future;
      await getPolyPoints(LatLng(next.latitude!, next.longitude!));

      const distance = latlong.Distance();
      final double meter = distance(
        latlong.LatLng(next.latitude!, next.longitude!),
        latlong.LatLng(destination.latitude, destination.longitude),
      );
      if (meter <= maximumArrivalDistance) {
        setState(() {
          hasArtisanArrived = true;
        });
      }

      setState(() {
        controller.animateCamera(
            CameraUpdate.newLatLng(LatLng(next.latitude!, next.longitude!)));
      });
    });

    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('Artisan Location'),
        icon: artisanIcon,
        position: LatLng(location.latitude!, location.longitude!),
      ),
      Marker(
        markerId: const MarkerId('Customer Location'),
        position: destination,
        icon: destinationIcon,
      )
    };

    dPrint(polylineCoords);

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);

                // TODO: Waiting for the setState by 1 second is a hack. The problem seems to be that the function below is called when the map is not ready. Waiting 1 second does the trick but ideally, we should figure out when the map is loaded through some function or something.

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
                target: LatLng(location.latitude!, location.longitude!),
                zoom: 15,
                tilt: 0,
                bearing: 0,
              ),
              markers: markers,
              polylines: {
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: polylineCoords,
                  color: Theme.of(context).primaryColor,
                  width: 6,
                )
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: OfferInfo(hasArtisanArrived, () async {
              GoogleMapController controller = await _controller.future;
              setState(() {
                controller.animateCamera(CameraUpdate.newLatLng(
                    LatLng(location.latitude!, location.longitude!)));
              });
            }),
          ),
        ]),
      ),
    );
  }
}

class OfferInfo extends ConsumerWidget {
  final bool hasArtisanArrived;
  final void Function()? resetMap;
  const OfferInfo(this.hasArtisanArrived, this.resetMap, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offer = ref.read(currentOfferProvider);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: (hasArtisanArrived ? 360 : 280),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(
        top: 35,
        left: 25,
        right: 25,
        bottom: 20,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const IconAvatar(),
              const SizedBox(width: 16.0),
              Text(
                offer.user.getName(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 16.0),
              Text(
                "4.5",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 12),
              ),
              const Icon(
                Icons.star,
                color: Color(0xffffe186),
                size: 14,
              ),
              const Spacer(),
              IconButton(
                onPressed: resetMap,
                icon: Image.asset("assets/icon/artisan_marker.png", width: 40),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Icon(Icons.build_outlined),
                SizedBox(
                  width: 22,
                ),
                Text(
                  'Additional Information',
                  style: TextStyle(
                    color: Color(0xff949494),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined),
                SizedBox(
                  width: 22,
                ),
                Text(
                  '15 Changi Business Park Cres lagos',
                  style: TextStyle(
                    color: Color(0xff949494),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Uri callPhoneNo = Uri.parse('tel:${offer.user.telephone}');
                    openUrl(callPhoneNo);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      getHexColor('f2f3f4'),
                    ),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    child: Row(
                      children: [
                        Icon(
                          Icons.call,
                          color: getHexColor('14161c'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Call',
                          style: TextStyle(
                              color: getHexColor('14161c'),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 17,
              ),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Uri sendSms = Uri.parse('sms:${offer.user.telephone}');
                    openUrl(sendSms);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      getHexColor('f2f3f4'),
                    ),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    child: Row(
                      children: [
                        Icon(
                          Icons.message,
                          color: getHexColor('14161c'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Message',
                          style: TextStyle(
                              color: getHexColor('14161c'),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasArtisanArrived) ...[
            const SizedBox(
              height: 27,
            ),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: FilledButton(
                onPressed: () {
                  ref
                      .read(artisanSocketProvider.notifier)
                      .emitArtisanArrival(offer.bookingId);
                  Navigator.of(context)
                      .pushReplacementNamed(ArtisanAppRoutes.confirmHandee);
                },
                child: const Text(
                  'ARRIVED',
                  style: TextStyle(
                    letterSpacing: .64,
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
