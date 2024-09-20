import 'package:flutter/material.dart';
import 'package:handees/apps/customer_app/features/history/model/history.dart';
import 'package:handees/shared/res/shapes.dart';
import 'package:intl/intl.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({
    Key? key,
    required this.history,
  }) : super(key: key);

  final HistoryModel history;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SizedBox(
          height: 80.0,
          child: Row(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: history.jobCategory.foregroundColor.withOpacity(0.2),
                  shape: Shapes.extraBigShape,
                ),
                height: 72,
                width: 72,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: history.jobCategory.foregroundColor,
                    child: Icon(history.jobCategory.icon),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              history.jobCategory.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              DateFormat('dd MMM').format(history.date),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 46.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          history.state,
                          Text(
                              DateFormat('dd MMM').format(history.date),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
        
            ],
          ),
        ),
      ),
    );
  }
}
