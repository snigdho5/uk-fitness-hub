import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/settings_model.dart';
import 'package:ukfitnesshub/providers/settings_provider.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';

class TrialEndDialog extends ConsumerStatefulWidget {
  final bool isTrialEnded;
  const TrialEndDialog({super.key, this.isTrialEnded = true});

  @override
  ConsumerState<TrialEndDialog> createState() => _TrialEndDialogState();
}

class _TrialEndDialogState extends ConsumerState<TrialEndDialog> {
  SettingsModel? settings;
  bool _isMonthlySubscription = true;

  @override
  void initState() {
    settings = ref.read(settingsProvider).settings;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userHiveProvider).getUser();
    DateTime now = DateTime.now();
    DateTime? trialDate = user?.trialEndDate;

    int daysLeft = trialDate?.difference(now).inDays ?? 0;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: kDefaultPadding),
            const Icon(
              CupertinoIcons.info_circle,
              color: primaryColor,
              size: 50,
            ),
            const SizedBox(height: kDefaultPadding),
            Text(
              widget.isTrialEnded
                  ? '14 Days Trial Ended'
                  : 'Your trial will end in $daysLeft days',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: primaryColor, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.isTrialEnded
                  ? 'Please subscribe to continue using the app'
                  : 'Please subscribe to continue using the app after your trial ends',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: kDefaultPadding),
            if (settings != null)
              RadioListTile(
                value: true,
                groupValue: _isMonthlySubscription,
                onChanged: (value) {
                  setState(() {
                    _isMonthlySubscription = true;
                  });
                },
                title: const Text('Monthly Subscription'),
                secondary: Text(
                  '${settings!.currrency}${settings!.subscriptionFeePerMonth}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            if (settings != null)
              RadioListTile(
                value: false,
                groupValue: _isMonthlySubscription,
                onChanged: (value) {
                  setState(() {
                    _isMonthlySubscription = false;
                  });
                },
                title: const Text('Yearly Subscription'),
                secondary: Text(
                  '${settings!.currrency}${settings!.subscriptionFeePerYear}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: kDefaultPadding * 2),
            Row(
              children: [
                if (!widget.isTrialEnded)
                  const SizedBox(width: kDefaultPadding),
                if (!widget.isTrialEnded)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                const SizedBox(width: kDefaultPadding),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      EasyLoading.showToast("Open subscription page!!");
                    },
                    child: const Text('Subscribe'),
                  ),
                ),
                const SizedBox(width: kDefaultPadding),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
