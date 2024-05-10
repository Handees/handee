import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
          icon: Icon(Icons.close),
        ),
        centerTitle: true,
        title: Text(
          'Get Help',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArtisanInfoWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: getHelpListTile(context,
                  onTap: () {},
                  text: 'Select an older service',
                  textStyle: Theme.of(context).textTheme.titleMedium),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 15, top: 25, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get help with something else',
                      style: Theme.of(context).textTheme.titleMedium
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    getHelpListTile(context,
                        onTap: () {},
                        text: 'About Lavorh',
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        padding: EdgeInsets.zero),
                    Divider(
                        color: Theme.of(context).dividerColor
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: getHelpListTile(context,
                          onTap: () {},
                          text: 'App and features',
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                          padding: EdgeInsets.zero),
                    ),
                    Divider(
                       color: Theme.of(context).dividerColor,
                    ),
                    getHelpListTile(context,
                        onTap: () {},
                        text: 'Account and data',
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        padding: EdgeInsets.zero),
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
