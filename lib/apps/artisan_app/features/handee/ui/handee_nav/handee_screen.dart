import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handees/apps/artisan_app/features/handee/providers/artisan-handees.provider.dart';
import 'package:handees/apps/artisan_app/features/handee/ui/widgets/stars.dart';
import 'package:handees/shared/utils/utils.dart';

class HandeeNavScreen extends ConsumerWidget {
  const HandeeNavScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artisanHandees = ref.watch(artisanHandeesProvider);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0.0,
          title: Text(
            'Handees',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: artisanHandees.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/svg/spanners.svg'),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'No Handees Yet',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 18),
                      )
                    ],
                  ),
                ),
              )
            : ListView.builder(
                itemBuilder: (context, idx) {
                  final handee = artisanHandees[idx];
                  return ListTile(
                    leading: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          handee.customerName,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const HandeeStars(count: 2, height: 10, width: 70)
                      ],
                    ),
                    trailing: SizedBox(
                      width: 155,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                handee.isCompleted ? 'Completed' : 'Cancelled',
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                dateToString(handee.date),
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          handee.isCompleted
                              ? SvgPicture.asset('assets/svg/circle-check.svg')
                              : SvgPicture.asset('assets/svg/circle-cancel.svg')
                        ],
                      ),
                    ),
                  );
                },
                itemCount: artisanHandees.length,
              ));
  }
}
