import 'package:flutter/material.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/tracking/tracking_result_screen.dart';

class TrackingScreen extends StatelessWidget {
  final String orderID;
  TrackingScreen({Key? key, required this.orderID}) : super(key: key);

  final TextEditingController _orderIdController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _orderIdController.text = orderID;

    return Scaffold(
      key: _globalKey,
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(
        children: [
          CustomAppBar(title: getTranslated('TRACKING', context)),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Image.asset('assets/images/onboarding_image_one.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,),
                      const SizedBox(height: 50),

                      Text(getTranslated('TRACK_ORDER', context)!, style: robotoBold),
                      Stack(children: [
                        Container(width: double.infinity, height: 1,
                          margin: const EdgeInsets.only(top: Dimensions.marginSizeSmall),
                          color: ColorResources.colorMap[50],),


                        Container(width: 70, height: 1,
                          margin: const EdgeInsets.only(top: Dimensions.marginSizeSmall),
                          decoration: BoxDecoration(color: ColorResources.getPrimary(context),
                              borderRadius: BorderRadius.circular(1)),),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),


                      CustomTextField(
                        hintText: getTranslated('TRACK_ID', context),
                        textInputType: TextInputType.number,
                        controller: _orderIdController,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      CustomButton(
                        buttonText: getTranslated('TRACK', context),
                        onTap: () {
                          if(_orderIdController.text.isNotEmpty){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrackingResultScreen(
                                orderID: _orderIdController.text)));
                          }else {
                            _globalKey.currentState!.showSnackBar(const SnackBar(
                                content: Text('Insert track ID'), backgroundColor: Colors.red));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
