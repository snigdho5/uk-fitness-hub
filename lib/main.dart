import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/helper/config_loading.dart';
import 'package:ukfitnesshub/providers/country_provider.dart';
import 'package:ukfitnesshub/providers/settings_provider.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/auth/login_page.dart';
import 'package:ukfitnesshub/views/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await Hive.initFlutter();
  await Hive.openBox(HiveConstants.hiveBox);
  configLoading();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    initalize();

    super.initState();
  }

  Future<void> initalize() async {
    await Future.wait([
      ref.read(countriesProvider).getCountries(),
      ref.read(settingsProvider).getSettings(),
    ]).then((value) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LandingWidget(),
          ),
        );
      });
    }).onError((error, stackTrace) {
      EasyLoading.showToast(
        "There is an error!\nPlease try again later.",
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(splash),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class LandingWidget extends ConsumerWidget {
  const LandingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileRef = ref.watch(userHiveProvider);
    final user = userProfileRef.getUser();

    return user == null ? const LoginPage() : Wrapper(userProfileModel: user);
  }
}

final _primarySwatch = MaterialColor(primaryColor.value, _swatch);
final _swatch = {
  50: primaryColor.withOpacity(0.1),
  100: primaryColor.withOpacity(0.2),
  200: primaryColor.withOpacity(0.3),
  300: primaryColor.withOpacity(0.4),
  400: primaryColor.withOpacity(0.5),
  500: primaryColor.withOpacity(0.6),
  600: primaryColor.withOpacity(0.7),
  700: primaryColor.withOpacity(0.8),
  800: primaryColor.withOpacity(0.9),
  900: primaryColor.withOpacity(1),
};

ThemeData _buildTheme(Brightness brightness) {
  var baseTheme = ThemeData(
    brightness: brightness,
    primarySwatch: _primarySwatch,
    appBarTheme: const AppBarTheme(elevation: 0),
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.oswaldTextTheme(baseTheme.textTheme),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


// 01864 034646