abstract class CustomerSocketListenEvents {
  static const String bookingOfferAccepted = 'booking_offer_accepted';
  static const String jobDetailsAlreadyConfirmed =
      'job_details_already_confirmed';
  static const String offerCancelled = 'offer_cancelled';
  static const String approveBookingDetails = "approve_booking_details";
  static const String artisanArrived = "artisan_arrived";
  static const String artisanLocationUpdate = "artisan_location_update";
  static const String jobStarted = "job_started";
}

abstract class CustomerSocketEmitEvents {
  static const String cancelOffer = 'cancel_offer';
  static const String confirmJobDetails = 'confirm_job_details';
  static const String rejectJobDetails = 'reject_job_details';
}
