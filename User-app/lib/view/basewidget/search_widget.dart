import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/search_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:provider/provider.dart';

import '../../localization/language_constrants.dart';

class SearchWidget extends StatelessWidget {
  final String? hintText;
  final Function? onTextChanged;
  final Function onClearPressed;
  final Function? onSubmit;
  final Function()? onTap;
  final bool isSeller;
  final String? sellerId;
  final TextEditingController? searchController;
  const SearchWidget({Key? key, required this.hintText,
    this.onTextChanged, required this.onClearPressed,
    this.onSubmit, this.isSeller= false, this.onTap, this.searchController, this.sellerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: Provider.of<SearchProvider>(context).searchText);
    return Stack(children: [
      ClipRRect(child: SizedBox(
          height: isSeller? 50 : 80 + MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
        ),
      ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(width : MediaQuery.of(context).size.width,
          height: isSeller? 50 : 60,
          alignment: Alignment.center,
          child: Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeSmall),
                        bottomLeft: Radius.circular(Dimensions.paddingSizeSmall))
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(
                    vertical: isSeller ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
                    horizontal: Dimensions.paddingSizeSmall,
                  ),
                  child: TextFormField(
                    controller: isSeller? searchController: controller,
                    onFieldSubmitted: (query) {
                      onSubmit!(query);
                    },
                    onChanged: (query) {
                      // onTextChanged(query);
                    },
                    textInputAction: TextInputAction.search,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: hintText,
                      isDense: true,
                      hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                      border: InputBorder.none,
                      suffixIcon: Provider.of<SearchProvider>(context).searchText.isNotEmpty ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          onClearPressed();
                          controller.clear();
                        },
                      ) : controller.text.isNotEmpty ? IconButton(
                        icon: Icon(Icons.clear, color: ColorResources.getChatIcon(context)),
                        onPressed: () {
                          onClearPressed();
                          controller.clear();
                        },
                      ) : (isSeller && Provider.of<ProductProvider>(context).sellerProductSearch.text.isNotEmpty)? IconButton(
                        icon: Icon(Icons.clear, color: ColorResources.getChatIcon(context)),
                        onPressed: () {
                          Provider.of<ProductProvider>(context, listen: false).sellerProductSearch.clear();
                          if(sellerId!=null){
                            Provider.of<ProductProvider>(context, listen: false).initSellerProductList(sellerId.toString(), 1, context);
                          }


                        },
                      ):null,
                    ),
                  ),
                ),

              ),
            ),

            isSeller?
            InkWell(
              onTap: onTap,
              child: Container(
                width: 55,height: 50,decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.paddingSizeSmall),
                      bottomRight: Radius.circular(Dimensions.paddingSizeSmall))
              ),
                child: Icon(Icons.search, color: Theme.of(context).cardColor, size: Dimensions.iconSizeSmall),
              ),
            ):
            InkWell(
              onTap: (){
                if(controller.text.trim().isNotEmpty) {
                  Provider.of<SearchProvider>(context, listen: false).saveSearchAddress( controller.text.toString());
                  Provider.of<SearchProvider>(context, listen: false).searchProduct( controller.text.toString(), context);
                }else{
                  showCustomSnackBar(getTranslated('enter_somethings', context), context);

                }
              },
              child: Container(
                width: 55,height: 50,decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.paddingSizeSmall),
                      bottomRight: Radius.circular(Dimensions.paddingSizeSmall))
              ),
                child: Icon(Icons.search, color: Theme.of(context).cardColor, size: Dimensions.iconSizeSmall),
              ),
            ),
            const SizedBox(width: 10),
          ]),
        ),
      ),
    ]);
  }
}
