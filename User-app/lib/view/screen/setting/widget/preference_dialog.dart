import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class PreferenceDialog extends StatelessWidget {
  const PreferenceDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Text(getTranslated('preference', context)!, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        ),
        const SwitchTile(title: 'Location', value: true),
        const SwitchTile(title: 'Storage', value: true),
        const SwitchTile(title: 'Push Notification', value: true),
        const Divider(height: Dimensions.paddingSizeExtraSmall, color: ColorResources.hintTextColor),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(getTranslated('CANCEL', context)!, style: robotoRegular.copyWith(color: ColorResources.yellow)),
          ),
        ),
      ]),
    );
  }
}

class SwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  const SwitchTile({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: CupertinoSwitch(
        value: value,
        activeColor: ColorResources.green,
        trackColor: ColorResources.red,
        onChanged: (isChecked) {},
      ),
      onTap: () {},
    );
  }
}

