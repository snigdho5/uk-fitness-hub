class CountryModel {
  CountryModel({
    required this.id,
    required this.countryCode,
    required this.countryName,
  });

  String id;
  String countryCode;
  String countryName;

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json["_id"],
        countryCode: json["country_code"],
        countryName: json["country_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "country_code": countryCode,
        "country_name": countryName,
      };
}
