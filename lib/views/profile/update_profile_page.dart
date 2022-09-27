import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/user_profile_model.dart';
import 'package:ukfitnesshub/providers/auth_providers.dart';
import 'package:ukfitnesshub/providers/country_provider.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/auth/sign_up_page.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';
import 'package:ukfitnesshub/views/custom/custom_text_field.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final UserProfileModel user;
  const EditProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(); //Password

  //Name
  final _nameController = TextEditingController();
  //Age
  final _ageController = TextEditingController();
  //Weight
  final _weightController = TextEditingController();
  //Height
  final _heightController = TextEditingController();

  //Goal
  late SingleValueDropDownController _goalController;
  //How did you hear about us?
  late SingleValueDropDownController _hearAboutUsController;

  //Country
  late SingleValueDropDownController _countryController;

  bool? _isMale;

  @override
  void initState() {
    _emailController.text = widget.user.email;
    _nameController.text = widget.user.name;
    _ageController.text = widget.user.age.toString();
    _weightController.text = widget.user.weight.toString();
    _heightController.text = widget.user.height.toString();

    _isMale = widget.user.title == 'Mr';

    _goalController = SingleValueDropDownController(
        data: DropDownValueModel(
            name: widget.user.goal, value: widget.user.goal));

    _hearAboutUsController = SingleValueDropDownController(
        data: DropDownValueModel(
            name: widget.user.hearFrom, value: widget.user.hearFrom));

    _countryController = SingleValueDropDownController(
        data: DropDownValueModel(
            name: widget.user.country, value: widget.user.countryCode));

    super.initState();
  }

  void _onUpadte() async {
    final Map<String, String> data = {
      "user_id": widget.user.id.toString(),
      "email": _emailController.text.trim(),
      "title": _isMale == true ? "Mr" : "Mrs",
      "name": _nameController.text.trim(),
      "age": _ageController.text.trim(),
      "weight": _weightController.text.trim(),
      "height": _heightController.text.trim(),
      "country": _countryController.dropDownValue == null
          ? ""
          : _countryController.dropDownValue!.name,
      "country_code": _countryController.dropDownValue == null
          ? ""
          : _countryController.dropDownValue!.value.toString(),
      "goal": _goalController.dropDownValue == null
          ? ""
          : _goalController.dropDownValue!.name,
      "hear_from": _hearAboutUsController.dropDownValue == null
          ? ""
          : _hearAboutUsController.dropDownValue!.name,
    };
    EasyLoading.show(status: 'loading...');
    await AuthProvider.updateProfile(data, widget.user.token)
        .then((value) async {
      if (value != null) {
        final userProfileRef = ref.read(userHiveProvider);
        await userProfileRef.saveUser(value).then((value) {
          Navigator.pop(context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final countryProvider = ref.watch(countriesProvider);
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
                  "Update Profile".toUpperCase(),
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
                              "Please fill in this form correctly to update your profile.",
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding,
                                vertical: kDefaultPadding / 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(kDefaultPadding),
                              border: Border.all(color: Colors.grey),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 6),
                                    blurRadius: 4,
                                    color: Colors.black12),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Gender"),
                                const SizedBox(height: kDefaultPadding / 2),
                                Row(
                                  children: [
                                    ChoiceChip(
                                      selectedColor: primaryColor,
                                      label: Text(
                                        "Male",
                                        style: TextStyle(
                                            color: _isMale == true
                                                ? Colors.white
                                                : null),
                                      ),
                                      selected: _isMale == true,
                                      onSelected: (value) {
                                        setState(() {
                                          if (value) {
                                            _isMale = true;
                                          } else {
                                            _isMale = null;
                                          }
                                        });
                                      },
                                    ),
                                    const SizedBox(width: kDefaultPadding / 2),
                                    ChoiceChip(
                                      selectedColor: primaryColor,
                                      label: Text(
                                        "Female",
                                        style: TextStyle(
                                            color: _isMale == false
                                                ? Colors.white
                                                : null),
                                      ),
                                      selected: _isMale == false,
                                      onSelected: (value) {
                                        setState(() {
                                          if (value) {
                                            _isMale = false;
                                          } else {
                                            _isMale = null;
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                          CustomDropdownTextField(
                            contoller: _countryController,
                            items: countryProvider.countries.map((e) {
                              return DropDownValueModel(
                                  name: e.countryName, value: e.countryCode);
                            }).toList(),
                            title: "Your Country",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please select your country";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomDropdownTextField(
                            contoller: _goalController,
                            items: yourGoalItems.map((e) {
                              return DropDownValueModel(name: e, value: e);
                            }).toList(),
                            title: "Your Goal",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please select your goal";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomDropdownTextField(
                            contoller: _hearAboutUsController,
                            items: howDidYouHearAboutUsItems.map((e) {
                              return DropDownValueModel(name: e, value: e);
                            }).toList(),
                            title: "How did you hear about us?",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please select something!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kDefaultPadding),
                          CustomButton(
                            text: "Submit",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_isMale != null) {
                                  _onUpadte();
                                } else {
                                  EasyLoading.showInfo(
                                      "Please select your gender.");
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
