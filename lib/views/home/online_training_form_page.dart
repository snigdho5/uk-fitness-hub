import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/contact_with_travis_provider.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';
import 'package:ukfitnesshub/views/custom/custom_text_field.dart';

class OnlineTrainingFormPage extends ConsumerStatefulWidget {
  const OnlineTrainingFormPage({super.key});

  @override
  ConsumerState<OnlineTrainingFormPage> createState() =>
      _OnlineTrainingFormPageState();
}

class _OnlineTrainingFormPageState
    extends ConsumerState<OnlineTrainingFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _telephoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final userProfileRef = ref.watch(userHiveProvider);
      final user = userProfileRef.getUser();

      // await ContactWithTravisProvider.submit(
      //   name: name,
      //   email: email,
      //   phone: phone,
      //   maessage: maessage,
      //   userId: userId,
      //   token: token,
      // );

      if (user != null) {
        EasyLoading.show(status: 'Sending...');
        await ContactWithTravisProvider.submit(
          name: _nameController.text,
          email: _emailController.text,
          phone: _telephoneController.text,
          maessage: _messageController.text,
          userId: user.id,
          token: user.token,
        ).then((value) {
          if (value) {
            EasyLoading.showToast(
              'Your message has been sent successfully!',
              toastPosition: EasyLoadingToastPosition.bottom,
            );
            Navigator.of(context).pop();
          } else {
            EasyLoading.dismiss();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            contactImage,
            fit: BoxFit.cover,
          ),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const BackButton(color: Colors.white),
                      Expanded(
                        child: Text(
                          "Online Training with Travis".toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "UKFITNESS",
                          style: GoogleFonts.roboto(
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                          ),
                        ),
                        Text(
                          "HUB.COM",
                          style: GoogleFonts.roboto(
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(kDefaultPadding * 1.5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            "Contact Me".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: primaryColor),
                          ),
                          const SizedBox(height: kDefaultPadding / 2),
                          Text(
                            "If you would like to get in touch to discuss your fitness, massage or rehabilitation requirements please use the form here or the details below and I will be happy to help.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.caption!,
                          ),
                          const SizedBox(height: kDefaultPadding * 2),
                          CustomTextFormField(
                            controller: _nameController,
                            title: "Name",
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomTextFormField(
                            controller: _telephoneController,
                            title: "Telephone",
                            keyboardType: TextInputType.phone,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your telephone number";
                              } else if (value.contains(RegExp(r'[a-zA-Z]'))) {
                                return "Please enter a valid telephone number";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomTextFormField(
                            controller: _emailController,
                            title: "Email",
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
                          CustomTextFormField(
                            controller: _messageController,
                            title: "Message",
                            maxLines: 6,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your message";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomButton(
                            text: "Submit".toUpperCase(),
                            onPressed: _onSubmit,
                          ),
                          const SizedBox(height: kDefaultPadding * 3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
