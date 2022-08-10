import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/auth_providers.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/auth/sign_up_page.dart';
import 'package:ukfitnesshub/views/bottom_nav_bar_page.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';
import 'package:ukfitnesshub/views/custom/custom_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLogin() async {
    final Map<String, String> data = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
    };
    EasyLoading.show(status: 'loading...');
    await AuthProvider.login(data: data).then((value) async {
      if (value != null) {
        final userProfileRef = ref.read(userHiveProvider);
        await userProfileRef.saveUser(value).then((value) {
          EasyLoading.dismiss();
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (context) => const BottomNavbarPage()),
          //   (Route<dynamic> route) => false,
          // );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: kDefaultPadding * 6),
                  Image.asset(loginBg,
                      height: MediaQuery.of(context).size.height * 0.3),
                  const SizedBox(height: kDefaultPadding * 3),
                  CustomTextFormField(
                    controller: _emailController,
                    title: "Your Email",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email";
                      } else if (!value.contains("@") || !value.contains(".")) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: kDefaultPadding),
                  CustomTextFormField(
                    controller: _passwordController,
                    title: "Your Password",
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: kDefaultPadding * 2),
                  CustomButton(
                      text: "Login",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _onLogin();
                        }
                      }),
                  const SizedBox(height: kDefaultPadding * 3),
                  Text(
                    "DON'T have an account?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.w900),
                  ),
                  // const SizedBox(height: kDefaultPadding),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                    },
                    child: Text(
                      "Sign UP for a quick account",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w900, color: primaryColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
