import 'package:flutter/material.dart';
import 'package:handees/apps/artisan_app/features/handee/ui/widgets/confirm_amount_dialog.dart';
import 'package:handees/apps/artisan_app/features/home/ui/home_nav/widgets/icon_avatar.dart';
import 'package:handees/shared/utils/utils.dart';

class HandeeInProgressScreen extends StatelessWidget {
  const HandeeInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('In Progress'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 37),
                  decoration: BoxDecoration(
                    color: getHexColor('f6f6f6'),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Row(
                        children: [
                          IconAvatar(),
                          SizedBox(width: 16.0),
                          Text(
                            "Jane Foster",
                            style: TextStyle(
                              color: Color(0xff949494),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.build_outlined,
                              color: Color(0xff949494),
                            ),
                            SizedBox(
                              width: 22,
                            ),
                            Text(
                              'Additional Information',
                              style: TextStyle(
                                color: Color(0xff949494),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.payment,
                              color: Color(0xff949494),
                            ),
                            SizedBox(
                              width: 22,
                            ),
                            Text(
                              'Card Transaction',
                              style: TextStyle(
                                color: Color(0xff949494),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.alarm,
                              color: Color(0xff949494),
                            ),
                            SizedBox(
                              width: 22,
                            ),
                            Text(
                              'Contract',
                              style: TextStyle(
                                color: Color(0xff949494),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(999),
                      ),
                      color: getHexColor('14161c'),
                    ),
                    child: Center(
                      child: Text(
                        '00 : 03 : 43',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        getHexColor('cc4b4b'),
                      ),
                    ),
                    onPressed: () => showDialog(
                        useRootNavigator: false,
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return const ConfirmAmountDialog();
                        }),
                    child: const Text(
                      'END HANDEE',
                      style: TextStyle(
                        letterSpacing: .64,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
