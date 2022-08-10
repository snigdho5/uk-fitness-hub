import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/auth_providers.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';
import 'package:ukfitnesshub/views/custom/custom_text_field.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _onSubmit() async {
    final userProfileRef = ref.read(userHiveProvider);
    final user = userProfileRef.getUser();
    if (user != null) {
      EasyLoading.show(status: 'loading...');
      await AuthProvider.changePassword(
        newPassword: _newPasswordController.text.trim(),
        oldPassword: _passwordController.text.trim(),
        token: user.token,
        userId: user.id,
      ).then((value) async {
        if (value) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: customAppBar(context,
            title: "Change Password", showActionButtons: false),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    controller: _passwordController,
                    title: "Old Password",
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
                    controller: _newPasswordController,
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
                    title: "Confirm Password",
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      } else if (value != _newPasswordController.text) {
                        return "Password does not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: kDefaultPadding * 2),
                  CustomButton(
                      text: "Submit",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _onSubmit();
                        }
                      }),
                  const SizedBox(height: kDefaultPadding * 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
