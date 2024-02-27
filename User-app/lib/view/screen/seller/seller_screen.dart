import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/seller_model.dart';

import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
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

class SellerScreen extends StatefulWidget {
  final SellerModel? seller;
  const SellerScreen({Key? key, required this.seller}) : super(key: key);

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  final ScrollController _scrollController = ScrollController();

  void _load(){
    Provider.of<ProductProvider>(context, listen: false).removeFirstLoading();
    Provider.of<ProductProvider>(context, listen: false).clearSellerData();
    Provider.of<ProductProvider>(context, listen: false).initSellerProductList(widget.seller!.seller!.id.toString(), 1, context);
  }


  @override
  void initState() {
    super.initState();
    _load();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    String ratting = widget.seller != null && widget.seller!.avgRating != null? widget.seller!.avgRating.toString() : "0";



    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),

      body: Column(
        children: [
          CustomAppBar(title: '${widget.seller!.seller!.fName}'' ''${widget.seller!.seller!.lName}'),

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
                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.shopImageUrl}/banner/${widget.seller!.seller!.shop != null ? widget.seller!.seller!.shop!.banner : ''}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 120, fit: BoxFit.cover),
                    ),
                  ),
                ),

                Container(
                  color: Theme.of(context).highlightColor,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(children: [

                    // Seller Info
                    Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder, height: 80, width: 80, fit: BoxFit.cover,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.shopImageUrl}/${widget.seller!.seller!.shop!.image}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 80, width: 80, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.seller!.seller!.shop!.name!, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis,),

                            Row(
                              children: [
                                RatingBar(rating: double.parse(ratting)),
                                Text('(${widget.seller!.totalReview.toString()})' , style: titilliumRegular.copyWith(), maxLines: 1, overflow: TextOverflow.ellipsis,),

                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Row(
                              children: [
                                Text('${widget.seller!.totalReview} ${getTranslated('reviews', context)}',
                                  style: titleRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                                      color: ColorResources.getReviewRattingColor(context)),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,),
                                const SizedBox(width: Dimensions.paddingSizeDefault),

                                const Text('|'),
                                const SizedBox(width: Dimensions.paddingSizeDefault),

                                Text('${widget.seller!.totalProduct} ${getTranslated('products', context)}',
                                  style: titleRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                                      color: ColorResources.getReviewRattingColor(context)),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,),
                              ],
                            ),


                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if(!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                            showAnimatedDialog(context, const GuestDialog(), isFlip: true);
                          }else if(widget.seller != null) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                ChatScreen(
                                  id: widget.seller!.seller!.id,
                                  name: widget.seller!.seller!.shop!.name,
                                )));
                          }
                        },
                        icon: Image.asset(Images.chatImage, color: ColorResources.sellerText, height: Dimensions.iconSizeDefault),
                      ),
                    ]),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Padding(
                  padding:  const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeExtraExtraSmall),
                  child: SearchWidget(
                    hintText: 'Search product...',
                    onTextChanged: (String newText) => Provider.of<ProductProvider>(context, listen: false).filterData(newText),
                    onClearPressed: () {},
                    isSeller: true,
                    onSubmit: (String text) {
                      if(text.trim().isEmpty) {
                        showCustomSnackBar(getTranslated('enter_somethings', context)!, context);
                      }else{
                        Provider.of<ProductProvider>(context, listen: false).initSellerProductList(widget.seller!.seller!.id.toString(), 1, context, search: text);
                      }},
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: ProductView(isHomePage: false, productType: ProductType.sellerProduct,
                      scrollController: _scrollController, sellerId: widget.seller!.seller!.id.toString()),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
