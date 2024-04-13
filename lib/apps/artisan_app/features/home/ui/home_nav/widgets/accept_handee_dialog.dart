import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/artisan_app/features/home/providers/current-offer.provider.dart';
import 'package:handees/apps/artisan_app/features/home/providers/artisan-location.provider.dart';
import 'package:handees/apps/artisan_app/services/sockets/artisan_socket.dart';
import 'package:handees/apps/artisan_app/shared_widgets/i_dialog.dart';
import 'package:handees/shared/data/handees/offer.dart';
import 'icon_avatar.dart';
import 'package:handees/shared/routes/routes.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:location/location.dart';
import '../providers/new_offer_provider.dart';

class AcceptHandeeDialog extends ConsumerWidget {
  final BuildContext externalContext;
  final Offer offer;
  final void Function() onClose;
  const AcceptHandeeDialog(
      {required this.offer,
      required this.onClose,
      required this.externalContext,
      super.key});

  static const int handeeAcceptanceTime = 30;

  static final timerValueTween = Tween<double>(begin: 1, end: 0);
  static const distance = latlong.Distance();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LocationData location = ref.watch(locationProvider);
    double meter = 0;

    if (location.latitude != null && location.longitude != null) {
      meter = distance(
        latlong.LatLng(location.latitude!, location.longitude!),
        latlong.LatLng(offer.lat, offer.lon),
      );
    }

    return IDialog(
      child: DialogContainer(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "3 mins",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 16.0),
                Container(
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 16.0),
                Text(
                  "$meter m",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClose();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xffe63946),
                  ),
                )
              ],
            ),
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
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.construction_outlined,
                    color: Color(0xffa4a1a1),
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    "Additional Information",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xffa4a1a1),
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xffa4a1a1),
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    "15, Changes Business Street, Yaba, Lagos",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xffa4a1a1),
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 110,
              child: FilledButton(
                onPressed: () async {
                  ref.read(currentOfferProvider.notifier).changeOffer(offer);

                  ref
                      .read(artisanSocketProvider.notifier)
                      .acceptOffer(offer.bookingId, location);

                  // pop the dialog box
                  Navigator.of(context).pop();

                  // change main screen
                  Navigator.of(externalContext)
                      .pushNamed(ArtisanAppRoutes.transitToArtisan);

                  // attach artisan to the booking
                  ref.read(bookingStateProvider.notifier).attachToBooking();
                },
                child: Row(
                  children: [
                    const Text('Accept'),
                    const Spacer(),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: TweenAnimationBuilder(
                        tween: timerValueTween,
                        duration: const Duration(seconds: handeeAcceptanceTime),
                        builder: (_, double value, __) {
                          if (value == 0) {
                            Navigator.of(context).pop();
                          }
                          return CircularProgressIndicator(
                            color: Colors.white,
                            value: value,
                            strokeWidth: 3,
                          );
                        },
                        onEnd: () => onClose(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestWidgetDial extends StatelessWidget {
  final BuildContext externalContext;
  const TestWidgetDial({
    required this.externalContext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double meter = 5;
    return IDialog(
        child: DialogContainer(
      child: Column(
        children: [
          Row(children: [
            Text(
              "3 mins",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 16.0),
            Container(
              height: 5,
              width: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 16.0),
            Text(
              "$meter m",
              style: Theme.of(context).textTheme.titleMedium,
            )
          ])
        ],
      ),
    ));
  }
}
