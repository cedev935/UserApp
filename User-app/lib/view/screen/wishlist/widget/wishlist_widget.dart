   import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';

class WishListWidget extends StatelessWidget {
  final Product? product;
  final int? index;
  const WishListWidget({Key? key, this.product, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.only(top: Dimensions.marginSizeSmall),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5)),
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeDefault),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Stack(
                    children: [
                      Container(decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        border: Border.all(width: .5, color: Theme.of(context).primaryColor.withOpacity(.25)),),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder, fit: BoxFit.scaleDown, width: 80, height: 80,
                            image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productThumbnailUrl}/${product!.thumbnail}',
                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.scaleDown, width: 80, height: 80),
                          ),
                        ),
                      ),



                      product!.unitPrice!=null && product!.discount!>0?
                      Positioned(top: 0,left: 0,
                        child: Container(height: 20,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeExtraSmall),
                                  bottomRight: Radius.circular(Dimensions.paddingSizeExtraSmall)),
                              color: Theme.of(context).primaryColor),
                          child: Text(product!.unitPrice!=null && product!.discount != null && product!.discountType != null?
                          PriceConverter.percentageCalculation(context, product!.unitPrice, product!.discount, product!.discountType) : '',
                            style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                                color: Theme.of(context).cardColor),
                          ),
                        ),
                      ):const SizedBox(),
                    ],
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),


                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text(product!.name ?? '',maxLines: 1,overflow: TextOverflow.ellipsis,
                              style: titilliumSemiBold.copyWith(color: ColorResources.getReviewRattingColor(context),
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),



                          InkWell(
                              onTap: (){showDialog(context: context, builder: (_) => CupertinoAlertDialog(
                                  title: Text(getTranslated('ARE_YOU_SURE_WANT_TO_REMOVE_WISH_LIST', context)!),
                                  actions: <Widget>[
                                    TextButton(child: Text(getTranslated('YES', context)!),
                                      onPressed: () {
                                        Provider.of<WishListProvider>(context, listen: false).removeWishList(product!.id, index: index);
                                        Navigator.of(context).pop();
                                      },
                                    ),

                                    TextButton(child: Text(getTranslated('NO', context)!),
                                      onPressed: ()  => Navigator.of(context).pop(),
                                    ),
                                  ],
                                ));
                              },
                                child: Image.asset(Images.delete, scale: 3,
                                  color: ColorResources.getRed(context).withOpacity(.90),)),

                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Row(children: [product!.discount != null && product!.discount!>0?
                          Text(product!.unitPrice != null?PriceConverter.convertPrice(context, product!.unitPrice):'',
                            style: titilliumSemiBold.copyWith(color: ColorResources.getRed(context),
                                decoration: TextDecoration.lineThrough),):const SizedBox(),


                          product!.discount != null && product!.discount!>0?
                          const SizedBox(width: Dimensions.paddingSizeDefault):const SizedBox(),


                          Text(PriceConverter.convertPrice(context, product!.unitPrice,
                              discount: product!.discount,discountType: product!.discountType),
                              maxLines: 1,overflow: TextOverflow.ellipsis,
                              style: titilliumRegular.copyWith(color: ColorResources.getPrimary(context),
                                  fontSize: Dimensions.fontSizeLarge),)
                        ],),


                        Row(children: [
                            Text('${getTranslated('qty', context)}: ${product!.minQty}',
                              style: titleRegular.copyWith(color: ColorResources.getReviewRattingColor(context)),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),



                            InkWell(
                             onTap: (){
                               Navigator.push(context, PageRouteBuilder(
                                 transitionDuration: const Duration(milliseconds: 1000),
                                 pageBuilder: (context, anim1, anim2) => ProductDetails(productId: product!.id,slug: product!.slug, isFromWishList: true),
                               ));
                             },
                              child: Container(
                                height: 30,
                                margin: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1,
                                      blurRadius: 7, offset: const Offset(0, 1),),], gradient: LinearGradient(
                                    colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColor,]),
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),



                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.shopping_cart, color: Colors.white, size: 15),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall,),


                                    FittedBox(child: Text(getTranslated('add_to_cart', context)!,
                                          style: titleRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              const Divider()
            ],
          ),
        ),
      ),
    );
  }
}
