import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wallet_transaction_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/category/all_category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/loyaltyPoint/loyalty_point_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/web_view_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/widget/html_view_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/widget/sign_out_confirmation_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/notification/notification_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/offer/offers_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/order_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/profile/address_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/profile/profile_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/setting/settings_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/support_ticket_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/wallet/wallet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

import 'faq_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late bool isGuestMode;
  String? version;
  bool singleVendor = false;
  @override
  void initState() {
    isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(!isGuestMode) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      version = Provider.of<SplashProvider>(context,listen: false).configModel!.version ?? 'version';
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      if(Provider.of<SplashProvider>(context,listen: false).configModel!.walletStatus == 1){
        Provider.of<WalletTransactionProvider>(context, listen: false).getTransactionList(context,1);
      }
      if(Provider.of<SplashProvider>(context,listen: false).configModel!.loyaltyPointStatus == 1){
        Provider.of<WalletTransactionProvider>(context, listen: false).getLoyaltyPointList(context,1);
      }


    }
    singleVendor = Provider.of<SplashProvider>(context, listen: false).configModel!.businessMode == "single";

    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Stack(children: [
        Positioned(top: 0, left: 0, right: 0,
          child: Image.asset(Images.morePageHeader,
            height: 150, fit: BoxFit.fill,
            color: Provider.of<ThemeProvider>(context).darkTheme ?
            Colors.black : Theme.of(context).primaryColor,
          ),
        ),


        Positioned(top: 40, left: Dimensions.paddingSizeSmall,
          right: Dimensions.paddingSizeSmall,
          child: Consumer<ProfileProvider>(
            builder: (context, profile, child) {
              return Row(children: [
                Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                  child: Image.asset(Images.logoWithNameImageWhite, height: 35),
                ),
                const Expanded(child: SizedBox.shrink()),
                InkWell(
                  onTap: () {
                    if(isGuestMode) {
                      showAnimatedDialog(context, const GuestDialog(), isFlip: true);
                    }else {
                      if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
                      }
                    }
                  },
                  child: Row(children: [
              Column(children: [
                    Text(!isGuestMode ? profile.userInfoModel != null ?
                    '${profile.userInfoModel!.fName} ${profile.userInfoModel!.lName}}' : 'Full Name' : 'Guest',
                        style: titilliumRegular.copyWith(color: ColorResources.white, )),
                Text(!isGuestMode ? profile.userInfoModel != null ?
                '${profile.userInfoModel!.phone}' : '' : '',
                    textDirection: TextDirection.ltr,
                    style: titilliumRegular.copyWith(color: ColorResources.white, )),
                const SizedBox(width: Dimensions.paddingSizeSmall),
]),

                    isGuestMode ? const CircleAvatar(child: Icon(Icons.person, size: 35)) :
                    profile.userInfoModel == null ?
                    const CircleAvatar(child: Icon(Icons.person, size: 35)) : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.logoImage, width: 35, height: 35, fit: BoxFit.fill,
                        image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.customerImageUrl}/'
                            '${profile.userInfoModel!.image}',
                        imageErrorBuilder: (c, o, s) => const CircleAvatar(child: Icon(Icons.person, size: 35)),
                      ),
                    ),
                  ]),
                ),
              ]);
            },
          ),
        ),


        Container(
          margin: const EdgeInsets.only(top: 120),
          decoration: BoxDecoration(
            color: ColorResources.getIconBg(context),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  // Top Row Items
                  SizedBox(height: MediaQuery.of(context).size.width/3.6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
                          Expanded(
                            child: ListView(scrollDirection:Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  Provider.of<SplashProvider>(context,listen: false).configModel!.walletStatus ==1?
                                  SquareButton(image: Images.wallet, title: getTranslated('wallet', context),
                                    navigateTo: const WalletScreen(),count: 1,hasCount: false):const SizedBox(),


                                  Provider.of<SplashProvider>(context,listen: false).configModel!.loyaltyPointStatus ==1?
                                  SquareButton(image: Images.loyaltyPoint, title: getTranslated('loyalty_point', context),
                                    navigateTo: const LoyaltyPointScreen(),count: 1,hasCount: false,):const SizedBox(),


                                  SquareButton(image: Images.shoppingImage, title: getTranslated('orders', context),
                                    navigateTo: const OrderScreen(),count: 1,hasCount: false,),

                                  SquareButton(image: Images.cartImage, title: getTranslated('CART', context),
                                    navigateTo: const CartScreen(),
                                    count: Provider.of<CartProvider>(context,listen: false).cartList.length, hasCount: true,),

                                  SquareButton(image: Images.offers, title: getTranslated('offers', context),
                                    navigateTo: const OffersScreen(),count: 0,hasCount: false,),

                                  SquareButton(image: Images.wishlist, title: getTranslated('wishlist', context),
                                    navigateTo: const WishListScreen(),
                                    count: Provider.of<AuthProvider>(context, listen: false).isLoggedIn() &&
                                    Provider.of<WishListProvider>(context, listen: false).wishList != null &&
                                    Provider.of<WishListProvider>(context, listen: false).wishList!.isNotEmpty ?
                                    Provider.of<WishListProvider>(context, listen: false).wishList!.length : 0, hasCount: false,),
                                ]),
                          ),
                          Icon(Icons.arrow_forward_ios,color: Theme.of(context).primaryColor,),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),




                  // Buttons
                  TitleButton(image: Images.fastDelivery, title: getTranslated('address', context),
                      navigateTo: const AddressListScreen()),

                  TitleButton(image: Images.moreFilledImage, title: getTranslated('all_category', context),
                      navigateTo: const AllCategoryScreen()),

                  TitleButton(image: Images.notificationFilled, title: getTranslated('notification', context),
                      navigateTo: const NotificationScreen()),

                  singleVendor?const SizedBox():
                  TitleButton(image: Images.chats, title: getTranslated('chats', context),
                      navigateTo: const InboxScreen()),

                  TitleButton(image: Images.settings, title: getTranslated('settings', context),
                      navigateTo: const SettingsScreen()),

                  TitleButton(image: Images.preference, title: getTranslated('support_ticket', context),
                      navigateTo: SupportTicketScreen()),

                  TitleButton(image: Images.termCondition, title: getTranslated('terms_condition', context),
                      navigateTo: HtmlViewScreen(title: getTranslated('terms_condition', context),
                        url: Provider.of<SplashProvider>(context, listen: false).configModel!.termsConditions,)),

                  TitleButton(image: Images.privacyPolicy, title: getTranslated('privacy_policy', context),
                      navigateTo: HtmlViewScreen(title: getTranslated('privacy_policy', context),
                        url: Provider.of<SplashProvider>(context, listen: false).configModel!.privacyPolicy,)),

                  if(Provider.of<SplashProvider>(context, listen: false).configModel!.refundPolicy!.status ==1)
                    TitleButton(image: Images.refundPolicy, title: getTranslated('refund_policy', context),
                        navigateTo: HtmlViewScreen(title: getTranslated('refund_policy', context),
                          url: Provider.of<SplashProvider>(context, listen: false).configModel!.refundPolicy!.content,)),

                  if(Provider.of<SplashProvider>(context, listen: false).configModel!.returnPolicy!.status ==1)
                    TitleButton(image: Images.returnPolicy, title: getTranslated('return_policy', context),
                        navigateTo: HtmlViewScreen(title: getTranslated('return_policy', context),
                          url: Provider.of<SplashProvider>(context, listen: false).configModel!.returnPolicy!.content,)),

                  if(Provider.of<SplashProvider>(context, listen: false).configModel!.cancellationPolicy!.status ==1)
                    TitleButton(image: Images.cPolicy, title: getTranslated('cancellation_policy', context),
                        navigateTo: HtmlViewScreen(title: getTranslated('cancellation_policy', context),
                          url: Provider.of<SplashProvider>(context, listen: false).configModel!.cancellationPolicy!.content,)),

                  TitleButton(image: Images.helpCenter, title: getTranslated('faq', context),
                      navigateTo: FaqScreen(title: getTranslated('faq', context),)),

                  TitleButton(image: Images.aboutUs, title: getTranslated('about_us', context),
                      navigateTo: HtmlViewScreen(title: getTranslated('about_us', context),
                        url: Provider.of<SplashProvider>(context, listen: false).configModel!.aboutUs,)),

                  TitleButton(image: Images.contactUs, title: getTranslated('contact_us', context),
                      navigateTo: WebViewScreen(title: getTranslated('contact_us', context),
                        url: Provider.of<SplashProvider>(context, listen: false).configModel!.staticUrls!.contactUs,
                  )),

                  ListTile(
                    leading: Image.asset(Images.logoImage, width: 25, height: 25, fit: BoxFit.fill,),
                    title: Text(getTranslated('app_info', context)!,
                        style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    trailing: const Text(AppConstants.appVersion),
                  ),

                  isGuestMode ? const SizedBox() : ListTile(
                    leading: Icon(Icons.exit_to_app, color: ColorResources.getPrimary(context), size: 25),
                    title: Text(getTranslated('sign_out', context)!,
                        style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    onTap: () => showAnimatedDialog(context, const SignOutConfirmationDialog(), isFlip: true),
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}

class SquareButton extends StatelessWidget {
  final String image;
  final String? title;
  final Widget navigateTo;
  final int count;
  final bool hasCount;


  const SquareButton({Key? key, required this.image, required this.title, required this.navigateTo, required this.count, required this.hasCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 100;
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: width / 4,
            height: width / 4,
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorResources.getPrimary(context),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(image, color: Theme.of(context).highlightColor),
                hasCount?
                Positioned(top: -4, right: -4,
                  child: Consumer<CartProvider>(builder: (context, cart, child) {
                    return CircleAvatar(radius: 7, backgroundColor: ColorResources.red,
                      child: Text(count.toString(),
                          style: titilliumSemiBold.copyWith(color: Theme.of(context).cardColor,
                            fontSize: Dimensions.fontSizeExtraSmall,
                          )),
                    );
                  }),
                ):const SizedBox(),
              ],
            ),
          ),
        ),
        Flexible(
          child: Text(title!, maxLines: 1,overflow: TextOverflow.clip,
              style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
        ),
      ]),
    );
  }
}

class TitleButton extends StatelessWidget {
  final String image;
  final String? title;
  final Widget navigateTo;
  const TitleButton({Key? key, required this.image, required this.title, required this.navigateTo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(image, width: 25, height: 25, fit: BoxFit.fill),
      title: Text(title!, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      onTap: () => Navigator.push(
        context, MaterialPageRoute(builder: (_) => navigateTo),
      ),
    );
  }
}

