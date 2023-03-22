const String baseUrl = "http://dev.solutionsfinder.co.uk:3000/api/";

class APIs {
  APIs._();

  static const String signUp = "signup";
  static const String login = "login";
  static const String logout = "logout";
  static const String changePassword = "change-password";
  static const String editProfile = "edit-profile";
  static const String uploadProfileImage = "upload-image";
  static const String forgotPassword = "forgot-password";
  static const String resetPassword = "reset-password";

  //countries
  static const String countries = "countries";

  //Categories
  static const String categories = "categories";

  //SubCategories
  static const String allSubCategories = "sub-categories";
  static const String getSubCategoriesByCategoryId = "get-sub-category";

  //Exercises
  static const String allExercises = "exercises";
  static const String getExercisesBySubCategoryId = "get-exercises";
  static const String addRecord = "add-exercise-personal-best";

  //Programme
  static const String programmes = "programmes";
  static const String userProgrammes = "user-programmes";
  static const String addProgramme = "add-programme";
  static const String editProgramme = "edit-programme";
  static const String deleteProgramme = "delete-programme";

  //Equipmets
  static const String equipments = "equipments";

  //Contact with travis
  static const String contactWithTravis = "add-travis-contact";

  //Global Search
  static const String globalSearch = "global-search";

  //Settings
  static const String settings = "settings";

  //Progress
  static const String progress = "progress";
}
