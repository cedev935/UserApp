import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  final CartModel? cartModel;
  final int index;
  final bool fromCheckout;
  const CartWidget({Key? key, this.cartModel, required this.index, required this.fromCheckout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (kDebugMode) {
          print('======>product is=====>${cartModel!.id}/${cartModel!.name}');
        }
        Navigator.push(context, PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (context, anim1, anim2) => ProductDetails(productId: cartModel!.productId, slug: cartModel!.slug,),
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(color: Theme.of(context).highlightColor,

        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment:  MainAxisAlignment.start,
            children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.20),width: 1)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder, height: 60, width: 60,
                image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.productThumbnailUrl}/${cartModel!.thumbnail}',
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,fit: BoxFit.cover, height: 60, width: 60),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(cartModel!.name!, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: titilliumBold.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: ColorResources.getReviewRattingColor(context),
                          )),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        !fromCheckout ? InkWell(
                          onTap: () {
                            if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                              Provider.of<CartProvider>(context, listen: false).removeFromCartAPI(context,cartModel!.id);
                            }else {
                              Provider.of<CartProvider>(context, listen: false).removeFromCart(index);
                            }
                          },
                          child: SizedBox(width: 20,height: 20,
                              child: Image.asset(Images.delete,scale: .5,)),
                        ) : const SizedBox.shrink(),
                      ],

                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                    Row(
                      children: [

                        cartModel!.discount!>0?
                        Text(
                          PriceConverter.convertPrice(context, cartModel!.price),maxLines: 1,overflow: TextOverflow.ellipsis,
                          style: titilliumSemiBold.copyWith(color: ColorResources.getRed(context),
                              decoration: TextDecoration.lineThrough,
                          ),
                        ):const SizedBox(),
                        const SizedBox(width: Dimensions.fontSizeDefault,),
                        Text(
                          PriceConverter.convertPrice(context, cartModel!.price,
                              discount: cartModel!.discount,discountType: 'amount'),
                          maxLines: 1,overflow: TextOverflow.ellipsis,
                          style: titilliumRegular.copyWith(
                              color: ColorResources.getPrimary(context),

                              fontSize: Dimensions.fontSizeExtraLarge
                              ),
                        ),
                      ],
                    ),


                    //variation
                    (cartModel!.variant != null && cartModel!.variant!.isNotEmpty) ? Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                      child: Row(children: [
                        Flexible(child: Text(cartModel!.variant!,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.getReviewRattingColor(context),))),
                      ]),
                    ) : const SizedBox(),
                    const SizedBox(width: Dimensions.paddingSizeSmall),


                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      cartModel!.shippingType !='order_wise' && Provider.of<AuthProvider>(context, listen: false).isLoggedIn()?
                      Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                        child: Row(children: [
                          Text('${getTranslated('shipping_cost', context)}: ',
                              style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                                  color: ColorResources.getReviewRattingColor(context))),
                          Text(PriceConverter.convertPrice(context, cartModel!.shippingCost),
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).disabledColor,)),
                        ]),
                      ):const SizedBox(),



                      Provider.of<AuthProvider>(context, listen: false).isLoggedIn() ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            child: QuantityButton(isIncrement: false, index: index,
                              quantity: cartModel!.quantity,
                              maxQty: cartModel!.productInfo!.totalCurrentStock,
                              cartModel: cartModel, minimumOrderQuantity: cartModel!.productInfo!.minimumOrderQty,
                              digitalProduct: cartModel!.productType == "digital"? true : false,

                            ),
                          ),
                          Text(cartModel!.quantity.toString(), style: titilliumSemiBold),

                          Padding(
                            padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                            child: QuantityButton(index: index, isIncrement: true,
                              quantity: cartModel!.quantity,
                              maxQty: cartModel!.productInfo!.totalCurrentStock,
                              cartModel: cartModel, minimumOrderQuantity: cartModel!.productInfo!.minimumOrderQty,
                              digitalProduct: cartModel!.productType == "digital"? true : false,
                            ),
                          ),
                        ],
                      ) : const SizedBox.shrink(),
                    ],),

                  ],
                ),
            ),
          ),



        ]),
      ),
    );
  }
}

class QuantityButton extends StatelessWidget {
  final CartModel? cartModel;
  final bool isIncrement;
  final int? quantity;
  final int index;
  final int? maxQty;
  final int? minimumOrderQuantity;
  final bool? digitalProduct;
  const QuantityButton({Key? key, required this.isIncrement, required this.quantity, required this.index,
    required this.maxQty,required this.cartModel, this.minimumOrderQuantity, this.digitalProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isIncrement && quantity! > minimumOrderQuantity!) {
            Provider.of<CartProvider>(context, listen: false).updateCartProductQuantity(cartModel!.id, cartModel!.quantity!-1, context).then((value) {
              showCustomSnackBar(value.message, context,isError: value.isSuccess);
            });
        } else if ((isIncrement && quantity! < maxQty!) || (isIncrement && digitalProduct!)) {
          Provider.of<CartProvider>(context, listen: false).updateCartProductQuantity(cartModel!.id, cartModel!.quantity!+1, context).then((value) {
            showCustomSnackBar(value.message, context,isError: !value.isSuccess);
          });
        }else{
          showCustomSnackBar('${getTranslated('minimum_order_quantity_is', context)} $minimumOrderQuantity', context);
        }
      },
      child: Icon(
        isIncrement ? Icons.add_circle : Icons.remove_circle,
        color: isIncrement
            ?  quantity! >= maxQty! && !digitalProduct!? ColorResources.getGrey(context)
            : ColorResources.getPrimary(context)
            : quantity! > 1
            ? ColorResources.getPrimary(context)
            : ColorResources.getGrey(context),
        size: 30,
      ),
    );
  }
}

