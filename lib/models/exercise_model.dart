class ExerciseModel {
  String id;
  String? equipmentIds;
  String name;
  String? description;
  String? image;
  String addedDtime;
  int? v;
  String categoryId;
  List<String> subcategoryIds;
  String defaultTime;
  String? videoUrl;
  String breakSeconds;
  String reps;
  String sets;
  String weight;
  String weightUnit;

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
    this.videoUrl,
    required this.breakSeconds,
    required this.reps,
    required this.sets,
    required this.weight,
    required this.weightUnit,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        id: json["_id"],
        equipmentIds: json["equipment_ids"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        addedDtime: json["added_dtime"],
        v: json["__v"],
        categoryId: json["category_id"],
        subcategoryIds: (json["sub_category_ids"] as String).split(","),
        defaultTime: json["default_time"],
        videoUrl: json["video_url"],
        breakSeconds: json["break"],
        reps: json["reps"],
        sets: json["sets"],
        weight: json["weight"],
        weightUnit: json["weight_unit"],
      );

  ExerciseModel copyWith({
    String? id,
    String? equipmentIds,
    String? name,
    String? description,
    String? image,
    String? addedDtime,
    int? v,
    String? categoryId,
    List<String>? subcategoryIds,
    String? defaultTime,
    String? videoUrl,
    String? breakSeconds,
    String? reps,
    String? sets,
    String? weight,
    String? weightUnit,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      equipmentIds: equipmentIds ?? this.equipmentIds,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      addedDtime: addedDtime ?? this.addedDtime,
      v: v ?? this.v,
      categoryId: categoryId ?? this.categoryId,
      subcategoryIds: subcategoryIds ?? this.subcategoryIds,
      defaultTime: defaultTime ?? this.defaultTime,
      videoUrl: videoUrl ?? this.videoUrl,
      breakSeconds: breakSeconds ?? this.breakSeconds,
      reps: reps ?? this.reps,
      sets: sets ?? this.sets,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
    );
  }
}
