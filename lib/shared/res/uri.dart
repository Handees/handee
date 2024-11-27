import 'package:handees/shared/res/constants.dart';

abstract class AppUris {
  static final rootUri = Uri.https(
    AppConstants.url,
    '/',
  );

  static final customerSocketUri = Uri.https(
    AppConstants.url,
    '/customer',
  );

  static final artisanSocketUri = Uri.https(
    AppConstants.url,
    '/artisan',
  );

  static final chatSocketUri = Uri.https(
    AppConstants.url,
    '/chat',
  );

  static final addNewUserUri = Uri.https(
    AppConstants.url,
    '/api/user/',
  );

  static final addNewArtisanUri = Uri.https(
    AppConstants.url,
    '/api/user/artisan/',
  );
  static final submitKycUri = Uri.https(
    AppConstants.url,
    '/api/user/artisan/kyc',
  );

  static final bookServiceUri = Uri.https(
    AppConstants.url,
    '/api/bookings/',
  );

  static final paymentsUri = Uri.https(
    AppConstants.url,
    '/api/payments/',
  );

  static Uri userDataUri = Uri.https(
    AppConstants.url,
    '/api/user/signin',
  );
}
