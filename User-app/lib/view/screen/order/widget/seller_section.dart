import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/chat_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/chat_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:provider/provider.dart';

class SellerSection extends StatelessWidget {
  final OrderProvider? order;
  const SellerSection({Key? key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.marginSizeExtraLarge),
      color: Theme.of(context).highlightColor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Provider.of<ChatProvider>(context, listen: false).setUserTypeIndex(context, 0);
                if(order!.orderDetails![0].seller != null){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(
                      id: order!.orderDetails![0].seller!.id,
                    name: order!.orderDetails![0].seller!.shop!.name,
                  )));
                }else{
                  showCustomSnackBar(getTranslated('seller_not_available', context), context,isToaster: true);
                }

              },

              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Row(children: [
                  Expanded(child: Text(getTranslated('seller', context)!, style: robotoBold)),
                  Text(order!.orderDetails![0].seller == null ? 'Admin' :
                  '${order!.orderDetails![0].seller?.shop?.name??'${getTranslated('seller_not_available', context)}'} ',
                    style: titilliumRegular.copyWith(color: ColorResources.hintTextColor),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Icon(Icons.chat, color: Theme.of(context).primaryColor, size: 20),
                ]),
              ),
            ),



          ]),
    );
  }
}
