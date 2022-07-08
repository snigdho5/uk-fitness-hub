import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/helper/config_loading.dart';
import 'package:ukfitnesshub/views/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(HiveConstants.hiveBox);
  configLoading();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    //Delay for splash screen

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    });

    super.initState();
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

// class LandingWidget extends ConsumerWidget {
//   final Widget child;
//   const LandingWidget({
//     Key? key,
//     required this.child,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final loginFuture = ref.read(loginProvider);
//     final userFuture = ref.read(userProvider);
//     final UserProfileModel? savedUser = userFuture.getUserProfileModel();

//     if (savedUser == null) {
//       return const LoginPage();
//     } else {
//       return FutureBuilder<bool>(
//         future: loginFuture.checkLoggedInUser(savedUser),
//         builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//           if (snapshot.hasData && snapshot.data != null) {
//             if (snapshot.data!) {
//               return child;
//             } else {
//               return const LoginPage();
//             }
//           } else {
//             return Scaffold(
//               appBar: AppBar(
//                 title: const Text(appName),
//                 centerTitle: true,
//               ),
//               body: const Center(
//                   child: CircularProgressIndicator(color: primaryColor)),
//             );
//           }
//         },
//       );
//     }
//   }
// }

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
    textTheme: GoogleFonts.ralewayTextTheme(baseTheme.textTheme),
  );
}
