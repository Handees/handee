import 'package:flutter/material.dart';
import 'package:handees/apps/customer_app/features/history/model/history.dart';
import 'package:handees/shared/data/handees/job_category.dart';
import 'package:handees/shared/ui/widgets/service_state.dart';
import 'package:intl/intl.dart';

import 'history_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<HistoryModel> history = [
      HistoryModel(
          jobCategory: JobCategory.automobile,
          date: DateTime.utc(2022, 6, 29),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.carpentry,
          date: DateTime.utc(2022, 7, 1),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.clothing,
          date: DateTime.utc(2022, 7, 15),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.gardening,
          date: DateTime.utc(2022, 7, 30),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.generatorRepair,
          date: DateTime.utc(2023, 6, 5),
          state: const ServiceStateWidget.canceled()),
      HistoryModel(
          jobCategory: JobCategory.hairStyling,
          date: DateTime.utc(2023, 6, 20),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.housekeeping,
          date: DateTime.utc(2023, 6, 25),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.laundry,
          date: DateTime.utc(2023, 7, 10),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.plumbing,
          date: DateTime.utc(2023, 7, 15),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.tvCableEngineer,
          date: DateTime.utc(2023, 7, 30),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.welding,
          date: DateTime.utc(2024, 6, 1),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.generatorRepair,
          date: DateTime.utc(2024, 6, 15),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.carpentry,
          date: DateTime.utc(2022, 6, 9),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.clothing,
          date: DateTime.utc(2022, 6, 19),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.gardening,
          date: DateTime.utc(2022, 6, 29),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.generatorRepair,
          date: DateTime.utc(2022, 6, 9),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.hairStyling,
          date: DateTime.utc(2022, 6, 19),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.housekeeping,
          date: DateTime.utc(2022, 6, 29),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.laundry,
          date: DateTime.utc(2022, 6, 9),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.plumbing,
          date: DateTime.utc(2022, 6, 19),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.tvCableEngineer,
          date: DateTime.utc(2022, 6, 29),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.welding,
          date: DateTime.utc(2022, 6, 9),
          state: const ServiceStateWidget.completed()),
      HistoryModel(
          jobCategory: JobCategory.generatorRepair,
          date: DateTime.utc(2022, 6, 19),
          state: const ServiceStateWidget.completed()),
    ];
    Map<String, List<HistoryModel>> groupedHistory = {};
    for (var item in history) {
      String month = DateFormat('MMMM yyyy').format(item.date);
      // '${item.date.month} ${item.date.year}';
      if (!groupedHistory.containsKey(month)) {
        groupedHistory[month] = [];
      }
      groupedHistory[month]!.add(item);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lavorh services'),
      ),
      body: ListView.builder(
        itemCount: groupedHistory.length,
        itemBuilder: (context, index) {
          String month = groupedHistory.keys.elementAt(index);
          List<HistoryModel> monthHistory = groupedHistory[month]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  month,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: monthHistory.length,
                itemBuilder: (context, index) {
                  HistoryModel item = monthHistory[index];
                  return HistoryTile(history: item);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
