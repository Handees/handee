import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handees/apps/customer_app/features/home/ui/widgets/service_card.dart';

import '../../../../../../shared/data/handees/job_category.dart';
import '../../../../../../shared/routes/routes.dart';
import 'custom_delegate.dart';
import 'location_picker.dart';
import 'ongoing_service.dart';

Widget buildAppBar(BuildContext context) {
  return SliverAppBar(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CustomerAppRoutes.notifications);
        },
        icon: const Icon(Icons.notifications_outlined),
      )
    ],
  );
}

Widget buildHeader(BuildContext context, dynamic user, double horizontalPadding) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Hello ${user.getName()}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).unselectedWidgetColor,
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
  );
}

Widget buildLocationPicker(double horizontalPadding) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    sliver: SliverPersistentHeader(
      floating: true,
      delegate: CustomDelegate(
        height: 64.0,
        child: const LocationPicker(),
      ),
    ),
  );
}

Widget buildOngoingServiceHeader(double horizontalPadding) {
  return SliverPersistentHeader(
    pinned: true,
    delegate: CustomDelegate(
      height: 144.0,
      shape: const RoundedRectangleBorder(),
      elevation: 0,
      padding: EdgeInsets.zero,
      child: PageView.builder(
        itemBuilder: (context, index) {
          return OngoingServiceHeader(
            horizontalPadding: horizontalPadding,
          );
        },
      ),
    ),
  );
}

Widget buildServiceList(double horizontalPadding, List<JobCategory> filteredCategories) {
  return SliverPadding(
    padding: const EdgeInsets.only(top: 8.0),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final category = filteredCategories[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(CustomerAppRoutes.review);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: horizontalPadding,
              ),
              child: ServiceCard(
                artisanCount: 12,
                icon: Icon(
                  category.icon,
                  color: Colors.white,
                ),
                iconBackground: category.foregroundColor,
                serviceName: category.name,
              ),
            ),
          );
        },
        childCount: filteredCategories.length,
      ),
    ),
  );
}

