import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wallet_transaction_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/loyaltyPoint/widget/loyalty_point_converter_bottom_sheet.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/loyaltyPoint/widget/loyalty_point_list.dart';
import 'package:provider/provider.dart';
class LoyaltyPointScreen extends StatefulWidget {

  const LoyaltyPointScreen({Key? key}) : super(key: key);

  @override
  State<LoyaltyPointScreen> createState() => _LoyaltyPointScreenState();
}

class _LoyaltyPointScreenState extends State<LoyaltyPointScreen> {
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    bool isFirstTime = true;
    bool isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(isFirstTime) {
      if(!isGuestMode) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
        Provider.of<WalletTransactionProvider>(context, listen: false).getLoyaltyPointList(context,1);

      }

      isFirstTime = false;
    }
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: RefreshIndicator(
        color: Theme.of(context).cardColor,
        backgroundColor: Theme.of(context).primaryColor,
        onRefresh: () async {
          Provider.of<WalletTransactionProvider>(context, listen: false).getTransactionList(context,1,reload: true);
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(floating: true,
              pinned: true,
              iconTheme:  IconThemeData(color: ColorResources.getTextTitle(context)),
              backgroundColor: Theme.of(context).cardColor,
              title: Text(getTranslated('loyalty_point', context)!,style: TextStyle(color: ColorResources.getTextTitle(context)),),),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  isGuestMode ? const NotLoggedInWidget() :
                  Column(
                    children: [
                      Consumer<ProfileProvider>(
                          builder: (context, profile,_) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(Dimensions.homePagePadding),
                                  child: Container(
                                    decoration:BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                        color: Theme.of(context).hintColor.withOpacity(.15)
                                    ),
                                    height: MediaQuery.of(context).size.width/2,
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),

                                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(),
                                            SizedBox (
                                                width: Dimensions.logoHeight,
                                                height: Dimensions.logoHeight,
                                                child: Image.asset(Images.loyaltyTrophy)),
                                            Column(mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [

                                                Text('${(profile.userInfoModel != null && profile.userInfoModel!.loyaltyPoint != null) ?
                                                profile.userInfoModel!.loyaltyPoint ?? 0 : 0}',
                                                    style: robotoBold.copyWith(color: ColorResources.getTextTitle(context),
                                                        fontSize: Dimensions.fontSizeOverLarge)),
                                                const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),

                                                Text('${getTranslated('loyalty_point', context)} !',
                                                    style: robotoRegular.copyWith(color: ColorResources.getTextTitle(context))),

                                              ],
                                            ),
                                            const SizedBox(width: Dimensions.logoHeight,),
                                          ],
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(top:Dimensions.paddingSizeThirtyFive,right:Dimensions.paddingSizeLarge,
                                    child: InkWell(
                                      onTap: (){
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (con) => LoyaltyPointConverterBottomSheet(myPoint:  profile.userInfoModel!.loyaltyPoint ?? 0)
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text('${getTranslated('convert_to_currency', context)}'),
                                          const Icon(Icons.keyboard_arrow_down)
                                        ],
                                      ),
                                    ))
                              ],
                            );
                          }
                      ),


                      LoyaltyPointListView(scrollController: scrollController),

                    ],
                  ),

                ],
              ),
            )
          ],
        ),
      )


    );
  }
}
