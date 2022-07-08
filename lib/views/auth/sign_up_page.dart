import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';
import 'package:ukfitnesshub/views/custom/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(); //Password
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //Name
  final _nameController = TextEditingController();
  //Age
  final _ageController = TextEditingController();
  //Weight
  final _weightController = TextEditingController();
  //Height
  final _heightController = TextEditingController();
  //Country
  final _countryController = TextEditingController();
  //Goal
  final _goalController = TextEditingController();
  //How did you hear about us?
  final _hearAboutUsController = TextEditingController();

  bool _isAcceptTerms = false;

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
              ListTile(
                leading: const BackButton(color: Colors.white),
                minLeadingWidth: 0,
                title: Text(
                  "Create an Account".toUpperCase(),
                  style: const TextStyle(
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
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: kDefaultPadding * 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding * 2),
                            child: Text(
                              "Please fill in this form to create an account",
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
                            controller: _nameController,
                            title: "Your Name",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomTextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            title: "Your Email",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomTextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            title: "Your Password",
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your password";
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
                          CustomTextFormField(
                            controller: _ageController,
                            isNumber: true,
                            keyboardType: TextInputType.number,
                            title: "Your Age",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your age";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomTextFormField(
                            controller: _weightController,
                            isNumber: true,
                            keyboardType: TextInputType.number,
                            title: "Your Weight",
                            suffix: "kg",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your weight";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomTextFormField(
                            controller: _heightController,
                            isNumber: true,
                            keyboardType: TextInputType.number,
                            title: "Your Height",
                            suffix: "cm",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your height";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomTextFormField(
                            controller: _countryController,
                            title: "Your Country",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your country";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomTextFormField(
                            controller: _goalController,
                            title: "Your Goal",
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomTextFormField(
                            controller: _hearAboutUsController,
                            title: "How did you hear about us?",
                          ),
                          const SizedBox(height: kDefaultPadding),
                          ListTile(
                            trailing: Switch(
                                value: _isAcceptTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _isAcceptTerms = value;
                                  });
                                }),
                            title: Text(
                              "I accept the terms and conditions",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Theme.of(context).disabledColor,
                                      fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomButton(
                            text: "Create Account",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_isAcceptTerms) {
                                  print("Form is valid");
                                } else {
                                  print("Please accept terms and conditions");
                                }
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
