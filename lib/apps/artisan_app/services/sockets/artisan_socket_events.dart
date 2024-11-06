abstract class ArtisanSocketListenEvents {
  static const String newOffer = 'new_offer';
  static const String jobDetailsConfirmed = 'job_details_confirmed';
  static const String jobDetailsRejected = 'job_details_rejected';
}

abstract class ArtisanSocketEmitEvents {
  static const String locationUpdate = 'location_update';
  static const String artisanArrived = 'arrived_location';
  static const String acceptOffer = 'accept_offer';
  static const String cancelOffer = 'cancel_offer';
  static const String requestCustomerApproval = 'request_customer_approval';
  static const String startJob = "start_job";
}
