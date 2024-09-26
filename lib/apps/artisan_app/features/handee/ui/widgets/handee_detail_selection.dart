import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/artisan_app/features/handee/providers/handee-details.provider.dart';
import 'package:handees/apps/artisan_app/features/handee/ui/widgets/confirmation_bottom_sheets.dart';
import 'package:handees/shared/data/handees/handee_options.dart';
import 'package:handees/shared/utils/utils.dart';

class HandeeDetailSelection extends ConsumerWidget {
  final String title;
  final Icon titleIcon;
  final List<HandeeOption> options;
  final String type;
  const HandeeDetailSelection(
      {required this.title,
      required this.titleIcon,
      required this.options,
      required this.type,
      super.key});

  void launchBottomSheet(String option, BuildContext context) {
    switch (option) {
      case WorkDurationTypes.oneTime:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (sheetCtx) {
            return OneTimeConfirmationBottomSheet(
              sheetContext: sheetCtx,
            );
          },
        );
        break;
      case WorkDurationTypes.contract:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (sheetCtx) {
            return ContractConfirmationBottomSheet(
              sheetContext: sheetCtx,
            );
          },
        );
        break;
      case PaymentOptionTypes.hourly:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (sheetCtx) {
            return AmountConfirmationBottomSheet(
              sheetContext: sheetCtx,
            );
          },
        );
        break;
      case PaymentOptionTypes.negotiated:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (sheetCtx) {
            return AmountConfirmationBottomSheet(
              sheetContext: sheetCtx,
            );
          },
        );
        break;
    }
  }

  Widget getActiveDescription(String option, WidgetRef ref) {
    final handeeApproval = ref.read(handeeApprovalDetailsProvider);
    switch (option) {
      case WorkDurationTypes.oneTime:
        return Text(
          '${handeeApproval.duration!} hours',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        );
      case WorkDurationTypes.contract:
        return Text(
          '${handeeApproval.duration!} ${handeeApproval.durationUnit}',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        );
      case PaymentOptionTypes.hourly:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₦${handeeApproval.settlement.amount}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            if (handeeApproval.workDurationType == WorkDurationTypes.oneTime)
              Text(
                'Total: ₦${handeeApproval.settlement.amount * handeeApproval.duration!}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
          ],
        );
      case PaymentOptionTypes.negotiated:
        return Text(
          '₦${handeeApproval.settlement.amount}',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String handeeOption = type == HandeeOptionTypes.workDuration
        ? ref.watch(handeeApprovalDetailsProvider).workDurationType
        : type == HandeeOptionTypes.paymentOption
            ? ref.watch(handeeApprovalDetailsProvider).settlement.paymentType
            : '';

    return Column(
      children: [
        Container(
          color: getHexColor('f3f3f4'),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
          child: Row(
            children: [
              titleIcon,
              const SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: getHexColor('B9B9BB'),
                    ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: options
                .map<Widget>(
                  (option) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      child: DurationOption(
                        isSelected: handeeOption == option.title,
                        title: option.title,
                        description: option.description,
                        activeDescription:
                            getActiveDescription(option.title, ref),
                        onTap: () {
                          type == HandeeOptionTypes.workDuration
                              ? ref
                                  .read(handeeApprovalDetailsProvider.notifier)
                                  .updateWorkDuration(option.title)
                              : type == HandeeOptionTypes.paymentOption
                                  ? ref
                                      .read(handeeApprovalDetailsProvider
                                          .notifier)
                                      .updatePaymentOption(option.title)
                                  : null;
                          launchBottomSheet(option.title, context);
                        },
                      )),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class DurationOption extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String description;
  final Widget activeDescription;
  final void Function() onTap;
  const DurationOption(
      {required this.isSelected,
      required this.title,
      required this.description,
      required this.onTap,
      required this.activeDescription,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
          contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 3,
              ),
              isSelected
                  ? activeDescription
                  : Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: getHexColor('a4a1a1'),
                          ),
                    ),
            ],
          ),
          trailing: isSelected
              ? const Icon(Icons.done)
              : const SizedBox(
                  width: 20,
                )),
    );
  }
}
