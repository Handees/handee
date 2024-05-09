import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'brush_Icon.widget.dart';

class ArtisanInfoWidget extends ConsumerWidget {
  const ArtisanInfoWidget({super.key});

  final String artisan = 'Hair stylist';
  final String artisanName = 'John Doe';
  final String artisanPhotoPath = '';
  String dateTime(DateTime dateTime) {
    return DateFormat('MMM, yy, h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String assetName = 'assets/png/profile_photo.png';
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
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: brushIconWidget(),
            title: Text(
              artisan,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              dateTime(DateTime.now()),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[500]),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  artisanName,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[500]),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  height: 32,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(5),
                  child: Image.asset(
                    assetName,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
