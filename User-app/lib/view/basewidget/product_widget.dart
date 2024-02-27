import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/rating_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product productModel;
  const ProductWidget({Key? key, required this.productModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String ratting = productModel.rating != null && productModel.rating!.isNotEmpty? productModel.rating![0].average! : "0";

    return InkWell(
      onTap: () {
        Navigator.push(context, PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (context, anim1, anim2) => ProductDetails(productId: productModel.id,slug: productModel.slug),
        ));
      },
      child: Container(
        height: Dimensions.cardHeight,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).highlightColor,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
        ),
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Product Image
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: ColorResources.getIconBg(context),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholder, fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.width/2.45,
                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productThumbnailUrl}/${productModel.thumbnail}',
                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_1x1,
                      fit: BoxFit.cover,height: MediaQuery.of(context).size.width/2.45),
                ),
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.only(top :Dimensions.paddingSizeSmall,bottom: 5, left: 5,right: 5),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(productModel.name ?? '', textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.w400), maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBar(
                            rating: double.parse(ratting),
                            size: 18,
                          ),


                      Text('(${productModel.reviewCount.toString()})',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                          )),

                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                      productModel.discount!= null && productModel.discount! > 0 ?
                      Text(PriceConverter.convertPrice(context, productModel.unitPrice),
                      style: titleRegular.copyWith(
                        color: ColorResources.getRed(context),
                        decoration: TextDecoration.lineThrough,

                        fontSize: Dimensions.fontSizeExtraSmall,
                      ),
                    ) : const SizedBox.shrink(),
                    const SizedBox(height: 2,),


                    Text(PriceConverter.convertPrice(context,
                        productModel.unitPrice, discountType: productModel.discountType,
                        discount: productModel.discount),
                      style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                    ),



                  ],
                ),
              ),
            ),
          ]),

          // Off

          productModel.discount! > 0 ?
          Positioned(top: 0, left: 0, child: Container(
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                color: ColorResources.getPrimary(context),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              ),


              child: Center(
                child: Text(PriceConverter.percentageCalculation(context, productModel.unitPrice,
                      productModel.discount, productModel.discountType),
                  style: robotoRegular.copyWith(color: Theme.of(context).highlightColor,
                      fontSize: Dimensions.fontSizeSmall),
                ),
              ),
            ),
          ) : const SizedBox.shrink(),

        ]),
      ),
    );
  }
}
