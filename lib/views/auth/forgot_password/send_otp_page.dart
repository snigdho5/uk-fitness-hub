import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/auth_providers.dart';
import 'package:ukfitnesshub/views/auth/forgot_password/new_password_page.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';
import 'package:ukfitnesshub/views/custom/custom_text_field.dart';

class SendOtpPage extends ConsumerStatefulWidget {
  const SendOtpPage({super.key});

  @override
  ConsumerState<SendOtpPage> createState() => _SendOtpPageState();
}

class _SendOtpPageState extends ConsumerState<SendOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(); //Password

  void _onSendEmail() async {
    EasyLoading.show(status: 'Sending OTP...');
    await AuthProvider.forgotPassword(_emailController.text.trim())
        .then((value) {
      if (value != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return NewPasswordPage(data: value);
        }));
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(bg), fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: kDefaultPadding * 5),
              const ListTile(
                leading: BackButton(color: Colors.white),
                minLeadingWidth: 0,
                title: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: kDefaultPadding * 2),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(kDefaultPadding),
                      topRight: Radius.circular(kDefaultPadding),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(kDefaultPadding * 2),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: kDefaultPadding),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding * 2),
                            child: Text(
                              "Enter your email address to receive OTP",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Theme.of(context).disabledColor,
                                      fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(height: kDefaultPadding * 2),
                          CustomTextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            title: "Your Email",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your email";
                              } else if (!value.contains("@") ||
                                  !value.contains(".")) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomButton(
                            text: "Send OTP",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _onSendEmail();
                              }
                            },
                          ),
                          const SizedBox(height: kDefaultPadding * 2),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
