import 'package:handees/shared/data/handees/job_category.dart';
import 'package:handees/shared/ui/widgets/service_state.dart';

class HistoryModel {
  JobCategory jobCategory;
  DateTime date;
  ServiceStateWidget state;
  HistoryModel(
      {required this.jobCategory, required this.date, required this.state});
}
