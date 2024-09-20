import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/artisan_app/features/handee/providers/handee-details.provider.dart';
import 'package:handees/apps/artisan_app/features/handee/ui/widgets/tab_selector.dart';
import 'package:handees/shared/data/handees/handee_options.dart';
import 'package:handees/shared/ui/widgets/custom_bottom_sheet.dart';
import 'package:handees/shared/ui/widgets/custom_text_form_field.dart';
import 'package:handees/shared/utils/utils.dart';

class OneTimeConfirmationBottomSheet extends ConsumerWidget {
  final BuildContext sheetContext;
  const OneTimeConfirmationBottomSheet({required this.sheetContext, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handeeApproval = ref.watch(handeeApprovalDetailsProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CustomBottomSheet(
        title: 'One Time',
        text: "Please provide the time duration suitable for this Handee",
        content: Column(
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Hours',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 38,
                  child: FilledButton(
                    onPressed: handeeApproval.duration! > 0
                        ? () => ref
                            .read(handeeApprovalDetailsProvider.notifier)
                            .updateDuration(ref
                                    .read(handeeApprovalDetailsProvider)
                                    .duration! -
                                1)
                        : () {},
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            22,
                          ),
                        ),
                      ),
                    ),
                    child: const Icon(Icons.remove),
                  ),
                ),
                const SizedBox(width: 30),
                Text(
                  handeeApproval.duration.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  height: 38,
                  child: FilledButton(
                    onPressed: () => ref
                        .read(handeeApprovalDetailsProvider.notifier)
                        .updateDuration(
                            ref.read(handeeApprovalDetailsProvider).duration! +
                                1),
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            22,
                          ),
                        ),
                      ),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

class ContractConfirmationBottomSheet extends ConsumerWidget {
  final BuildContext sheetContext;
  ContractConfirmationBottomSheet({required this.sheetContext, super.key});

  final List<String> options = [DurationUnits.days, DurationUnits.weeks];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handeeApproval = ref.watch(handeeApprovalDetailsProvider);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CustomBottomSheet(
        title: 'Contract',
        text: "Please provide the time duration suitable for this Handee",
        content: Column(
          children: [
            const SizedBox(height: 16),
            DurationUnitTabSelector(options: options),
            const SizedBox(height: 30),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 38,
                  child: FilledButton(
                    onPressed: handeeApproval.duration! > 0
                        ? () => ref
                            .read(handeeApprovalDetailsProvider.notifier)
                            .updateDuration(ref
                                    .read(handeeApprovalDetailsProvider)
                                    .duration! -
                                1)
                        : () {},
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            22,
                          ),
                        ),
                      ),
                    ),
                    child: const Icon(Icons.remove),
                  ),
                ),
                const SizedBox(width: 30),
                Text(
                  handeeApproval.duration.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  height: 38,
                  child: FilledButton(
                    onPressed: () => ref
                        .read(handeeApprovalDetailsProvider.notifier)
                        .updateDuration(
                            ref.read(handeeApprovalDetailsProvider).duration! +
                                1),
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            22,
                          ),
                        ),
                      ),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

class AmountConfirmationBottomSheet extends ConsumerWidget {
  final BuildContext sheetContext;
  const AmountConfirmationBottomSheet({required this.sheetContext, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handeeApproval = ref.watch(handeeApprovalDetailsProvider);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CustomBottomSheet(
        title: 'Negotiated Amount',
        text:
            "Please provide the amount you have agreed to be paid for your services",
        content: Column(
          children: [
            const SizedBox(height: 16),
            CustomTextFormField(
              hintText: 'Amount',
              backgroundColor: getHexColor('F3F3F4'),
              defaultValue: handeeApproval.settlement.amount.toString(),
              textInputType: TextInputType.number,
              onFieldSubmitted: (newAmount) {
                if (newAmount != null && newAmount.isNotEmpty) {
                  dPrint(double.parse(newAmount));
                  ref
                      .read(handeeApprovalDetailsProvider.notifier)
                      .updatePaymentAmount(double.parse(newAmount));
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
