class SubCategoryModel {
  SubCategoryModel({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    this.image,
    this.addedDtime,
    this.v,
  });

  String id;
  String categoryId;
  String name;
  String? description;
  String? image;
  String? addedDtime;
  int? v;

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryModel(
        id: json["_id"],
        categoryId: json["category_id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        addedDtime: json["added_dtime"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category_id": categoryId,
        "name": name,
        "description": description,
        "image": image,
        "added_dtime": addedDtime,
        "__v": v,
      };
}
