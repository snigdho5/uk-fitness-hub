import 'package:flutter/material.dart';

//Basic Constants
const String appName = 'UKFITNESSHUB';
const Color primaryColor = Color(0xff026a94);
const Color secondaryColor = Color(0xff0E364C);
const Color tertiaryColor = Color.fromARGB(255, 195, 222, 237);
const double kDefaultPadding = 16.0;

//Images Constants
const String _imagePath = 'assets/images/';
const String _iconsPath = 'assets/icons/';

//Images
const String splash = '${_imagePath}splash.jpg';
const String logo = '${_imagePath}logo.png';
const String bg = '${_imagePath}bg.png';
const String loginBg = '${_imagePath}login.png';
//appbarbg
const String appbarbg = '${_imagePath}appbarbg.png';
//equipment
const String equipment = '${_imagePath}equipment.png';
//training
const String training = '${_imagePath}training.png';
//workout
const String workout = '${_imagePath}workout.png';

//Icons
//menu
const String menu = '${_iconsPath}menu.png';
//user
const String user = '${_iconsPath}user.png';
//notification
const String notification = '${_iconsPath}notification.png';
//calendar
const String calendar = '${_iconsPath}calendar.png';
//progress
const String progress = '${_iconsPath}progress.png';
//result
const String result = '${_iconsPath}result.png';

//Lower Body Items
const String _lowerBodyPath = '${_iconsPath}lower body items/';

const String abductors = '${_lowerBodyPath}Abductors.png';
//Adductors
const String adductors = '${_lowerBodyPath}Adductors.png';
//Calves
const String calves = '${_lowerBodyPath}Calves.png';
//Glutes
const String glutes = '${_lowerBodyPath}Glutes.png';
//Hamstrings
const String hamstrings = '${_lowerBodyPath}Hamstrings.png';
//Quadriceps
const String quadriceps = '${_lowerBodyPath}Quadriceps.png';

//Others
const String videoIcon = "${_iconsPath}video.png";
const String programmeImage = "${_imagePath}programme.png";

//Body focus images
const String _bodyFocusPath = '${_imagePath}body_focus/';
const String lowerBody = '${_bodyFocusPath}lower_body.png';
const String upperBody = '${_bodyFocusPath}upper_body.png';
const String core = '${_bodyFocusPath}core.png';
const String totalBody = '${_bodyFocusPath}total_body.png';

class HiveConstants {
  HiveConstants._();

  static const String hiveBox = 'ukfitnesshub';

  static const String userProfile = 'userProfile';
}
