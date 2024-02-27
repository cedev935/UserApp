import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';

import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/wishlist/widget/wishlist_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  late bool isGuestMode;

  @override
  void initState() {
    super.initState();
    isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if(!isGuestMode){
      Provider.of<WishListProvider>(context, listen: false).initWishList(
        context, Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode,
      );
    }

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          CustomAppBar(title: getTranslated('wishList', context)),

          Expanded(
            child: isGuestMode ? const NotLoggedInWidget() :  Consumer<WishListProvider>(
              builder: (context, wishListProvider, child) {
                return wishListProvider.wishList != null ? wishListProvider.wishList!.isNotEmpty ? RefreshIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  onRefresh: () async {
                    await  Provider.of<WishListProvider>(context, listen: false).initWishList(
                      context, Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode,
                    );
                  },

                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: wishListProvider.wishList!.length,
                    itemBuilder: (context, index) => WishListWidget(
                      product: wishListProvider.wishList![index],
                      index: index,
                    ),
                  ),
                ) : const NoInternetOrDataScreen(isNoInternet: false): const WishListShimmer();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WishListShimmer extends StatelessWidget {
  const WishListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          enabled: Provider.of<WishListProvider>(context).wishList==null,
          child: ListTile(
            leading: Container(height: 50, width: 50, color: ColorResources.white),
            title: Container(height: 20, color: ColorResources.white),
            subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(height: 10, width: 70, color: ColorResources.white),
              Container(height: 10, width: 20, color: ColorResources.white),
              Container(height: 10, width: 50, color: ColorResources.white),
            ]),
            trailing: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(height: 15, width: 15, decoration: const BoxDecoration(shape: BoxShape.circle, color: ColorResources.white)),
              const SizedBox(height: 10),
              Container(height: 10, width: 50, color: ColorResources.white),
            ]),
          ),
        );
      },
    );
  }
}
