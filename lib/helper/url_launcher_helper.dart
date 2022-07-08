import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

void launchURL(String url) async => await canLaunchUrl(Uri.parse(url))
    ? await launchUrl(Uri.parse(url))
    : EasyLoading.showToast('Something went wrong!',
        toastPosition: EasyLoadingToastPosition.bottom);
