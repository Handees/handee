import 'package:flutter/material.dart';
import 'package:handees/apps/customer_app/features/tracker/ui/arrived_bottom_sheet.dart';

class OngoingServiceHeader extends StatelessWidget {
  const OngoingServiceHeader({
    Key? key,
    required this.horizontalPadding,
  }) : super(key: key);

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ongoing Handee',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '00 : 03 : 43',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        const Spacer(flex: 1),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ),
          child: const ProgressCard(),
        ),
        const Spacer(flex: 3),
        const Divider(
          thickness: 8.0,
          height: 0.0,
        ),
      ],
    );
  }
}
