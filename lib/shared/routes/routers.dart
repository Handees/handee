import 'package:flutter/material.dart';
import 'package:handees/apps/artisan_app/features/handee/ui/screens/confirm_handee.screen.dart';
import 'package:handees/apps/artisan_app/features/handee/ui/screens/contract_handee_in_progress.screen.dart';
import 'package:handees/apps/artisan_app/features/handee/ui/screens/handee_concluded.screen.dart';
import 'package:handees/apps/artisan_app/features/handee/ui/screens/handee_in_progress.screen.dart';
import 'package:handees/apps/artisan_app/features/handee/ui/screens/map_to_customer.screen.dart';
import 'package:handees/apps/artisan_app/features/profile/ui/screens/complete_profile.screen.dart';
import 'package:handees/apps/artisan_app/features/profile/ui/screens/basic_info.screen.dart';
import 'package:handees/apps/artisan_app/features/kyc/ui/screens/document_upload.screen.dart';
import 'package:handees/apps/artisan_app/features/profile/ui/screens/handee_details.screen.dart';
import 'package:handees/apps/artisan_app/features/kyc/ui/screens/passport_photograph.screen.dart';
import 'package:handees/apps/artisan_app/features/profile/ui/screens/payment_details.screen.dart';
import 'package:handees/apps/artisan_app/features/kyc/ui/screens/valid_id.screen.dart';
import 'package:handees/apps/artisan_app/features/chat/ui/screens/chat_screen.dart';
import 'package:handees/apps/artisan_app/features/home/ui/home.artisan.dart';
import 'package:handees/apps/artisan_app/features/withdrawal/ui/screens/earnings_screen.dart';
import 'package:handees/apps/customer_app/features/artisan_switch/ui/screens/artisan_switch.screen.dart';
import 'package:handees/apps/customer_app/features/profile/ui/edit_address.dart';
import 'package:handees/apps/customer_app/features/profile/ui/edit_email.dart';
import 'package:handees/apps/customer_app/features/profile/ui/edit_profile.dart';
import 'package:handees/shared/routes/pages.dart';
import 'package:handees/shared/services/auth_service.dart';
import 'package:handees/shared/services/user_data_service.dart';
import 'package:handees/shared/ui/widgets/navigator.dart';
import 'package:handees/apps/artisan_app/features/profile/ui/profileEdit_options_nav/profile.edit.options.dart';

import 'package:handees/shared/theme/theme.dart';
import 'package:handees/shared/utils/utils.dart';

import '../../apps/customer_app/features/review/ui/review.screen.dart';
import 'routes.dart';

final mainRouter = NavRouter(
  onGenerateRoute: (RouteSettings settings) {
    NavRouter? router;
    dPrint(settings.name);
    switch (settings.name) {
      case '/':
        {
          router = AuthService.isAuthenticated() &&
                  AuthService.isProfileComplete() &&
                  UserDataService.instance.doesUserExist
              ? _customerAppRouter
              : _authRouter;
          break;
        }

      case AuthRoutes.root:
        router = _authRouter;
        break;
      case CustomerAppRoutes.root:
        router = _customerAppRouter;
        break;
      case ArtisanAppRoutes.root:
        router = _artisanAppRouter;
        break;
      default:
    }

    return MaterialPageRoute(
      builder: (context) => RootNavigator(
        router: router!,
      ),
    );
  },
);

final _authRouter = NavRouter(
  onGenerateRoute: (RouteSettings settings) {
    Widget? page;

    switch (settings.name) {
      case '/':
      case AuthRoutes.root:
        page = SigninScreen();
        break;
      case AuthRoutes.signup:
        page = SignupScreen();
        break;
      // case AuthRoutes.verify:
      //   page = VerifyScreen();
      //   break;
      default:
    }

    return MaterialPageRoute(
      builder: (context) => Theme(
        data: authTheme,
        child: page!,
      ),
    );
  },
);

