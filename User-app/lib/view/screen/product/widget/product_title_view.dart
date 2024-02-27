import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_details_model.dart' as pd;
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';


class ProductTitleView extends StatelessWidget {
  final pd.ProductDetailsModel? productModel;
  final String? averageRatting;
  const ProductTitleView({Key? key, required this.productModel, this.averageRatting}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double? startingPrice = 0;
    double? endingPrice;
    if(productModel!.variation != null && productModel!.variation!.isNotEmpty) {
      List<double?> priceList = [];
      for (var variation in productModel!.variation!) {
        priceList.add(variation.price);
      }
      priceList.sort((a, b) => a!.compareTo(b!));
      startingPrice = priceList[0];
      if(priceList[0]! < priceList[priceList.length-1]!) {
        endingPrice = priceList[priceList.length-1];
      }
    }else {
      startingPrice = productModel!.unitPrice;
    }

    return productModel != null? Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Consumer<ProductDetailsProvider>(
        builder: (context, details, child) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [

              Expanded(child: Text(productModel!.name ?? '',
                  style: titleRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                  maxLines: 2)),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),


              Column(children: [
                productModel!.discount != null && productModel!.discount! > 0 ?
                Text('${PriceConverter.convertPrice(context, startingPrice)}'
                      '${endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, endingPrice)}' : ''}',
                  style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                      decoration: TextDecoration.lineThrough),
                ):const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),


                Text('${startingPrice != null ?PriceConverter.convertPrice(context, startingPrice,
                    discount: productModel!.discount, discountType: productModel!.discountType):''}'
                      '${endingPrice !=null ? ' - ${PriceConverter.convertPrice(context, endingPrice,
                    discount: productModel!.discount, discountType: productModel!.discountType)}' : ''}',
                  style: titilliumBold.copyWith(color: ColorResources.getPrimary(context),
                      fontSize: Dimensions.fontSizeLarge),
                ),
              ],),
            ]),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Row(children: [
              Text('${details.reviewList != null ? details.reviewList!.length : 0} reviews | ',
                  style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                    fontSize: Dimensions.fontSizeDefault,)),

              Text('${details.orderCount} orders | ', style: titilliumRegular.copyWith(
                color: Theme.of(context).hintColor,
                fontSize: Dimensions.fontSizeDefault,
              )),

              Text('${details.wishCount} wish', style: titilliumRegular.copyWith(
                color: Theme.of(context).hintColor,
                fontSize: Dimensions.fontSizeDefault,
              )),

              const Expanded(child: SizedBox.shrink()),
              const SizedBox(width: 5),


              Row(children: [
                const Icon(Icons.star, color: Colors.orange,),
                Text('${productModel!.reviews != null ? productModel!.reviews!.isNotEmpty ?
                double.parse(averageRatting!) : 0.0 : 0.0}')
              ],),

            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),



            productModel!.colors != null && productModel!.colors!.isNotEmpty ?
            Row( children: [
              Text('${getTranslated('select_variant', context)} : ',
                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
              Expanded(
                child: SizedBox(height: 40,
                  child: ListView.builder(
                    itemCount: productModel!.colors!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,

                    itemBuilder: (context, index) {
                      String colorString = '0xff${productModel!.colors![index].code!.substring(1, 7)}';
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                             ),
                        child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          child: Container(height: 30, width: 30,
                            padding: const EdgeInsets.all( Dimensions.paddingSizeExtraSmall),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Color(int.parse(colorString)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]) : const SizedBox(),
          productModel!.colors != null &&  productModel!.colors!.isNotEmpty ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),




            productModel!.choiceOptions!=null && productModel!.choiceOptions!.isNotEmpty?
            ListView.builder(
              shrinkWrap: true,
              itemCount: productModel!.choiceOptions!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text('${getTranslated('available', context)} ${productModel!.choiceOptions![index].title} :',
                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                          childAspectRatio: (1 / .5),
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productModel!.choiceOptions![index].options!.length,
                        itemBuilder: (context, i) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: .3,color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(productModel!.choiceOptions![index].options![i].trim(), maxLines: 2,
                                  overflow: TextOverflow.ellipsis, style: titilliumRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                   )),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ]);
              },
            ):const SizedBox(),

          ]);
        },
      ),
    ):const SizedBox();
  }
}
