import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/social_login_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/facebook_login_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/google_sign_in_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import 'mobile_verify_screen.dart';
import 'otp_verification_screen.dart';

class SocialLoginWidget extends StatefulWidget {
  const SocialLoginWidget({Key? key}) : super(key: key);

  @override
  SocialLoginWidgetState createState() => SocialLoginWidgetState();
}

class SocialLoginWidgetState extends State<SocialLoginWidget> {

  SocialLoginModel socialLogin = SocialLoginModel();
  route(bool isRoute, String? token, String? temporaryToken, String errorMessage) async {
    if (isRoute) {
      if(token != null){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);

      }else if(temporaryToken != null && temporaryToken.isNotEmpty){
        if(Provider.of<SplashProvider>(context,listen: false).configModel!.emailVerification!){
          Provider.of<AuthProvider>(context, listen: false).checkEmail(socialLogin.email.toString(),
              temporaryToken).then((value) async {
            if (value.isSuccess) {
              Provider.of<AuthProvider>(context, listen: false).updateEmail(socialLogin.email.toString());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (_) => VerificationScreen(temporaryToken,
                  '',socialLogin.email.toString())), (route) => false);

            }
          });
        }
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (_) => MobileVerificationScreen(temporaryToken)), (route) => false);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage),
            backgroundColor: Colors.red));
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage),
          backgroundColor: Colors.red));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Provider.of<SplashProvider>(context,listen: false).configModel!.socialLogin![0].status!?
       Provider.of<SplashProvider>(context,listen: false).configModel!.socialLogin![1].status!?
        Center(child: Text(getTranslated('social_login', context)!))
        :Center(child: Text(getTranslated('social_login', context)!)):const SizedBox(),


        Container(color: Provider.of<ThemeProvider>(context).darkTheme ? Theme.of(context).canvasColor : Colors.transparent,
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Provider.of<SplashProvider>(context,listen: false).configModel!.socialLogin![0].status!?

              InkWell(
                onTap: () async{

                  await Provider.of<GoogleSignInProvider>(context, listen: false).login();
                  String? id,token,email, medium;
                  if(context.mounted){}
                  if(Provider.of<GoogleSignInProvider>(context,listen: false).googleAccount != null){
                    id = Provider.of<GoogleSignInProvider>(context,listen: false).googleAccount!.id;
                    email = Provider.of<GoogleSignInProvider>(context,listen: false).googleAccount!.email;
                    token = Provider.of<GoogleSignInProvider>(context,listen: false).auth.accessToken;
                    medium = 'google';
                    if (kDebugMode) {
                      print('eemail =>$email token =>$token');
                    }
                    socialLogin.email = email;
                    socialLogin.medium = medium;
                    socialLogin.token = token;
                    socialLogin.uniqueId = id;
                    await Provider.of<AuthProvider>(context, listen: false).socialLogin(socialLogin, route);
                  }

                },
                child: Ink(color: const Color(0xFF397AF3),
                  child: Padding(padding: const EdgeInsets.all(6),
                    child: Card(child: Padding(padding: const EdgeInsets.all(8.0),
                        child: Wrap(crossAxisAlignment: WrapCrossAlignment.center,
                          children: [Container(
                              decoration: const BoxDecoration(color: Colors.white ,
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              height: 30,width: 30,
                              child: Image.asset(Images.google)), // <-- Use 'Image.asset(...)' here
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ) :const SizedBox(),


              Provider.of<SplashProvider>(context,listen: false).configModel!.socialLogin![1].status!?
              InkWell(
                onTap: () async{
                  await Provider.of<FacebookLoginProvider>(context, listen: false).login();
                  String? id,token,email, medium;
                  if(Provider.of<FacebookLoginProvider>(Get.context!,listen: false).userData != null){
                    id = Provider.of<FacebookLoginProvider>(Get.context!,listen: false).result.accessToken!.userId;
                    email = Provider.of<FacebookLoginProvider>(Get.context!,listen: false).userData!['email'];
                    token = Provider.of<FacebookLoginProvider>(Get.context!,listen: false).result.accessToken!.token;
                    medium = 'facebook';
                    socialLogin.email = email;
                    socialLogin.medium = medium;
                    socialLogin.token = token;
                    socialLogin.uniqueId = id;
                    await Provider.of<AuthProvider>(Get.context!, listen: false).socialLogin(socialLogin, route);
                  }
                },
                child: Ink(color: const Color(0xFF397AF3),
                  child: Padding(padding: const EdgeInsets.all(6),
                    child: Card(child: Padding(padding: const EdgeInsets.all(8.0),
                        child: Wrap(crossAxisAlignment: WrapCrossAlignment.center,
                          children: [SizedBox(height: 30,width: 30,
                              child: Image.asset(Images.facebook)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ):const SizedBox(),

            ],
          ),
        ),
      ],
    );
  }
}
