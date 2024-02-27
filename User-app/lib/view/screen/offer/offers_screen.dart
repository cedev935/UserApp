import 'package:flutter/material.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/banner_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_expanded_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<BannerProvider>(context, listen: false).getFooterBannerList();


    return CustomExpandedAppBar(title: getTranslated('offers', context), child: Consumer<BannerProvider>(
      builder: (context, banner, child) {
        return banner.footerBannerList != null ? banner.footerBannerList!.isNotEmpty ? RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await Provider.of<BannerProvider>(context, listen: false).getFooterBannerList();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            itemCount: Provider.of<BannerProvider>(context).footerBannerList!.length,
            itemBuilder: (context, index) {

              return InkWell(
                onTap: () => _launchUrl(Uri.parse(banner.footerBannerList![index].url!)),
                child: Container(
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholder, fit: BoxFit.fill, height: 150,
                      image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.bannerImageUrl}'
                          '/${banner.footerBannerList![index].photo}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.fill, height: 150),
                    ),
                  ),
                ),
              );
            },
          ),
        ) : const Center(child: Text('No banner available')) : const OfferShimmer();
      },
    ));
  }

  // _launchUrl(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  Future<void> _launchUrl(Uri url) async {
    await canLaunchUrl(url)
        ? await launchUrl(url)
        :  throw 'Could not launch $url';
  }
}

class OfferShimmer extends StatelessWidget {
  const OfferShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          enabled: Provider.of<BannerProvider>(context).footerBannerList == null,
          child: Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorResources.white),
          ),
        );
      },
    );
  }
}

