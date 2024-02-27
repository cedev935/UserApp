import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wallet_transaction_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
class LoyaltyPointConverterBottomSheet extends StatefulWidget {
  final double? myPoint;
  const LoyaltyPointConverterBottomSheet({Key? key, this.myPoint}) : super(key: key);

  @override
  State<LoyaltyPointConverterBottomSheet> createState() => _LoyaltyPointConverterBottomSheetState();
}

class _LoyaltyPointConverterBottomSheetState extends State<LoyaltyPointConverterBottomSheet> {
  final TextEditingController _convertPointAmountController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    int? exchangeRate = Provider.of<SplashProvider>(context,listen: false).configModel!.loyaltyPointExchangeRate;
    int? min = Provider.of<SplashProvider>(context,listen: false).configModel!.loyaltyPointMinimumPoint;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding,vertical: Dimensions.paddingSizeOverLarge),
        height: MediaQuery.of(context).size.height-100,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
              topLeft:  Radius.circular(25),
              topRight: Radius.circular(25)),
        ),
        child: Column(children: [
          Text('${getTranslated('loyalty_point_convert_and_transfer_to_wallet', context)}',
            maxLines: 2,textAlign: TextAlign.center,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).hintColor)),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: Row(mainAxisAlignment:MainAxisAlignment.center,children: [
              Text('$exchangeRate ${getTranslated('points', context)} = ${PriceConverter.convertPrice(context, 1)}',
                style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),),

            ],),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge,),



          CustomTextField(
            isBorder: true,
            controller: _convertPointAmountController,
            hintText: '0',
            isPhoneNumber: false,
            textInputType: TextInputType.number,
          ),

          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          Consumer<WalletTransactionProvider>(
            builder: (context, convert,_) {

              return convert.isConvert?
              Container(width: 30,height: 30,color: Theme.of(context).cardColor,
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),):
              CustomButton(buttonText: '${getTranslated('convert', context)}',
              isBorder: true,
              onTap: (){

                int point = int.parse(_convertPointAmountController.text.trim());
                if(point< min!){
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg: '${getTranslated('minimum_exchange_rate_is', context)!} $exchangeRate',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );

                }
                else if(point.toDouble() > widget.myPoint!){
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor:Colors.red,
                    content: Text('${getTranslated('insufficient_point', context)}'),
                  ));

                }
                else{
                  Provider.of<WalletTransactionProvider>(context, listen: false).convertPointToCurrency(context ,point).then((value){
                    Navigator.pop(context);
                    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
                    Provider.of<WalletTransactionProvider>(context, listen: false).getLoyaltyPointList(context,1);

                  });
                }

              },);
            }
          )



        ],),
      ),
    );
  }
}
