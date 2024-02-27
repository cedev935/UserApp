import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/provider/flash_deal_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';

import 'featured_deal_view.dart';

class FlashDealsView extends StatelessWidget {
  final bool isHomeScreen;
  const FlashDealsView({Key? key, this.isHomeScreen = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return isHomeScreen?
    Consumer<FlashDealProvider>(
      builder: (context, megaProvider, child) {
        double width = MediaQuery.of(context).size.width;
        return Provider.of<FlashDealProvider>(context).flashDealList.isNotEmpty ? ListView.builder(
          padding: const EdgeInsets.all(0),
          scrollDirection: isHomeScreen ? Axis.horizontal : Axis.vertical,
          itemCount: megaProvider.flashDealList.isEmpty ? 2 : megaProvider.flashDealList.length,
          itemBuilder: (context, index) {

            return SizedBox(
              width: width,
              child:  megaProvider.flashDealList.isNotEmpty ?
              Stack(
                fit: StackFit.expand,
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      viewportFraction: .55,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      disableCenter: true,
                      onPageChanged: (index, reason) {
                        Provider.of<FlashDealProvider>(context, listen: false).setCurrentIndex(index);
                      },
                    ),
                    itemCount: megaProvider.flashDealList.isEmpty ?
                    1 : megaProvider.flashDealList.length,
                    itemBuilder: (context, index, _) {

                      return InkWell(
                        onTap: () {
                          Navigator.push(context, PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 1000),
                            pageBuilder: (context, anim1, anim2) => ProductDetails(productId: megaProvider.flashDealList[index].id,slug: megaProvider.flashDealList[index].slug,),
                          ));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).highlightColor,
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
                          child: Stack(children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: MediaQuery.of(context).size.width/2.2,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.2),width: .1),
                                    color: ColorResources.getIconBg(context),
                                    borderRadius: const BorderRadius.all( Radius.circular(10)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all( Radius.circular(10)),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder, fit: BoxFit.cover,
                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productThumbnailUrl}'
                                          '/${megaProvider.flashDealList[index].thumbnail}',
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                                        fit: BoxFit.cover,height: width*.50,),
                                    ),
                                  ),
                                ),
                              ),


                              Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(megaProvider.flashDealList[index].name!,
                                      style: robotoRegular, maxLines: 2,
                                      overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                                    Row(children: [
                                      Text(
                                        megaProvider.flashDealList[index].rating!.isNotEmpty ?
                                        double.parse(megaProvider.flashDealList[index].rating![0].average!).toStringAsFixed(1) : '0.0',
                                        style: robotoRegular.copyWith(color: Provider.of<ThemeProvider>(context).darkTheme ?
                                        Colors.white : Colors.orange, fontSize: Dimensions.fontSizeSmall),
                                      ),
                                      Icon(Icons.star, color: Provider.of<ThemeProvider>(context).darkTheme ?
                                      Colors.white : Colors.orange, size: 15),
                                      Text('(${megaProvider.flashDealList[index].reviewCount.toString()})',
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                          )),
                                      const Spacer(),


                                      Text(megaProvider.flashDealList[index].discount! > 0 ?
                                        PriceConverter.convertPrice(context, megaProvider.flashDealList[index].unitPrice) : '',
                                        style: robotoBold.copyWith(
                                          color: ColorResources.hintTextColor,
                                          decoration: TextDecoration.lineThrough,
                                          fontSize: Dimensions.fontSizeExtraSmall,
                                        ),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),


                                      Text(PriceConverter.convertPrice(context, megaProvider.flashDealList[index].unitPrice,
                                          discountType: megaProvider.flashDealList[index].discountType,
                                          discount: megaProvider.flashDealList[index].discount),
                                        style: robotoBold.copyWith(color: ColorResources.getPrimary(context)),
                                      ),
                                    ]),


                                  ],
                                ),
                              ),
                            ]),


                            megaProvider.flashDealList[index].discount! >= 1 ?
                            Positioned(top: 0, left: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                height: 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: ColorResources.getPrimary(context),
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                child: Text(PriceConverter.percentageCalculation(
                                  context,
                                  megaProvider.flashDealList[index].unitPrice,
                                  megaProvider.flashDealList[index].discount,
                                  megaProvider.flashDealList[index].discountType,),
                                  style: robotoRegular.copyWith(color: Theme.of(context).highlightColor,
                                      fontSize: Dimensions.fontSizeSmall),
                                ),
                              ),
                            ) : const SizedBox.shrink(),


                          ]),
                        ),
                      );
                    },
                  ),

                ],
              ) : const SizedBox()
            );

          },
        ) : MegaDealShimmer(isHomeScreen: isHomeScreen);
      },
    ):Consumer<FlashDealProvider>(
      builder: (context, megaProvider, child) {
        return Provider.of<FlashDealProvider>(context).flashDealList.isNotEmpty ?
        ListView.builder(
          padding: const EdgeInsets.all(0),
          scrollDirection: isHomeScreen ? Axis.horizontal : Axis.vertical,
          itemCount: megaProvider.flashDealList.isEmpty ? 2 : megaProvider.flashDealList.length,
          itemBuilder: (context, index) {

            return InkWell(
              onTap: () {
                Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (context, anim1, anim2) => ProductDetails(productId: megaProvider.flashDealList[index].id, slug: megaProvider.flashDealList[index].slug,),
                ));
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                width: isHomeScreen ? 300 : null,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).highlightColor,
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
                child: Stack(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: ColorResources.getIconBg(context),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                        ),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder, fit: BoxFit.cover,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productThumbnailUrl}'
                              '/${megaProvider.flashDealList[index].thumbnail}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(megaProvider.flashDealList[index].name!,
                              style: robotoRegular,
                              maxLines: 2, overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeDefault,),


                            Row(children: [
                              Text(megaProvider.flashDealList[index].rating!.isNotEmpty ?
                                double.parse(megaProvider.flashDealList[index].rating![0].average!).toStringAsFixed(1) : '0.0',
                                style: robotoRegular.copyWith( fontSize: Dimensions.fontSizeSmall),
                              ),
                              Icon(Icons.star, color: Provider.of<ThemeProvider>(context).darkTheme ?
                              Colors.white : Colors.orange, size: 15),

                              Text('(${megaProvider.flashDealList[index].reviewCount.toString()})',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,)),
                            ]),
                            const SizedBox(height: Dimensions.paddingSizeDefault,),


                            Row(
                              children: [
                                Text(megaProvider.flashDealList[index].discount! > 0 ?
                                  PriceConverter.convertPrice(context, megaProvider.flashDealList[index].unitPrice) : '',
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.getRed(context),
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeDefault,),


                                Text(PriceConverter.convertPrice(context, megaProvider.flashDealList[index].unitPrice,
                                      discountType: megaProvider.flashDealList[index].discountType, discount: megaProvider.flashDealList[index].discount),
                                  style: titleRegular.copyWith(color: ColorResources.getPrimary(context), fontSize: Dimensions.fontSizeLarge),
                                ),
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          ],
                        ),
                      ),
                    ),
                  ]),

                  // Off
                  megaProvider.flashDealList[index].discount! >= 1 ?
                  Positioned(top: 0, left: 0,
                    child: Container(height: 20, alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorResources.getPrimary(context),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),


                      child: Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: Text(PriceConverter.percentageCalculation(
                          context,
                          megaProvider.flashDealList[index].unitPrice,
                          megaProvider.flashDealList[index].discount,
                          megaProvider.flashDealList[index].discountType,),
                          style: robotoRegular.copyWith(color: Theme.of(context).highlightColor,
                              fontSize: Dimensions.fontSizeSmall),
                        ),
                      ),
                    ),
                  ) : const SizedBox.shrink(),
                ]),
              ),
            );
          },
        ) : MegaDealShimmer(isHomeScreen: isHomeScreen);
      },
    );
  }
}



