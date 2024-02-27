import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/top_seller_model.dart';

import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/rating_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/search_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/chat_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/products_view.dart';
import 'package:provider/provider.dart';

class TopSellerProductScreen extends StatefulWidget {
  final TopSellerModel? topSeller;
  final int? topSellerId;

  const TopSellerProductScreen({Key? key, required this.topSeller, this.topSellerId}) : super(key: key);

  @override
  State<TopSellerProductScreen> createState() => _TopSellerProductScreenState();
}

class _TopSellerProductScreenState extends State<TopSellerProductScreen> {
  final ScrollController _scrollController = ScrollController();
  bool vacationIsOn = false;

  void _load(){
    Provider.of<ProductProvider>(context, listen: false).clearSellerData();
    Provider.of<ProductProvider>(context, listen: false).initSellerProductList(widget.topSeller!.sellerId.toString(), 1, context);
    Provider.of<SellerProvider>(context, listen: false).initSeller(widget.topSeller!.sellerId.toString(), context);
  }


  @override
  void initState() {
    super.initState();
    _load();
  }


  @override
  Widget build(BuildContext context) {

    if(widget.topSeller!.vacationEndDate != null){
      DateTime vacationDate = DateTime.parse(widget.topSeller!.vacationEndDate!);
      DateTime vacationStartDate = DateTime.parse(widget.topSeller!.vacationStartDate!);
      final today = DateTime.now();
      final difference = vacationDate.difference(today).inDays;
      final startDate = vacationStartDate.difference(today).inDays;

      if(difference >= 0 && widget.topSeller!.vacationStatus == 1 && startDate <= 0){
        vacationIsOn = true;
      }

      else{
        vacationIsOn = false;
      }
      if (kDebugMode) {
        print('------=>${widget.topSeller!.name}${widget.topSeller!.vacationEndDate}/${widget.topSeller!.vacationStartDate}${vacationIsOn.toString()}/${difference.toString()}/${startDate.toString()}');
      }

    }


    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),

      body: Column(
        children: [

          CustomAppBar(title: widget.topSeller!.name),

          Expanded(
            child: ListView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0),
              children: [

                // Banner
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholder, height: 120, fit: BoxFit.cover,
                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.shopImageUrl}/banner/${widget.topSeller!.banner ?? ''}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 120, fit: BoxFit.cover),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),

                  child: Column(children: [

                    // Seller Info
                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).highlightColor,
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholder, height: 80, width: 80, fit: BoxFit.cover,
                                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.shopImageUrl}/${widget.topSeller!.image}',
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 80, width: 80, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          if(widget.topSeller!.temporaryClose == 1  || vacationIsOn)
                            Container(width: 80,height: 80,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.5),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                              ),
                            ),
                          widget.topSeller!.temporaryClose ==1?
                          Positioned(top: 0,bottom: 0,left: 0,right: 0,
                            child: Align(
                              alignment: Alignment.center,
                              child: Center(child: Text(getTranslated('temporary_closed', context)!, textAlign: TextAlign.center,
                                style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge),)),
                            ),
                          ):
                          vacationIsOn?
                          Positioned(top: 0,bottom: 0,left: 0,right: 0,
                            child: Align(
                              alignment: Alignment.center,
                              child: Center(child: Text(getTranslated('close_for_now', context)!, textAlign: TextAlign.center,
                                style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge),)),
                            ),
                          ):
                          const SizedBox()
                        ],
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Consumer<SellerProvider>(
                          builder: (context, sellerProvider,_) {
                            String ratting = sellerProvider.sellerModel != null && sellerProvider.sellerModel!.avgRating != null?
                            sellerProvider.sellerModel!.avgRating.toString() : "0";

                            return Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                    Expanded(child: Text(
                                      widget.topSeller!.name!,
                                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,),),

                                    InkWell(
                                      onTap: () {
                                        if(!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                          showAnimatedDialog(context, const GuestDialog(), isFlip: true);
                                        }else if(widget.topSeller != null) {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) =>
                                                  ChatScreen(
                                                    id: widget.topSeller!.sellerId,
                                                    name: widget.topSeller?.name??'',
                                                  )));
                                        }
                                      },
                                      child : Image.asset(Images.chatImage, height: Dimensions.iconSizeDefault),
                                    ),
                                  ],
                                ),


                                sellerProvider.sellerModel != null?
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        RatingBar(rating: double.parse(ratting)),
                                        Text('(${sellerProvider.sellerModel!.totalReview.toString()})' ,
                                          style: titilliumRegular.copyWith(), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                      ],
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),


                                    Row(children: [
                                      Text('${sellerProvider.sellerModel!.totalReview} ${getTranslated('reviews', context)}',
                                        style: titleRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                                            color: ColorResources.getReviewRattingColor(context)),
                                        maxLines: 1, overflow: TextOverflow.ellipsis,),
                                        const SizedBox(width: Dimensions.paddingSizeDefault),

                                        const Text('|'),
                                        const SizedBox(width: Dimensions.paddingSizeDefault),

                                        Text('${sellerProvider.sellerModel!.totalProduct} ${getTranslated('products', context)}',
                                          style: titleRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                                              color: ColorResources.getReviewRattingColor(context)),
                                          maxLines: 1, overflow: TextOverflow.ellipsis,),
                                      ],
                                    ),


                                  ],
                                ):const SizedBox(),

                              ],
                            );
                          }
                        ),
                      ),

                    ]),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Consumer<ProductProvider>(
                  builder: (context, productProvider,_) {
                    return Center(
                      child: Padding(
                        padding:  const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeExtraExtraSmall),
                        child: SearchWidget(
                          hintText: 'Search product...',
                          onTextChanged: (String newText) {},
                          onClearPressed: () {},
                          searchController: productProvider.sellerProductSearch,
                          isSeller: true,
                          sellerId: widget.topSeller!.sellerId.toString(),
                          onTap: () {
                            if(productProvider.sellerProductSearch.text.trim().isEmpty) {
                              showCustomSnackBar(getTranslated('enter_somethings', context)!, context);
                            }else{
                              Provider.of<ProductProvider>(context, listen: false).initSellerProductList(widget.topSeller!.sellerId.toString(), 1, context, search: productProvider.sellerProductSearch.text);
                            }},
                        ),
                      ),
                    );
                  }
                ),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: ProductView(isHomePage: false, productType: ProductType.sellerProduct,
                      scrollController: _scrollController, sellerId: widget.topSeller!.id.toString()),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
