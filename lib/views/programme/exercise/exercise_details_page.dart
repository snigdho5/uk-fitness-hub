import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/exercise_model.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/programme/play_program_page.dart';

class ExerciseDetailsPage extends StatelessWidget {
  final ExerciseModel exercise;
  const ExerciseDetailsPage({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: exercise.name, showDefaultActionButtons: false),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            child: CachedNetworkImage(imageUrl: exercise.image ?? ""),
          ),
          const SizedBox(height: kDefaultPadding),
          Row(
            children: [
              Expanded(
                child: Text(
                  exercise.name.toUpperCase(),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: kDefaultPadding),
              ProgrammeSpecialButton(
                icon: Icons.play_arrow,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PlayProgramPage(exercises: [exercise]),
                    ),
                  );
                },
              ),
              const SizedBox(width: kDefaultPadding),
            ],
          ),
          const SizedBox(height: kDefaultPadding),
          Text(exercise.description ?? ""),
          const SizedBox(height: kDefaultPadding),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  "10\nReps",
                  textAlign: TextAlign.center,
                ),
                Text(
                  "5\nSets",
                  textAlign: TextAlign.center,
                ),
                Text(
                  "5 sec\nHold",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}

class ProgrammeSpecialButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  const ProgrammeSpecialButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: primaryColor.withOpacity(0.4),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: primaryColor.withOpacity(0.7),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: primaryColor,
            child: Icon(icon, color: tertiaryColor),
          ),
        ),
      ),
    );
  }
}
