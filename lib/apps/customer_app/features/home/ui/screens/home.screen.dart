import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/customer_app/features/home/ui/widgets/search.dart';
import 'package:handees/apps/customer_app/features/home/ui/widgets/swap_button.dart';
import 'package:handees/apps/customer_app/features/tracker/providers/customer_location.provider.dart';
import 'package:handees/shared/data/handees/job_category.dart';
import 'package:handees/shared/data/user/models/api_user.model.dart';
import 'package:handees/shared/res/icons.dart';
import 'package:handees/shared/routes/routes.dart';
import 'package:handees/shared/services/auth_service.dart';
import 'package:handees/shared/ui/widgets/custom_bottom_sheet.dart';

import '../../providers/user.provider.dart';
import '../widgets/utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<JobCategory> filteredCategories = JobCategory.values;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    ref.read(customerLocationProvider.notifier).initLocation();
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories = JobCategory.values
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      isSearching = query.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 16.0;
    final user = ref.watch(userProvider);
    final location = ref.watch(customerLocationProvider);

    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            drawer: _buildDrawer(context, user),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(
                bottom: horizontalPadding,
                left: horizontalPadding,
                right: horizontalPadding,
              ),
              child: SearchWidget(onSearch: filterCategories),
            ),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  buildAppBar(context),
                  buildHeader(context, user, horizontalPadding),
                  buildLocationPicker(horizontalPadding),
                  if (!isSearching)
                    buildOngoingServiceHeader(horizontalPadding),
                  buildServiceList(
                      horizontalPadding, filteredCategories, location, ref),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, ApiUserModel user) {
    return Drawer(
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                _buildDrawerHeader(context, user),
                ..._buildDrawerItems(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, ApiUserModel user) {
    return DrawerHeader(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: InkWell(
          onTap: () =>
              Navigator.of(context).pushNamed(CustomerAppRoutes.profile),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: ShapeDecoration(
                  shape: const CircleBorder(),
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                child: const Icon(Icons.account_circle),
              ),
              const SizedBox(width: 16.0),
              Text(
                user.getName(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              SwapButton(_showSwapBottomSheet),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    return [
      DrawerItem(
        icon: HandeeIcons.payment,
        title: 'Payments',
        onTap: () =>
            Navigator.of(context).pushNamed(CustomerAppRoutes.payments),
      ),
      DrawerItem(
        icon: Icons.history,
        title: 'History',
        onTap: () => Navigator.of(context).pushNamed(CustomerAppRoutes.history),
      ),
      DrawerItem(
        icon: Icons.settings_outlined,
        title: 'Settings',
        onTap: () =>
            Navigator.of(context).pushNamed(CustomerAppRoutes.settings),
      ),
      DrawerItem(
        icon: HandeeIcons.personSupport,
        title: 'Customer Support',
        onTap: () => Navigator.of(context).pushNamed(CustomerAppRoutes.support),
      ),
      DrawerItem(
        icon: HandeeIcons.chatHelp,
        title: 'FAQ',
        onTap: () {},
      ),
      DrawerItem(
        icon: Icons.exit_to_app,
        title: 'Sign Out',
        onTap: () {
          AuthService.instance.signoutUser(() =>
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed(AuthRoutes.root));
        },
      ),
    ];
  }

  void _showSwapBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
          ),
          child: CTABottomSheet(
            title: 'Switch Apps',
            text: "Are you sure you would like to switch to the artisan app?",
            ctaText: "Switch to Artisan",
            leading: SwapButton(() {}),
            onPressCta: () async {
              final user = ref.read(userProvider);
              if (user.isArtisan) {
                await Navigator.of(context, rootNavigator: true)
                    .pushReplacementNamed(ArtisanAppRoutes.home);
              } else {
                await Navigator.of(context)
                    .pushNamed(CustomerAppRoutes.artisanSwitch);
              }
            },
          ),
        );
      },
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const DrawerItem(
      {required this.icon,
      required this.title,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(icon),
          title: Text(title),
        ),
        const Divider(),
      ],
    );
  }
}
