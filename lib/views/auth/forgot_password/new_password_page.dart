import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/auth_providers.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';
import 'package:ukfitnesshub/views/custom/custom_text_field.dart';

class NewPasswordPage extends ConsumerStatefulWidget {
  final ForgorPasswordData data;
  const NewPasswordPage({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends ConsumerState<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _onResetPassword() async {
    EasyLoading.show(status: 'Resetting Password...');
    await AuthProvider.resetPassword(
            userId: widget.data.userId,
            otp: _otpController.text.trim(),
            newPassword: _passwordController.text.trim())
        .then((value) {
      if (value) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("OTP: ${widget.data.otp}");
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
                  "New Password",
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
                              "Enter the OTP sent to your email address and set your new password",
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
                            controller: _otpController,
                            isNumber: true,
                            keyboardType: TextInputType.number,
                            title: "OTP",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter valid OTP";
                              } else if (value != widget.data.otp) {
                                return "Pleae enter the OTP sent to your email address";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomTextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            title: "New Password",
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
                          const SizedBox(height: kDefaultPadding),
                          CustomTextFormField(
                            controller: _confirmPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            title: "Confirm Password",
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please confirm your password";
                              }
                              if (value != _passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomButton(
                            text: "Reset Password",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _onResetPassword();
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
