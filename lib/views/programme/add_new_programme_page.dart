import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';
import 'package:ukfitnesshub/views/custom/custom_text_field.dart';

class AddNewProgrammePage extends StatefulWidget {
  const AddNewProgrammePage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddNewProgrammePage> createState() => _AddNewProgrammePageState();
}

class _AddNewProgrammePageState extends State<AddNewProgrammePage> {
  String? programmeName;
  final TextEditingController _programmeNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: customAppBar(
        context,
        title: 'Add Programme',
        showDefaultActionButtons: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(bg), fit: BoxFit.fill),
        ),
        child: programmeName == null
            ? Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextFormField(
                      controller: _programmeNameController,
                      title: 'Programme Name',
                    ),
                    const SizedBox(height: kDefaultPadding),
                    CustomButton(
                        text: 'Submit',
                        onPressed: () {
                          setState(() {
                            programmeName = _programmeNameController.text;
                          });
                        }),
                  ],
                ),
              )
            : ListView(),
      ),
    );
  }
}
