import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      width: 1.sw,
      padding: REdgeInsets.fromLTRB(15, 35, 15, 30),
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
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: Colors.black
            )
            // Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 20.h,
          ),
          ListTile(
            contentPadding: REdgeInsets.all(0),
            // EdgeInsets.zero,
            leading: brushIconWidget(),
            title: Text(
              artisan,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: Colors.black
              )
              // Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              dateTime(DateTime.now()),
              style:  TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12.sp,
                color:  Colors.grey[500]
            )
              // Theme.of(context)
              //     .textTheme
              //     .bodySmall
              //     ?.copyWith(color: Colors.grey[500]),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  artisanName,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color:  Colors.grey[500]
                  )
                  // Theme.of(context)
                  //     .textTheme
                  //     .bodySmall
                  //     ?.copyWith(color: Colors.grey[500]),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Container(
                  height: 32.h,
                  width: 30.w,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  padding: REdgeInsets.all(5),
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
