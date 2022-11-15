class SettingsModel {
  SettingsModel({
    required this.id,
    this.appVer,
    this.appName,
    required this.appTnc,
    required this.appAbout,
    required this.appPrivacy,
    required this.subscriptionFeePerMonth,
    required this.subscriptionFeePerYear,
    required this.currrency,
  });

  String id;
  String? appVer;
  String? appName;
  String appTnc;
  String appAbout;
  String appPrivacy;
  String subscriptionFeePerMonth;
  String subscriptionFeePerYear;
  String currrency;

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        id: json["_id"],
        appVer: json["app_ver"],
        appName: json["app_name"],
        appTnc: json["app_tnc"],
        appAbout: json["app_about"],
        appPrivacy: json["app_privacy"],
        subscriptionFeePerMonth: json["subscription_fee_per_month"],
        subscriptionFeePerYear: json["subscription_fee_per_year"],
        currrency: json["currrency"],
      );
}
