import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/artisan_app/features/handee/ui/widgets/dashes.dart';
import 'package:handees/apps/artisan_app/features/home/ui/home_nav/widgets/icon_avatar.dart';
import 'package:handees/shared/utils/utils.dart';

class ContractHandeeInProgress extends ConsumerWidget {
  const ContractHandeeInProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: getHexColor('14161c'),
        ),
        body: Container(
          color: getHexColor('14161c'),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(left: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: getHexColor('039C53'),
                    ),
                    child: const Text(
                      'In progress',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        const Row(
                          children: [
                            IconAvatar(),
                            SizedBox(width: 16.0),
                            Text(
                              "Jane Foster",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.access_alarm,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            const Text(
                              'Contract',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color.fromRGBO(255, 255, 255, .1),
                              ),
                              child: const Text(
                                '3 Weeks',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 40, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                            color: getHexColor('f5f5f5'),
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color.fromRGBO(20, 22, 28, .1),
                                ),
                                borderRadius: BorderRadius.circular(27),
                              ),
                              child: const Icon(
                                Icons.build,
                                color: Color.fromRGBO(20, 22, 28, .2),
                              ),
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            Flexible(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 270),
                                child: const Text(
                                  'My freezer is broken, I need help with it. It’s a deep freezer. Thermocool',
                                  style: TextStyle(
                                    color: Color.fromRGBO(20, 22, 28, .5),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color.fromRGBO(20, 22, 28, .1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '04-09-2023',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(20, 22, 28, .5),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: getHexColor('14161c'),
                              ),
                              child: const Text(
                                '03:40:06',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Text(
                              '2:00PM - 5:40PM',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(20, 22, 28, .5),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              width: 80,
                              child: FilledButton(
                                onPressed: () {},
                                style: const ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.all(8),
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Color.fromRGBO(20, 22, 28, 0.1),
                                  ),
                                ),
                                child: const Text(
                                  'Clock out',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Dashes(
                          height: 48,
                          color: getHexColor('14161c'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color.fromRGBO(20, 22, 28, .1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '04-09-2023',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(20, 22, 28, .5),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: getHexColor('14161c'),
                              ),
                              child: const Text(
                                '03:40:06',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Text(
                              '2:00PM - 5:40PM',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(20, 22, 28, .5),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              width: 80,
                              child: FilledButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  padding: const WidgetStatePropertyAll(
                                    EdgeInsets.all(8),
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    getHexColor('418DF4'),
                                  ),
                                ),
                                child: const Text(
                                  'Clock out',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              getHexColor('14161c'),
                            ),
                          ),
                          onPressed: () {},
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
              )
            ],
          ),
        ));
  }
}
