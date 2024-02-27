import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/auth_screen.dart';
import 'package:provider/provider.dart';

class NotLoggedInWidget extends StatelessWidget {
  const NotLoggedInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.all(height*0.025),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.login, height: height*0.2, width: width),
            SizedBox(height: height*0.05),
            Text(getTranslated('PLEASE_LOGIN_FIRST', context)!, textAlign: TextAlign.center, style: titilliumSemiBold.copyWith(fontSize: height*0.017)),
            SizedBox(height: height*0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: SizedBox(
                width: MediaQuery.of(context).size.width/2,
                child: CustomButton(
                  buttonText: getTranslated('LOGIN', context),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen())),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).updateSelectedIndex(1);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen(initialPage: 1)));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: height*0.02),
                child: Text(getTranslated('create_new_account', context)!, style: titilliumRegular.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeSmall,
                )),
              ),
            ),
          ],
        ));
  }
}
