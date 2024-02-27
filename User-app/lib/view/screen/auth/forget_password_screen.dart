import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/my_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/code_picker_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/otp_verification_screen.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _key = GlobalKey();
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _numberFocus = FocusNode();
  String? _countryDialCode = '+964';

  @override
  void initState() {
    _countryDialCode = CountryCode.fromCountryCode(
        Provider.of<SplashProvider>(context, listen: false).configModel!.countryCode!).dialCode;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: _key,

      body: Container(
        decoration: BoxDecoration(
          image: Provider.of<ThemeProvider>(context).darkTheme ? null :
          const DecorationImage(image: AssetImage(Images.background), fit: BoxFit.fill),
        ),


        child: Column(
          children: [

            SafeArea(child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(icon: const Icon(Icons.arrow_back_ios_outlined),
                onPressed: () => Navigator.pop(context),
              ),
            )),

            Expanded(
              child: ListView(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall), children: [

                Padding(
                  padding: const EdgeInsets.all(50),
                  child: Image.asset(Images.logoWithNameImage, height: 150, width: 200),
                ),
                Text(getTranslated('FORGET_PASSWORD', context)!, style: titilliumSemiBold),


                Row(children: [
                  Expanded(flex: 1, child: Divider(thickness: 1,
                      color: Theme.of(context).primaryColor)),
                  Expanded(flex: 2, child: Divider(thickness: 0.2,
                      color: Theme.of(context).primaryColor)),
                ]),

                Provider.of<SplashProvider>(context,listen: false).configModel!.forgetPasswordVerification == "phone"?
                Text(getTranslated('enter_phone_number_for_password_reset', context)!,
                    style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeExtraSmall)):
                Text(getTranslated('enter_email_for_password_reset', context)!,
                    style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeExtraSmall)),
                const SizedBox(height: Dimensions.paddingSizeLarge),


                Provider.of<SplashProvider>(context,listen: false).configModel!.forgetPasswordVerification == "phone"?
                Row(children: [
                  CodePickerWidget(
                    onChanged: (CountryCode countryCode) {
                      _countryDialCode = countryCode.dialCode;
                      },
                    initialSelection: _countryDialCode,
                    favorite: [_countryDialCode!],
                    showDropDownButton: true,
                    padding: EdgeInsets.zero,
                    showFlagMain: true,
                    textStyle: TextStyle(color: Theme.of(context).textTheme.displayLarge!.color),
                  ),


                  Expanded(child: CustomTextField(
                    hintText: getTranslated('number_hint', context),
                    controller: _numberController,
                    focusNode: _numberFocus,
                    isPhoneNumber: true,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.phone,
                  )),
                ]) :

                CustomTextField(
                  controller: _controller,
                  hintText: getTranslated('ENTER_YOUR_EMAIL', context),
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 100),


                Builder(
                  builder: (context) => !Provider.of<AuthProvider>(context).isLoading ?
                  CustomButton(
                    buttonText: Provider.of<SplashProvider>(context,listen: false).configModel!.forgetPasswordVerification == "phone"?
                    getTranslated('send_otp', context):getTranslated('send_email', context),
                    onTap: () {
                      if(Provider.of<SplashProvider>(context,listen: false).configModel!.forgetPasswordVerification == "phone"){
                        if(_numberController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(getTranslated('PHONE_MUST_BE_REQUIRED', context)!),
                                backgroundColor: Colors.red,)
                          );

                        }else{
                          Provider.of<AuthProvider>(context, listen: false).
                          forgetPassword(_countryDialCode!+_numberController.text.trim()).then((value) {
                            if(value.isSuccess) {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                  builder: (_) => VerificationScreen('',
                                      _countryDialCode! +_numberController.text.trim(),'', fromForgetPassword: true)),
                                      (route) => false);
                            }else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(getTranslated('input_valid_phone_number', context)!),
                                    backgroundColor: Colors.red,)
                              );

                            }
                          });
                        }

                      }else{
                        if(_controller.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(getTranslated('EMAIL_MUST_BE_REQUIRED', context)!),
                                backgroundColor: Colors.red,)
                          );
                        }
                        else {
                          Provider.of<AuthProvider>(context, listen: false).forgetPassword(_controller.text).then((value) {
                            if(value.isSuccess) {
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              _controller.clear();

                              showAnimatedDialog(context, MyDialog(
                                icon: Icons.send,
                                title: getTranslated('sent', context),
                                description: getTranslated('recovery_link_sent', context),
                                rotateAngle: 5.5,
                              ), dismissible: false);
                            }else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(value.message!),backgroundColor: Colors.red,)
                              );
                            }
                          });
                        }
                      }


                    },
                  ) : Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

