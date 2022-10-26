class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.addedDtime,
    this.v,
  });

  String id;
  String name;
  String? description;
  String? image;
  DateTime? addedDtime;
  int? v;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        addedDtime: DateTime.parse(json["added_dtime"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "image": image,
        "added_dtime": addedDtime?.toIso8601String(),
        "__v": v,
      };
}
