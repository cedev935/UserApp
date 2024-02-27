import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/home_category_product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';

class HomeCategoryProductView extends StatelessWidget {
  final bool isHomePage;
  const HomeCategoryProductView({Key? key, required this.isHomePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeCategoryProductProvider>(
      builder: (context, homeCategoryProductProvider, child) {
        return homeCategoryProductProvider.homeCategoryProductList.isNotEmpty
            ? ListView.builder(
                itemCount: homeCategoryProductProvider.homeCategoryProductList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isHomePage
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(5, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall),
                              child: TitleRow(title: homeCategoryProductProvider.homeCategoryProductList[index].name,
                                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
                                  isBrand: false,
                                  id: homeCategoryProductProvider.homeCategoryProductList[index].id.toString(),
                                  name: homeCategoryProductProvider.homeCategoryProductList[index].name,
                                )
                                ));},
                              ),
                            )
                          : const SizedBox(),
                      ConstrainedBox(
                        constraints: homeCategoryProductProvider.homeCategoryProductList[index].products!.isNotEmpty ?
                        const BoxConstraints(maxHeight: Dimensions.cardHeight):const BoxConstraints(maxHeight: 0),
                        child: ListView.builder(
                            itemCount: homeCategoryProductProvider.homeCategoryProductList[index].products!.length,
                            padding: const EdgeInsets.all(0),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int i) {
                              return InkWell(
                                onTap: () {Navigator.push(context, PageRouteBuilder(transitionDuration: const Duration(milliseconds: 1000),
                                        pageBuilder: (context, anim1, anim2) => ProductDetails(productId: homeCategoryProductProvider.productList![i].id,slug: homeCategoryProductProvider.productList![i].slug,),
                                      ));
                                },
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width/2)-20,
                                  child: ProductWidget(productModel: homeCategoryProductProvider.homeCategoryProductList[index].products![i])

                                ),
                              );
                            }),
                      )
                    ],
                  );
                })
            : const SizedBox();
      },
    );
  }
}
