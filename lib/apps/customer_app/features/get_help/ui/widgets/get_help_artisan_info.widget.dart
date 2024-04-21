import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'brush_Icon.widget.dart';

class ArtisanInfoWidget extends ConsumerWidget {
  ArtisanInfoWidget({super.key});

  String artisan = 'Hair stylist';
  String artisanName = 'John Doe';
  String artisanPhotoPath = '';
  String dateTime(DateTime dateTime) {
    return DateFormat('MMM, yy, h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 35, 15, 30),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade100],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get help with a recent service',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: brushIconWidget(),
            title: Text(
              artisan,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text(
              dateTime(DateTime.now()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  artisanName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SvgPicture.asset('assets/svg/userImage.svg')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