final _customerAppRouter = NavRouter(
  onGenerateRoute: (RouteSettings settings) {
    Widget? page;

    MaterialPageRoute? pageRoute;
    switch (settings.name) {
      case '/':
      case CustomerAppRoutes.root:
        page = const HomeScreen();
        break;
      case CustomerAppRoutes.profile:
        page = const ProfileScreen();
        break;
      case CustomerAppRoutes.notifications:
        page = const NotificationsScreen();
        break;
      case CustomerAppRoutes.history:
        page = const HistoryScreen();
        break;
      case CustomerAppRoutes.settings:
        page = const SettingsScreen();
        break;
      case CustomerAppRoutes.tracking:
        page = const TrackingScreen();
        break;
      case CustomerAppRoutes.chat:
        page = const ChatScreen();
        break;

      case CustomerAppRoutes.addCard:
        page = AddCardScreen();
        break;
      case CustomerAppRoutes.payments:
        page = const PaymentsScreen();
        break;
      case CustomerAppRoutes.verifyCode:
        page = const VerifyCodeScreen();
        break;
      case CustomerAppRoutes.editEmail:
        page = const EditEmail();
        break;
      case CustomerAppRoutes.editAddress:
        page = const EditAddress();
        break;
      case CustomerAppRoutes.editPrimary:
        page = const EditProfile();
        break;
      case CustomerAppRoutes.artisanSwitch:
        page = const ArtisanSwitchScreen();
        break;

      case CustomerAppRoutes.pickService:
        pageRoute = MaterialPageRoute(
          builder: ((context) => const PickServiceDialog()),
          fullscreenDialog: true,
        );
        break;
      case CustomerAppRoutes.review:
        page = const ReviewScreen();
        break;
      default:
        throw Exception('Unknown route: ${settings.name}');
    }
    return page != null
        ? MaterialPageRoute(
            builder: (context) => page!,
          )
        : pageRoute!;
  },
);

final _artisanAppRouter = NavRouter(
  onGenerateRoute: (RouteSettings settings) {
    Widget? page;

    debugPrint('ArtisanAppRouter working  ${settings.name}');

    switch (settings.name) {
      case "/":
      case ArtisanAppRoutes.root:
        page = const ArtisanHomeScreen();
        break;
      case ArtisanAppRoutes.completeProfile:
        page = ArtisanCompleteProfileScreen();
        break;
      case ArtisanAppRoutes.basicInfo:
        page = BasicInfoScreen();
        break;
      case ArtisanAppRoutes.documentUpload:
        page = const DocumentUploadScreen();
        break;
      case ArtisanAppRoutes.handeeDetails:
        page = const HandeeDetailsScreen();
        break;
      case ArtisanAppRoutes.paymentDetails:
        page = const PaymentDetailsScreen();
        break;
      case ArtisanAppRoutes.validId:
        page = const ValidIDScreen();
        break;
      case ArtisanAppRoutes.passportPhotograph:
        page = const PasspportPhotographScreen();
        break;
      case ArtisanAppRoutes.chat:
        page = const ArtisanChatScreen();
        break;
      case ArtisanAppRoutes.earnings:
        page = const ArtisanEarningsScreen();
        break;
      case ArtisanAppRoutes.transitToArtisan:
        page = const MapToCustomerScreen();
        break;
      case ArtisanAppRoutes.confirmHandee:
        page = const ConfirmHandeeScreen();
        break;
      case ArtisanAppRoutes.handeeInProgress:
        page = const HandeeInProgressScreen();
        break;
      case ArtisanAppRoutes.handeeConcluded:
        page = const HandeeConcludedScreen();
        break;
      case ArtisanAppRoutes.editProfile:
        page = const EditProfileOptions();
        break;
      case ArtisanAppRoutes.contractHandeeInProgress:
        page = const ContractHandeeInProgress();
        break;
      default:
        throw Exception('Unknown route: ${settings.name}');
    }
    //page = const MapToCustomerScreen();
    return MaterialPageRoute(
      builder: (context) => page!,
    );
  },
);

class NavRouter {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final Route<dynamic> Function(RouteSettings) onGenerateRoute;

  NavRouter({required this.onGenerateRoute});
}
