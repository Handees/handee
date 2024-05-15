import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/artisan_app/features/handee/providers/handee-details.provider.dart';
import 'package:handees/shared/utils/utils.dart';

class DurationUnitTabSelector extends ConsumerWidget {
  final List<String> options;
  const DurationUnitTabSelector({required this.options, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handeeApproval = ref.watch(handeeApprovalDetailsProvider);
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, .05),
        borderRadius: BorderRadius.all(
          Radius.circular(9),
        ),
      ),
      child: Row(
          children: options
              .map(
                (option) => handeeApproval.durationUnit == option
                    ? Expanded(
                        child: Container(
                          height: 46,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              capitalize(option),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: InkWell(
                          onTap: () => ref
                              .read(handeeApprovalDetailsProvider.notifier)
                              .updateDurationUnit(option),
                          child: SizedBox(
                            height: 46,
                            child: Center(
                              child: Text(
                                capitalize(option),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
              )
              .toList()),
    );
  }
}
