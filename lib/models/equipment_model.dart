class EquipmentModel {
  EquipmentModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.addedDtime,
    required this.v,
  });

  String id;
  String name;
  String? description;
  String? image;
  String addedDtime;
  int v;

  factory EquipmentModel.fromJson(Map<String, dynamic> json) => EquipmentModel(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        addedDtime: json["added_dtime"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "image": image,
        "added_dtime": addedDtime,
        "__v": v,
      };
}
