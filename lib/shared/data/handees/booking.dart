import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handees/shared/data/user/models/api_user.model.dart';
import 'package:handees/shared/data/user/models/artisan.model.dart';

class Booking {
  final String bookingId;
  final ArtisanModel? artisan;
  final ApiUserModel? artisanUserInfo;
  final LatLng? artisanInitialLocation;

  Booking(
      {required this.bookingId,
      required this.artisan,
      required this.artisanUserInfo,
      this.artisanInitialLocation});

  Booking.fromJson(Map<String, dynamic> json)
      : bookingId = json["booking_id"],
        artisan = ArtisanModel.fromJson(json["artisan"]),
        artisanUserInfo =
            ApiUserModel.fromJson(json["artisan"]["user_profile"]),
        artisanInitialLocation =
            LatLng(json["artisan_lat"], json["artisan_lon"]);

  Booking.empty()
      : bookingId = "",
        artisan = null,
        artisanUserInfo = ApiUserModel.empty(),
        artisanInitialLocation = null;
}
