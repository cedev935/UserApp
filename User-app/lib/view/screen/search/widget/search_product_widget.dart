import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/search/widget/search_filter_bottom_sheet.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchProductWidget extends StatelessWidget {
  final bool? isViewScrollable;
  final List<Product>? products;
  const SearchProductWidget({Key? key, this.isViewScrollable, this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(
        children: [
          Text.rich(TextSpan(
              children: [
                TextSpan(text: '${getTranslated('searched_item', context)}',
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                    color: ColorResources.getReviewRattingColor(context))),

                TextSpan(text: '(${products!.length} ' '${getTranslated('item_found', context)})'),
              ],
            ),
          ),
          Row(children: [
            Expanded(child: Text('${getTranslated('products', context)}',style: robotoBold,)),

            InkWell(onTap: () => showModalBottomSheet(context: context,
                isScrollControlled: true, backgroundColor: Colors.transparent,
                builder: (c) => const SearchFilterBottomSheet()),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall,
                      horizontal: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),),
                  child: Image.asset(Images.dropdown, scale: 3),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),


          Expanded(child: StaggeredGridView.countBuilder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(0),
            crossAxisCount: 2,
            itemCount: products!.length,
            staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
            itemBuilder: (BuildContext context, int index) {
              return ProductWidget(productModel: products![index]);},
            ),
          ),
        ],
      ),
    );
  }
}
