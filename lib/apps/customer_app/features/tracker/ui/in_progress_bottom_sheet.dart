import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handees/apps/artisan_app/features/handee/ui/widgets/stars.dart';
import 'package:handees/apps/customer_app/features/tracker/providers/artisan_info.provider.dart';
import 'package:handees/apps/customer_app/features/tracker/providers/customer_location.provider.dart';
import 'package:handees/shared/res/shapes.dart';
import 'package:handees/shared/routes/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/shared/utils/utils.dart';
import '../providers/trackingProvider.dart';
import 'package:latlong2/latlong.dart' as latlong;

class InProgressBottomSheet extends ConsumerStatefulWidget {
  const InProgressBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<InProgressBottomSheet> createState() =>
      _InProgressBottomSheetState();
}

class _InProgressBottomSheetState extends ConsumerState<InProgressBottomSheet>
    with TickerProviderStateMixin {
  bool get _expanded => _controller.status != AnimationStatus.completed;
  final _curve = Curves.linear;
  final _duration = const Duration(milliseconds: 200);
  final _reverseDuration = const Duration(milliseconds: 250);
  final time = 4;

  late final AnimationController _controller = AnimationController(
    duration: _duration,
    reverseDuration: _reverseDuration,
    vsync: this,
  );
  late final AnimationController _secondaryController = AnimationController(
    duration: _duration,
    reverseDuration: _reverseDuration,
    vsync: this,
    lowerBound: 0.2,
  );
  late final AnimationController _halfController = AnimationController(
    duration: _duration,
    reverseDuration: _reverseDuration,
    vsync: this,
    lowerBound: 0.5,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: _curve,
  );

  void _controllersFoward() {
    _controller.forward();
    _secondaryController.forward();
    _halfController.forward();

    ref.read(blurBackgroundProvider.notifier).openSheet();
  }

  void _controllersReverse() {
    _controller.reverse();
    _secondaryController.reverse();
    _halfController.reverse();
    ref.read(blurBackgroundProvider.notifier).closeSheet();
  }

  void _controllersUpdate(double value) {
    _controller.value -= value;
    _secondaryController.value -= value * 0.8;
    _halfController.value -= value * 0.5;
  }

  @override
  void dispose() {
    _controller.dispose();
    _secondaryController.dispose();
    _halfController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentBooking = ref.watch(currentBookingProvider);
    final artisanLocationData = ref.watch(artisanLocationDataProvider);
    final customerLocation = ref.watch(customerLocationProvider);
    const distance = latlong.Distance();
    final double currentMeters = distance(
      latlong.LatLng(
          artisanLocationData.latitude, artisanLocationData.longitude),
      latlong.LatLng(customerLocation.latitude!, customerLocation.longitude!),
    );
    final double totalMeters = distance(
      latlong.LatLng(currentBooking.artisanInitialLocation!.latitude,
          currentBooking.artisanInitialLocation!.longitude),
      latlong.LatLng(customerLocation.latitude!, customerLocation.longitude!),
    );

    dPrint(currentMeters);
    dPrint(totalMeters);
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _controllersUpdate(details.delta.dy / 250);
        });
      },
      onVerticalDragEnd: (_) {
        if (_controller.value > 0.5) {
          _controllersFoward();
        } else {
          _controllersReverse();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        _expanded
                            ? _controllersFoward()
                            : _controllersReverse();
                      },
                      icon: RotationTransition(
                        turns: CurvedAnimation(
                          parent: _halfController,
                          curve: _curve,
                        ),
                        child: const Icon(
                          Icons.expand_more,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Your ${currentBooking.artisan?.jobTitle} is on the way!',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizeTransition(
                sizeFactor: CurvedAnimation(
                  parent: _secondaryController,
                  curve: _curve,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    FadeTransition(
                      opacity: _animation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: ShapeDecoration(
                              shape: Shapes.smallShape,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '$currentMeters meters away',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZ71zry5wqz_McgPvbGx9exU5dsBC4HLZNhtU4hQX1hg&s"),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentBooking.artisanUserInfo != null
                                        ? currentBooking.artisanUserInfo!
                                            .getName()
                                        : "Artisan",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  const HandeeStars(
                                    count: 5,
                                    filledCount: 4,
                                    height: 18,
                                    width: 18,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '17/24 completed',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: getHexColor('A4A1A1'),
                                        ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                decoration: ShapeDecoration(
                                  color: currentBooking
                                      .artisan?.jobCategory?.foregroundColor
                                      .withOpacity(0.2),
                                  shape: Shapes.mediumShape,
                                ),
                                height: 72,
                                width: 72,
                                child: Center(
                                  child: CircleAvatar(
                                    backgroundColor: currentBooking
                                        .artisan?.jobCategory?.foregroundColor,
                                    child: Icon(currentBooking
                                        .artisan?.jobCategory?.icon),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          Row(
                            children: [
                              SizedBox(
                                width: 64,
                                child: SvgPicture.asset(
                                  'assets/svg/money.svg',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '₦500/hr',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FadeTransition(
                      opacity: ReverseAnimation(_animation),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$currentMeters meters away',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: (totalMeters - currentMeters) / totalMeters,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: _animation,
              child: Divider(
                height: 32.0,
                thickness: 8.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30.0),
                  Text(
                    'While you wait, you can reach out to them to confirm the details of the service you need.',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: getHexColor('A4A1A1')),
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Uri callPhoneNo = Uri.parse(
                                'tel:${currentBooking.artisanUserInfo?.telephone}');
                            openUrl(callPhoneNo);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Call',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                Icons.call,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        // width: double.infinity,
                        child: FilledButton.tonal(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(CustomerAppRoutes.chat);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Message',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: getHexColor('14161C'),
                                    ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                Icons.message,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizeTransition(
                    sizeFactor: _animation,
                    child: Container(
                      alignment: Alignment.center,
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.close),
                        label: const Text('Cancel Service'),
                        style:
                            Theme.of(context).textButtonTheme.style?.copyWith(
                                  foregroundColor: WidgetStateProperty.all(
                                    Theme.of(context).colorScheme.error,
                                  ),
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
