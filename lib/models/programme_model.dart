class ProgrammeModel {
  ProgrammeModel({
    required this.id,
    required this.exerciseIds,
    required this.name,
    this.description,
    this.image,
    required this.addedDtime,
    this.v,
  });

  String id;
  List<String> exerciseIds;
  String name;
  String? description;
  String? image;
  String addedDtime;
  int? v;

  factory ProgrammeModel.fromJson(Map<String, dynamic> json) => ProgrammeModel(
        id: json["_id"],
        exerciseIds: (json["exercise_ids"] as String).substring(1).split(","),
        name: json["name"],
        description: json["description"],
        image: json["image"],
        addedDtime: json["added_dtime"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "exercise_ids": ",${exerciseIds.join(",")}",
        "name": name,
        "description": description,
        "image": image,
        "added_dtime": addedDtime,
        "__v": v,
      };
}
