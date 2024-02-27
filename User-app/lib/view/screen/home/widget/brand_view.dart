import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/brand_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BrandView extends StatelessWidget {
  final bool isHomePage;
  const BrandView({Key? key, required this.isHomePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandProvider>(
      builder: (context, brandProvider, child) {

        return brandProvider.brandList.isNotEmpty ?
        isHomePage?
        ConstrainedBox(
          constraints: brandProvider.brandList.isNotEmpty ? const BoxConstraints(maxHeight: 130):const BoxConstraints(maxHeight: 0),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: brandProvider.brandList.length,
              itemBuilder: (ctx,index){

                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
                      isBrand: true,
                      id: brandProvider.brandList[index].id.toString(),
                      name: brandProvider.brandList[index].name,
                      image: brandProvider.brandList[index].image,
                    )));
                   },
                  child: Padding(
                    padding:  const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width/5.9),
                          height: (MediaQuery.of(context).size.width/5.9),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular((MediaQuery.of(context).size.width/5))),
                              color: Theme.of(context).highlightColor,
                               ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular((MediaQuery.of(context).size.width/5))),
                            child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholder: Images.placeholder,
                              image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.brandImageUrl!}/${brandProvider.brandList[index].image!}',
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,  fit: BoxFit.cover,),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: (MediaQuery.of(context).size.width/4) * 0.3,
                          width: MediaQuery.of(context).size.width/4.2,
                          child: Center(child: Text(
                            brandProvider.brandList[index].name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                          )),
                        ),
                      ],
                    ),
                  ),
                );

              }),
        ):
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: (1/1.3),
            mainAxisSpacing: 10,
            crossAxisSpacing: 5,
          ),
          itemCount: brandProvider.brandList.isNotEmpty
              ? isHomePage
              ? brandProvider.brandList.length > 8
              ? 8
              : brandProvider.brandList.length
              : brandProvider.brandList.length
              : 8,
          shrinkWrap: true,
          physics: isHomePage ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {

            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
                  isBrand: true,
                  id: brandProvider.brandList[index].id.toString(),
                  name: brandProvider.brandList[index].name,
                  image: brandProvider.brandList[index].image,
                )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraExtraSmall),
                      decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 5, spreadRadius: 1)]
                      ),
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: Images.placeholder,
                          image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.brandImageUrl!}/${brandProvider.brandList[index].image!}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,  fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.width/4) * 0.3,
                    child: Center(child: Text(
                      brandProvider.brandList[index].name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                    )),
                  ),
                ],
              ),
            );

          },
        ) : BrandShimmer(isHomePage: isHomePage);

      },
    );
  }
}

class BrandShimmer extends StatelessWidget {
  final bool isHomePage;
  const BrandShimmer({Key? key, required this.isHomePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1/1.3),
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
      ),
      itemCount: isHomePage ? 8 : 30,
      shrinkWrap: true,
      physics: isHomePage ? const NeverScrollableScrollPhysics() : null,
      itemBuilder: (BuildContext context, int index) {

        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          enabled: Provider.of<BrandProvider>(context).brandList.isEmpty,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: Container(decoration: const BoxDecoration(color: ColorResources.white, shape: BoxShape.circle))),
            Container(height: 10, color: ColorResources.white, margin: const EdgeInsets.only(left: 25, right: 25)),
          ]),
        );

      },
    );
  }
}
