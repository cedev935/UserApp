import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/auth_screen.dart';
import 'package:provider/provider.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  final bool isDelete;
  final int? customerId;
  const SignOutConfirmationDialog({Key? key, this.isDelete = false, this.customerId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        isDelete?Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
          child: SizedBox(width: Dimensions.iconSizeDefault,child: Image.asset(Images.delete)),
        ):const SizedBox(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 50),
          child: Text(isDelete? getTranslated('want_to_delete_account', context)!: getTranslated('want_to_sign_out', context)!, style: robotoRegular, textAlign: TextAlign.center),
        ),

        const Divider(height: 0, color: ColorResources.hintTextColor),

        Consumer<ProfileProvider>(
          builder: (context, delete,_) {
            return delete.isDeleting?
            Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: const [
              CircularProgressIndicator()
            ],) : Row(children: [

              Expanded(child: InkWell(
                onTap: () {
                  if(isDelete){
                    Provider.of<ProfileProvider>(context, listen: false).deleteCustomerAccount(context, customerId).then((condition) {
                      if(condition.response!.statusCode == 200){
                        Navigator.pop(context);
                        Provider.of<AuthProvider>(context,listen: false).clearSharedData();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthScreen()), (route) => false);
                      }

                    });
                  }else{
                    Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
                      Navigator.pop(context);
                      Provider.of<ProfileProvider>(context,listen: false).clearHomeAddress();
                      Provider.of<ProfileProvider>(context,listen: false).clearOfficeAddress();
                      Provider.of<AuthProvider>(context,listen: false).clearSharedData();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthScreen()), (route) => false);
                    });
                  }

                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                  child: Text(getTranslated('YES', context)!, style: titilliumBold.copyWith(color: Theme.of(context).primaryColor)),
                ),
              )),

              Expanded(child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: ColorResources.red, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                  child: Text(getTranslated('NO', context)!, style: titilliumBold.copyWith(color: ColorResources.white)),
                ),
              )),

            ]);
          }
        ),
      ]),
    );
  }
}
