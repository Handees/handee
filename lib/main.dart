import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handees/apps/customer_app/features/home/providers/user.provider.dart';

import 'package:handees/shared/routes/routers.dart';
import 'package:handees/shared/services/auth_service.dart';
import 'package:logger/logger.dart';

import 'firebase_options.dart';
import 'shared/theme/theme.dart';

import 'package:stack_trace/stack_trace.dart' as stack_trace;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  Logger.level = Level.debug;

  HttpOverrides.global = MyHttpOverrides();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  GoogleFonts.config.allowRuntimeFetching = true;

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));

  // final GoogleMapsFlutterPlatform mapsImplementation =
  //     GoogleMapsFlutterPlatform.instance;

  // AndroidMapRenderer mapRenderer = AndroidMapRenderer.platformDefault;
  // if (mapsImplementation is GoogleMapsFlutterAndroid) {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   mapRenderer = await mapsImplementation
  //       .initializeWithRenderer(AndroidMapRenderer.latest);
  // }

  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  final container = ProviderContainer();

  // All async calls that must be made to allow the app function properly should be put here

  // START

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseAppCheck.
  await FirebaseAppCheck.instance.activate();

  // Get the firebase user object token
  await AuthService.instance.getToken();

  // Fetch the user object from the backend if a user exists
  if (AuthService.isAuthenticated()) {
    await container.read(userProvider.notifier).getUserObject();
  }

  // END
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Handees',
      theme: buildTheme(lightColorScheme),
      // darkTheme: darkTheme,

      onGenerateRoute: mainRouter.onGenerateRoute,
      key: mainRouter.navigatorKey,
    );
  }
}
