import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/rating_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';
class RecommendedProductView extends StatelessWidget {
  const RecommendedProductView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<ProductProvider>(
          builder: (context, recommended, child) {
            String? ratting = recommended.recommendedProduct != null && recommended.recommendedProduct!.rating != null && recommended.recommendedProduct!.rating!.isNotEmpty? recommended.recommendedProduct!.rating![0].average : "0";

            return recommended.recommendedProduct != null?
            InkWell(
              onTap: () {
                Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (context, anim1, anim2) => ProductDetails(productId: recommended.recommendedProduct!.id, slug: recommended.recommendedProduct!.slug,),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).highlightColor,
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text(getTranslated('recommended_product', context)!,
                        style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                            fontWeight: FontWeight.w600),),
                      const SizedBox(height: Dimensions.paddingSizeSmall,),
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 260,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width-35,
                              height: 120,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeExtraSmall),
                                      bottomRight: Radius.circular(Dimensions.paddingSizeExtraSmall)),
                                  color: Theme.of(context).primaryColor
                              ),
                            ),
                          ),



                          recommended.recommendedProduct !=null && recommended.recommendedProduct!.thumbnail !=null?
                          Positioned(
                            left: 15,
                            top: 15,
                            child: Column(
                              children: [Container(width: MediaQuery.of(context).size.width/2.5,
                                height: MediaQuery.of(context).size.width/2.5,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).highlightColor,
                                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.20),width: .5),
                                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder, fit: BoxFit.cover,
                                      image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.productThumbnailUrl}'
                                          '/${recommended.recommendedProduct!.thumbnail}',
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Container(width: MediaQuery.of(context).size.width/2.5,
                                    padding: const EdgeInsets.only(left: 2,top: 10),
                                    child: Center(
                                      child: Text(recommended.recommendedProduct!.name??'',maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: titilliumRegular.copyWith(color: Theme.of(context).cardColor,
                                              fontSize: Dimensions.fontSizeDefault)),
                                    )),
                              ],
                            ),
                          ):const SizedBox(),

                          Positioned(right: 0,top: 0,
                            child: SizedBox(width: MediaQuery.of(context).size.width/2.5,
                              height: MediaQuery.of(context).size.width/2.5,
                              child:
                            Center(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                Text('${double.parse(ratting!).toStringAsFixed(1)} ${getTranslated('out_of_5', context)}',
                                    style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                  Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      RatingBar(rating: double.parse(ratting), size: 18,),
                                      Text('(${ratting.toString()})')
                                    ],
                                  ),

                                const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
                                recommended.recommendedProduct !=null && recommended.recommendedProduct!.discount!= null && recommended.recommendedProduct!.discount! > 0  ? Text(
                                  PriceConverter.convertPrice(context, recommended.recommendedProduct!.unitPrice),
                                  style: robotoBold.copyWith(
                                    color: ColorResources.getRed(context),
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ) : const SizedBox.shrink(),
                                const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
                                recommended.recommendedProduct != null && recommended.recommendedProduct!.unitPrice != null?
                                Text(
                                  PriceConverter.convertPrice(context, recommended.recommendedProduct!.unitPrice,
                                      discountType: recommended.recommendedProduct!.discountType,
                                      discount: recommended.recommendedProduct!.discount),
                                  style: titilliumSemiBold.copyWith(
                                    color: ColorResources.getPrimary(context),
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                  ),
                                ):const SizedBox(),

                              ],),
                            ),),
                          ),


                          Positioned(
                            right: 25,bottom: 70,
                            child: Container(width: 110,height: 35,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                              color: Theme.of(context).cardColor.withOpacity(.25),
                            ),
                            child: Center(child: Text(getTranslated('buy_now', context)!,
                              style: TextStyle(color: Theme.of(context).cardColor),)),),
                          ),


                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ):const SizedBox();

          },
        ),
      ],
    );
  }


}

