import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wallet_transaction_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/wallet/widget/transaction_list_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
class WalletScreen extends StatelessWidget {
  final bool isBacButtonExist;
  const WalletScreen({Key? key, this.isBacButtonExist = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    bool darkMode = Provider.of<ThemeProvider>(context, listen: false).darkTheme;
    bool isFirstTime = true;
    bool isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(isFirstTime) {
      if(!isGuestMode) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
        Provider.of<WalletTransactionProvider>(context, listen: false).getTransactionList(context,1);
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
              title: Text(getTranslated('wallet', context)!,style: TextStyle(color: ColorResources.getTextTitle(context)),),),
            SliverToBoxAdapter(
              child: Column(
                children: [

                  isGuestMode ? const NotLoggedInWidget() :
                  Column(
                    children: [
                      Consumer<WalletTransactionProvider>(
                          builder: (context, profile,_) {
                            return Container(
                              height: MediaQuery.of(context).size.width/2.5,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                boxShadow: [BoxShadow(color: Colors.grey[darkMode ? 900 : 200]!,
                                    spreadRadius: 0.5, blurRadius: 0.3)],
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox (
                                          width: Dimensions.logoHeight,
                                          height: Dimensions.logoHeight,
                                          child: Image.asset(Images.wallet)),
                                      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(getTranslated('wallet_amount', context)!, style: const TextStyle(fontWeight: FontWeight.w400,
                                              color: Colors.white,fontSize: Dimensions.fontSizeLarge)),

                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          Text(PriceConverter.convertPrice(context, (profile.walletBalance != null && profile.walletBalance!.totalWalletBalance != null) ?
                                          profile.walletBalance!.totalWalletBalance ?? 0 : 0),
                                              style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white,
                                                  fontSize: Dimensions.fontSizeOverLarge)),
                                        ],
                                      ),
                                      const SizedBox(width: Dimensions.logoHeight,),
                                    ],
                                  ),


                                ],
                              ),
                            );
                          }
                      ),

                      TransactionListView(scrollController: scrollController,)
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

class OrderShimmer extends StatelessWidget {
  const OrderShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: Dimensions.marginSizeDefault),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          color: Theme.of(context).highlightColor,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10, width: 150, color: ColorResources.white),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: Container(height: 45, color: Colors.white)),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(height: 20, color: ColorResources.white),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(height: 10, width: 70, color: Colors.white),
                              const SizedBox(width: 10),
                              Container(height: 10, width: 20, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 70 || oldDelegate.minExtent != 70 || child != oldDelegate.child;
  }
}


