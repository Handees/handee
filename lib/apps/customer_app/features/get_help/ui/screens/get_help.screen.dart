import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handees/apps/customer_app/features/get_help/ui/widgets/get_help_Listtile.widget.dart';
import 'package:handees/apps/customer_app/features/get_help/ui/widgets/get_help_artisan_info.widget.dart';

class GetHelpScreen extends StatelessWidget {
  const GetHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop,
          icon: const Icon(Icons.close),
        ),
        centerTitle: true,
        title: Text('Get Help',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
                color: Colors.black)
            // Theme.of(context).textTheme.titleLarge,
            ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ArtisanInfoWidget(),
            Padding(
                padding: REdgeInsets.symmetric(vertical: 5.0),
                child: getHelpListTile(
                  context,
                  onTap: () {},
                  text: 'Select an older service',
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: Colors.black),
                )
                // Theme.of(context).textTheme.titleMedium),
                ),
            Expanded(
              child: Container(
                width: 1.sw,
                color: Colors.white,
                padding: REdgeInsets.only(left: 15, top: 25, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get help with something else',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Colors.black),
                      // Theme.of(context).textTheme.titleMedium
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    getHelpListTile(context,
                        onTap: () {},
                        text: 'About Lavorh',
                        textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.sp,
                            color: Colors.black),
                        // Theme.of(context).textTheme.bodyMedium,
                        padding: REdgeInsets.all(0)),
                    Divider(color: Colors.grey[300]
                        // Theme.of(context).dividerColor
                        ),
                    Padding(
                      padding: REdgeInsets.symmetric(vertical: 4.0),
                      child: getHelpListTile(context,
                          onTap: () {},
                          text: 'App and features',
                          textStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.sp,
                              color: Colors.black),
                          // Theme.of(context).textTheme.bodyMedium,
                          padding: REdgeInsets.all(0)),
                    ),
                    Divider(color: Colors.grey[300]
                        // Theme.of(context).dividerColor,
                        ),
                    getHelpListTile(context,
                        onTap: () {},
                        text: 'Account and data',
                        textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.sp,
                            color: Colors.black),
                        // Theme.of(context).textTheme.bodyMedium,
                        padding: REdgeInsets.all(0)),
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
