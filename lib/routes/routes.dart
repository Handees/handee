abstract class AuthRoutes {
  static const String root = signin;
  static const String signin = '/auth/sign-in';
  static const String signup = '/auth/sign-up';
  static const String verify = '/auth/verify';
}

abstract class ArtisanAppRoutes {
  static const String root = home;

  static const String completeProfile = '/artisan/complete-profile';
  static const String basicInfo = '/artisan/complete-profile/basic-info';
  static const String documentUpload =
      '/artisan/complete-profile/document-upload';
  static const String validId =
      '/artisan/complete-profile/document-upload/valid-id';
  static const String passportPhotograph =
      '/artisan/complete-profile/document-upload/passport-photograph';
  static const String handeeDetails =
      '/artisan/complete-profile/handee-details';
  static const String paymentDetails =
      '/artisan/complete-profile/payment-details';

  static const String home = '/artisan/home';
}

abstract class CustomerAppRoutes {
  static const String root = home;

  static const String home = '/customer/home';
  static const String pickService = '/customer/pick-service';
  static const String tracking = '/customer/tracking';
  static const String chat = '/customer/chat';
  static const String notifications = '/customer/notifications';
  static const String history = '/customer/history';
  static const String help = '/customer/help';
  static const String helpDetails = '/customer/help-details';
  static const String profile = '/customer/profile';
  static const String editEmail = '/customer/profile/edit-email';
  static const String editAddress = '/customer/profile/edit-address';
  static const String editPrimary = '/customer/profile/edit-primary';

  static const String payments = '/customer/payments';
  static const String addCard = '/customer/payments/add-card';
  static const String verifyCode = '/customer/payments/verify';

  static const String settings = '/customer/settings';
  static const String support = '/customer/support';
  static const String servicesData = '/customer/services-data';
}
