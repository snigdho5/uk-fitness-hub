class UserProfileModel {
  String id;
  String token;
  String email;
  String password;
  String title;
  String name;
  int age;
  int weight;
  int height;
  String country;
  String countryCode;
  String goal;
  String hearFrom;
  String createdDtime;
  String lastLogin;
  String image;
  int v;
  DateTime? trialEndDate;

  UserProfileModel({
    required this.id,
    required this.token,
    required this.email,
    required this.password,
    required this.title,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.country,
    required this.countryCode,
    required this.goal,
    required this.hearFrom,
    required this.createdDtime,
    required this.lastLogin,
    required this.image,
    required this.v,
    required this.trialEndDate,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json["_id"],
        token: json["token"],
        email: json["email"],
        password: json["password"],
        title: json["title"],
        name: json["name"],
        age: json["age"],
        weight: json["weight"],
        height: json["height"],
        country: json["country"],
        countryCode: json["country_code"],
        goal: json["goal"],
        hearFrom: json["hear_from"],
        createdDtime: json["created_dtime"],
        lastLogin: json["last_login"],
        image: json["image"],
        v: json["__v"],
        trialEndDate: json["trial_end_date"] == null
            ? null
            : DateTime.parse(json["trial_end_date"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "token": token,
        "email": email,
        "password": password,
        "title": title,
        "name": name,
        "age": age,
        "weight": weight,
        "height": height,
        "country": country,
        "country_code": countryCode,
        "goal": goal,
        "hear_from": hearFrom,
        "created_dtime": createdDtime,
        "last_login": lastLogin,
        "image": image,
        "__v": v,
        "trial_end_date": trialEndDate?.toIso8601String(),
      };
}
