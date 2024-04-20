import 'package:handees/shared/data/handees/job_category.dart';

abstract class KYCStatus {
  static const String uninitialized = 'UNINITIALIZED';
  static const String inProgress = 'IN_PROGRESS';
  static const String completed = 'COMPLETED';
}

class ArtisanModel {
  final String artisanId;
  // final DateTime artisanCreatedAt;
  final double hourlyRate;
  final bool isVerified;
  final JobCategory? jobCategory;
  final String jobTitle;
  final int jobsCompleted;
  String kycStatus;
  // TODO: Add ratings back
  //final List<double> ratings;
  final DateTime artisanSignupDate;

  ArtisanModel({
    required this.artisanId,
    // required this.artisanCreatedAt,
    required this.hourlyRate,
    required this.isVerified,
    required this.jobCategory,
    required this.jobTitle,
    required this.jobsCompleted,
    // required this.ratings,
    required this.artisanSignupDate,
    this.kycStatus = KYCStatus.uninitialized,
  });

  ArtisanModel.fromJson(Map<String, dynamic> json)
      : artisanId = json["artisan_id"],
        //artisanCreatedAt = DateTime.parse(json["created_at"]),
        hourlyRate = json["hourly_rate"],
        //TODO: Correct the line below
        isVerified = json['is_verified'],
        //json["is_verified"],
        //jobCategory = jobCategoriesMap[json["job_category_id"]],
        jobCategory = JobCategory.values
            .firstWhere((category) => category.id == json["job_category"]),
        jobTitle = json["job_title"] ?? "",
        jobsCompleted = json["jobs_completed"],
        //  ratings = List<double>.from(json["ratings"] as List),
        artisanSignupDate = DateTime.parse(json["sign_up_date"]),
        kycStatus = json['kyc_status'];

  ArtisanModel.empty()
      : artisanId = "",
        //artisanCreatedAt = DateTime.parse(json["created_at"]),
        hourlyRate = 0,
        isVerified = false,
        //json["is_verified"],
        //jobCategory = jobCategoriesMap[json["job_category_id"]],
        jobCategory = null,
        jobTitle = "",
        jobsCompleted = 0,
        //  ratings = List<double>.from(json["ratings"] as List),
        artisanSignupDate = DateTime.now(),
        kycStatus = "";

  ArtisanModel copyWith({
    String? artisanId,
    double? hourlyRate,
    bool? isVerified,
    JobCategory? jobCategory,
    String? jobTitle,
    int? jobsCompleted,
    String? kycStatus,
    DateTime? artisanSignupDate,
  }) {
    return ArtisanModel(
      artisanId: artisanId ?? this.artisanId,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      isVerified: isVerified ?? this.isVerified,
      jobCategory: jobCategory ?? this.jobCategory,
      jobTitle: jobTitle ?? this.jobTitle,
      jobsCompleted: jobsCompleted ?? this.jobsCompleted,
      artisanSignupDate: artisanSignupDate ?? this.artisanSignupDate,
      kycStatus: kycStatus ?? this.kycStatus,
    );
  }
}
