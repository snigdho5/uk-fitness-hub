import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';

class ProgrammePage extends StatelessWidget {
  const ProgrammePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: 'Programme'),
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => VideoPlayerPage(
              //           isNetwork: true, videoUrl: data.parkingVideoUrl)),
              // );
            },
            child: Stack(
              children: [
                Image.asset(programmeImage),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Image.asset(
                        videoIcon,
                        width: 56,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Natural Balance Between body and Mental Development."
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: kDefaultPadding),
              const ProgrammeSpecialButton(icon: Icons.add),
              const SizedBox(width: kDefaultPadding),
            ],
          ),
          const SizedBox(height: kDefaultPadding),
          Text(
            "Sitting".toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: kDefaultPadding / 2),
          const Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it"),
          const SizedBox(height: kDefaultPadding * 2),
          Row(
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
