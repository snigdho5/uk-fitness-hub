class ExerciseModel {
  ExerciseModel({
    required this.id,
    this.equipmentIds,
    required this.name,
    this.description,
    this.image,
    required this.addedDtime,
    required this.v,
    required this.categoryId,
    required this.subcategoryIds,
    required this.defaultTime,
  });

  String id;
  String? equipmentIds;
  String name;
  String? description;
  String? image;
  DateTime addedDtime;
  int? v;
  String categoryId;
  List<String> subcategoryIds;
  String defaultTime;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        id: json["_id"],
        equipmentIds: json["equipment_ids"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        addedDtime: DateTime.parse(json["added_dtime"]),
        v: json["__v"],
        categoryId: json["category_id"],
        subcategoryIds:
            (json["subcategory_ids"] as String).substring(1).split(","),
        defaultTime: json["default_time"],
      );
}
