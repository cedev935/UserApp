import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/user_info_model.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/widget/sign_out_confirmation_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  File? file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void _choose() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  _updateUserAccount() async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.fName == _firstNameController.text
        && Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.lName == _lastNameController.text
        && Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.phone == _phoneController.text && file == null
        && _passwordController.text.isEmpty && _confirmPasswordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Change something to update'),
          backgroundColor: ColorResources.red));
    }

    else if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('NAME_FIELD_MUST_BE_REQUIRED', context)!),
          backgroundColor: ColorResources.red));
    }

    else if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('EMAIL_MUST_BE_REQUIRED', context)!),
          backgroundColor: ColorResources.red));
    }

    else if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('PHONE_MUST_BE_REQUIRED', context)!),
          backgroundColor: ColorResources.red));
    }

    else if((password.isNotEmpty && password.length < 6)
        || (confirmPassword.isNotEmpty && confirmPassword.length < 6)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password should be at least 6 character'),
          backgroundColor: ColorResources.red));
    }

    else if(password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('PASSWORD_DID_NOT_MATCH', context)!),
          backgroundColor: ColorResources.red));
    }

    else {
      UserInfoModel updateUserInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel!;
      updateUserInfoModel.method = 'put';
      updateUserInfoModel.fName = _firstNameController.text;
      updateUserInfoModel.lName = _lastNameController.text;
      updateUserInfoModel.phone = _phoneController.text;
      String pass = _passwordController.text;

      await Provider.of<ProfileProvider>(context, listen: false).updateUserInfo(
        updateUserInfoModel, pass, file, Provider.of<AuthProvider>(context, listen: false).getUserToken(),
      ).then((response) {
        if(response.isSuccess) {
          Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated Successfully'),
              backgroundColor: Colors.green));
          _passwordController.clear();
          _confirmPasswordController.clear();
          setState(() {});
        }else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message!),
              backgroundColor: Colors.red));
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          _firstNameController.text = profile.userInfoModel!.fName!;
          _lastNameController.text = profile.userInfoModel!.lName!;
          _emailController.text = profile.userInfoModel!.email!;
          _phoneController.text = profile.userInfoModel!.phone!;


          if (kDebugMode) {
            print('wallet amount===>${profile.userInfoModel!.walletBalance}');
          }

          return Stack(clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Image.asset(Images.toolbarBackground, fit: BoxFit.fill, height: 500,
                  color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : null,),
              ),

              Container(padding: const EdgeInsets.only(top: 35, left: 15),
                child: Row(children: [
                  CupertinoNavigationBarBackButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.white,),
                  const SizedBox(width: 10),

                  Text(getTranslated('PROFILE', context)!,
                      style: titilliumRegular.copyWith(fontSize: 20, color: Colors.white),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),

              Container(padding: const EdgeInsets.only(top: 55),
                child: Column(children: [
                  Column(
                    children: [
                      Container(margin: const EdgeInsets.only(top: Dimensions.marginSizeExtraLarge),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Colors.white, width: 3),
                          shape: BoxShape.circle,),
                        child: Stack(clipBehavior: Clip.none,
                          children: [
                            ClipRRect(borderRadius: BorderRadius.circular(50),
                              child: file == null ?
                              FadeInImage.assetNetwork(
                                placeholder: Images.placeholder, width: Dimensions.profileImageSize,
                                height: Dimensions.profileImageSize, fit: BoxFit.cover,
                                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${profile.userInfoModel!.image}',
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                                    width: Dimensions.profileImageSize, height: Dimensions.profileImageSize, fit: BoxFit.cover),
                              ) :
                              Image.file(file!, width: Dimensions.profileImageSize,
                                  height: Dimensions.profileImageSize, fit: BoxFit.fill),),
                            Positioned(bottom: 0, right: -10,
                              child: CircleAvatar(backgroundColor: ColorResources.lightSkyBlue,
                                radius: 14,
                                child: IconButton(onPressed: _choose,
                                  padding: const EdgeInsets.all(0),
                                  icon: const Icon(Icons.edit, color: ColorResources.white, size: 18),),),
                            ),
                          ],
                        ),
                      ),

                      Text('${profile.userInfoModel!.fName} ${profile.userInfoModel!.lName ?? ''}',
                        style: titilliumSemiBold.copyWith(color: ColorResources.white, fontSize: 20.0),)
                    ],
                  ),

                  const SizedBox(height: Dimensions.marginSizeDefault),


                  Expanded(child: Container(
                    decoration: BoxDecoration(
                        color: ColorResources.getIconBg(context),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.marginSizeDefault),
                          topRight: Radius.circular(Dimensions.marginSizeDefault),)),
                    child: ListView(physics: const BouncingScrollPhysics(),
                      children: [
                        Container(margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault,
                            right: Dimensions.marginSizeDefault),
                          child: Row(children: [
                            Expanded(child: Column(
                              children: [Row(children: [
                                Icon(Icons.person, color: ColorResources.getLightSkyBlue(context), size: 20),
                                const SizedBox(width: Dimensions.marginSizeExtraSmall),
                                Text(getTranslated('FIRST_NAME', context)!, style: titilliumRegular)
                              ],
                              ),
                                const SizedBox(height: Dimensions.marginSizeSmall),

                                CustomTextField(textInputType: TextInputType.name,
                                  focusNode: _fNameFocus,
                                  nextNode: _lNameFocus,
                                  hintText: profile.userInfoModel!.fName ?? '',
                                  controller: _firstNameController,
                                ),
                              ],
                            )),
                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            Expanded(child: Column(
                              children: [
                                Row(children: [
                                  Icon(Icons.person, color: ColorResources.getLightSkyBlue(context), size: 20),
                                  const SizedBox(width: Dimensions.marginSizeExtraSmall),
                                  Text(getTranslated('LAST_NAME', context)!, style: titilliumRegular)
                                ],),
                                const SizedBox(height: Dimensions.marginSizeSmall),

                                CustomTextField(
                                  textInputType: TextInputType.name,
                                  focusNode: _lNameFocus,
                                  nextNode: _emailFocus,
                                  hintText: profile.userInfoModel!.lName,
                                  controller: _lastNameController,
                                ),
                              ],
                            )),
                          ],
                          ),
                        ),



                        Container(margin: const EdgeInsets.only(
                            top: Dimensions.marginSizeDefault,
                            left: Dimensions.marginSizeDefault,
                            right: Dimensions.marginSizeDefault),
                          child: Column(children: [
                            Row(children: [Icon(Icons.alternate_email,
                                color: ColorResources.getLightSkyBlue(context), size: 20),
                                const SizedBox(width: Dimensions.marginSizeExtraSmall,),
                                Text(getTranslated('EMAIL', context)!, style: titilliumRegular)
                              ],
                            ),
                            const SizedBox(height: Dimensions.marginSizeSmall),

                            CustomTextField(textInputType: TextInputType.emailAddress,
                              focusNode: _emailFocus,
                              isEnable : false,
                              nextNode: _phoneFocus,
                              fillColor: Theme.of(context).hintColor.withOpacity(.12),
                              hintText: profile.userInfoModel!.email ?? '',
                              controller: _emailController,
                            ),
                          ],
                          ),
                        ),


                        Container(margin: const EdgeInsets.only(
                            top: Dimensions.marginSizeDefault,
                            left: Dimensions.marginSizeDefault,
                            right: Dimensions.marginSizeDefault),
                          child: Column(children: [
                            Row(children: [
                              Icon(Icons.dialpad, color: ColorResources.getLightSkyBlue(context), size: 20),
                              const SizedBox(width: Dimensions.marginSizeExtraSmall),
                              Text(getTranslated('PHONE_NO', context)!, style: titilliumRegular)
                            ],),
                            const SizedBox(height: Dimensions.marginSizeSmall),

                            CustomTextField(
                              textInputType: TextInputType.phone,
                              focusNode: _phoneFocus,
                              hintText: profile.userInfoModel!.phone ?? "",
                              nextNode: _addressFocus,
                              controller: _phoneController,
                              isPhoneNumber: true,
                            ),],
                          ),
                        ),


                        Container(margin: const EdgeInsets.only(
                            top: Dimensions.marginSizeDefault,
                            left: Dimensions.marginSizeDefault,
                            right: Dimensions.marginSizeDefault),
                          child: Column(children: [
                            Row(children: [
                              Icon(Icons.lock_open, color: ColorResources.getPrimary(context), size: 20),
                              const SizedBox(width: Dimensions.marginSizeExtraSmall),
                              Text(getTranslated('PASSWORD', context)!, style: titilliumRegular)
                            ],),
                            const SizedBox(height: Dimensions.marginSizeSmall),

                            CustomPasswordTextField(controller: _passwordController,
                              focusNode: _passwordFocus,
                              nextNode: _confirmPasswordFocus,
                              textInputAction: TextInputAction.next,
                            ),
                          ],),
                        ),


                        Container(margin: const EdgeInsets.only(
                            top: Dimensions.marginSizeDefault,
                            left: Dimensions.marginSizeDefault,
                            right: Dimensions.marginSizeDefault),
                          child: Column(children: [
                            Row(
                              children: [
                                Icon(Icons.lock_open, color: ColorResources.getPrimary(context), size: 20),
                                const SizedBox(width: Dimensions.marginSizeExtraSmall),
                                Text(getTranslated('RE_ENTER_PASSWORD', context)!, style: titilliumRegular)
                              ],),
                            const SizedBox(height: Dimensions.marginSizeSmall),


                            CustomPasswordTextField(controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              textInputAction: TextInputAction.done,
                            ),


                            const SizedBox(height: Dimensions.paddingSizeLarge),


                            InkWell(
                              onTap: () => showAnimatedDialog(context, SignOutConfirmationDialog(isDelete: true,customerId: profile.userInfoModel!.id,), isFlip: true),
                              child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,children: [
                                Container(alignment: Alignment.center,height: Dimensions.iconSizeSmall,child: Image.asset(Images.delete)),
                                const SizedBox(width: Dimensions.paddingSizeDefault,),
                                Text(getTranslated('delete_account', context)!,style: robotoRegular.copyWith(),),
                              ],),
                            )


                          ],),
                        ),
                      ],
                    ),
                  ),
                  ),
                  Container(margin: const EdgeInsets.symmetric(horizontal: Dimensions.marginSizeLarge,
                      vertical: Dimensions.marginSizeSmall),
                    child: !Provider.of<ProfileProvider>(context).isLoading ?
                    CustomButton(onTap: _updateUserAccount, buttonText: getTranslated('UPDATE_ACCOUNT', context)) :
                    Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                  ),
                ],
                ),
              ),
            ],
          );
          },
      ),
    );
  }
}
