import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/customer_app/features/home/providers/booking.provider.dart';
import 'package:handees/apps/customer_app/features/home/ui/widgets/pick_service_bottom_sheet.dart';
import 'package:handees/apps/customer_app/features/home/ui/widgets/search.dart';

import 'package:handees/apps/customer_app/features/home/ui/widgets/swap_button.dart';
import 'package:handees/apps/customer_app/features/home/ui/widgets/ongoing_service.dart';
import 'package:handees/apps/customer_app/features/tracker/providers/customer_location.provider.dart';
import 'package:handees/shared/data/handees/job_category.dart';
import 'package:handees/shared/res/shapes.dart';
import 'package:handees/shared/res/icons.dart';
import 'package:handees/shared/routes/routes.dart';
import 'package:handees/shared/services/auth_service.dart';
import 'package:handees/shared/ui/widgets/custom_bottom_sheet.dart';
import 'package:handees/shared/utils/utils.dart';
import '../../providers/user.provider.dart';
import '../widgets/location_picker.dart';
import '../widgets/service_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(customerLocationProvider.notifier).initLocation();
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 16.0;

    final user = ref.watch(userProvider);
    final location = ref.watch(customerLocationProvider);

    const categories = JobCategory.values;

    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Scaffold(
            // backgroundColor: Theme.of(context).colorScheme.background,
            drawer: Drawer(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        DrawerHeader(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(CustomerAppRoutes.profile),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: ShapeDecoration(
                                      shape: const CircleBorder(),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                    child: const Icon(Icons.account_circle),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Text(
                                    user.getName(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const Spacer(),
                                  SwapButton(() {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (sheetCtx) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(sheetCtx)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: CTABottomSheet(
                                            title: 'Switch Apps',
                                            text:
                                                "Are you sure you would like to switch to the artisan app?",
                                            ctaText: "Switch to Artisan",
                                            leading: SwapButton(() {}),
                                            onPressCta: () async {
                                              final user =
                                                  ref.read(userProvider);
                                              if (user.isArtisan) {
                                                await Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pushReplacementNamed(
                                                        ArtisanAppRoutes.home);
                                              } else {
                                                await Navigator.of(
                                                  context,
                                                ).pushNamed(CustomerAppRoutes
                                                    .artisanSwitch);
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  })
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () => Navigator.of(context)
                              .pushNamed(CustomerAppRoutes.payments),
                          leading: const Icon(HandeeIcons.payment),
                          title: const Text('Payments'),
                        ),
                        const Divider(),
                        ListTile(
                          onTap: () => Navigator.of(context)
                              .pushNamed(CustomerAppRoutes.history),
                          leading: const Icon(Icons.history),
                          title: const Text('History'),
                        ),
                        const Divider(),
                        ListTile(
                          onTap: () => Navigator.of(context)
                              .pushNamed(CustomerAppRoutes.settings),
                          leading: const Icon(Icons.settings_outlined),
                          title: const Text('Settings'),
                        ),
                        const Divider(),
                        ListTile(
                          onTap: () => Navigator.of(context)
                              .pushNamed(CustomerAppRoutes.support),
                          leading: const Icon(HandeeIcons.personSupport),
                          title: const Text('Customer Support'),
                        ),
                        const Divider(),
                        ListTile(
                          onTap: () {},
                          leading: const Icon(HandeeIcons.chatHelp),
                          title: const Text('FAQ'),
                        ),
                        const Divider(),
                        ListTile(
                          onTap: () {
                            AuthService.instance.signoutUser(() =>
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacementNamed(AuthRoutes.root));
                          },
                          leading: const Icon(Icons.exit_to_app),
                          title: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const Padding(
              padding: EdgeInsets.only(
                bottom: horizontalPadding,
                left: horizontalPadding,
                right: horizontalPadding,
              ),
              child: SearchWidget(),
            ),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarIconBrightness: Brightness.dark,
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(CustomerAppRoutes.notifications);
                        },
                        icon: const Icon(Icons.notifications_outlined),
                      )
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Hello ${user.getName()}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).unselectedWidgetColor,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Let\'s give you a hand',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    sliver: SliverPersistentHeader(
                      // pinned: true,
                      floating: true,
                      delegate: _CustomDelegate(
                        height: 64.0,
                        child: const LocationPicker(),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _CustomDelegate(
                      height: 144.0,
                      shape: const RoundedRectangleBorder(),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      child: PageView.builder(
                        itemBuilder: (context, index) {
                          return const OngoingServiceHeader(
                            horizontalPadding: horizontalPadding,
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 8.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (sheetCtx) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(sheetCtx)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: PickServiceBottomSheet(
                                      category: categories[index],
                                      onClick: () {
                                        Navigator.of(context)
                                            .pushNamed(
                                                CustomerAppRoutes.pickService)
                                            .then((res) {
                                          if (res != null &&
                                              location.latitude != null) {
                                            dPrint("Called bookservice");
                                            ref
                                                .read(bookingProvider.notifier)
                                                .bookService(
                                                  category: categories[index],
                                                  location: location,
                                                );
                                            Navigator.of(context).pushNamed(
                                                CustomerAppRoutes.tracking);
                                          }
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: horizontalPadding,
                              ),
                              child: ServiceCard(
                                artisanCount: 12,
                                icon: Icon(
                                  categories[index].icon,
                                  color: Colors.white,
                                ),
                                iconBackground:
                                    categories[index].foregroundColor,
                                serviceName: categories[index].name,
                              ),
                            ),
                          );
                        },
                        childCount: categories.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomDelegate extends SliverPersistentHeaderDelegate {
  _CustomDelegate({
    required this.height,
    required this.child,
    this.shape = Shapes.bigShape,
    this.padding = const EdgeInsets.symmetric(
      vertical: 16,
    ),
    this.elevation = 4.0,
  });

  final double height;
  final Widget child;
  final ShapeBorder shape;
  final EdgeInsets padding;
  final double elevation;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      child: Padding(
        padding: padding,
        child: Material(
          elevation: elevation,
          shape: shape,
          clipBehavior: Clip.hardEdge,
          shadowColor: Theme.of(context).colorScheme.shadow,
          child: child,
        ),
      ),
    );
  }

  @override
  double get maxExtent => height + padding.vertical;

  @override
  double get minExtent => height + padding.vertical;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
