class ProgrammeModel {
  ProgrammeModel({
    required this.id,
    required this.exerciseIds,
    required this.exerciseTimes,
    required this.name,
    this.description,
    this.image,
    required this.addedDtime,
    this.v,
  });

  String id;
  List<String> exerciseIds;
  List<int> exerciseTimes;
  String name;
  String? description;
  String? image;
  String addedDtime;
  int? v;

  factory ProgrammeModel.fromJson(Map<String, dynamic> json) => ProgrammeModel(
        id: json["_id"],
        exerciseIds: (json["exercise_ids"] as String).substring(1).split(","),
        exerciseTimes: json["exercise_my_time"] == null
            ? (json["exercise_ids"] as String)
                .substring(1)
                .split(",")
                .map((e) => 30)
                .toList()
            : (json["exercise_my_time"] as String)
                .substring(1)
                .split(",")
                .map((e) => int.parse(e))
                .toList(),
        name: json["name"],
        description: json["description"],
        image: json["image"],
        addedDtime: json["added_dtime"],
        v: json["__v"],
      );
}
