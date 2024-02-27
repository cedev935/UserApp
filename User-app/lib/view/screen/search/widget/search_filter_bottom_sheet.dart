import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/search_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:provider/provider.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  const SearchFilterBottomSheet({Key? key}) : super(key: key);

  @override
  SearchFilterBottomSheetState createState() => SearchFilterBottomSheetState();
}

class SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  final TextEditingController _firstPriceController = TextEditingController();
  final FocusNode _firstFocus = FocusNode();
  final TextEditingController _lastPriceController = TextEditingController();
  final FocusNode _lastFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Consumer<SearchProvider>(
          builder: (context, search, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(child: Row(
                children: [
                  Text(getTranslated('PRICE_RANGE', context)!,
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(width: Dimensions.paddingSizeLarge,),


                  Expanded(child: TextField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(_lastFocus),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    focusNode: _firstFocus,
                    controller: _firstPriceController,
                    style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                    decoration: InputDecoration(
                      hintText: getTranslated('min', context),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor)),),
                      ),
                    ),

                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Text(getTranslated('to', context)!),),


                  Expanded(child: Center(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      controller: _lastPriceController,
                      maxLines: 1,
                      focusNode: _lastFocus,
                      textInputAction: TextInputAction.done,
                      style: titilliumBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                          ),
                          decoration: InputDecoration(
                            hintText: getTranslated('max', context),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).primaryColor)),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              const Divider(),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(getTranslated('SORT_BY', context)!,
                style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),

              MyCheckBox(title: getTranslated('latest_products', context), index: 0),
              MyCheckBox(title: getTranslated('alphabetically_az', context), index: 1),
              MyCheckBox(title: getTranslated('alphabetically_za', context), index: 2),
              MyCheckBox(title: getTranslated('low_to_high_price', context), index: 3),
              MyCheckBox(title: getTranslated('high_to_low_price', context), index: 4),



              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomButton(
                  buttonText: getTranslated('APPLY', context),
                  onTap: () {
                    double minPrice = 0.0;
                    double maxPrice = 0.0;
                    if(_firstPriceController.text.isNotEmpty && _lastPriceController.text.isNotEmpty) {
                      minPrice = double.parse(_firstPriceController.text);
                      maxPrice = double.parse(_lastPriceController.text);
                    }
                    Provider.of<SearchProvider>(context, listen: false).sortSearchList(minPrice, maxPrice);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),

      ]),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final String? title;
  final int index;
  const MyCheckBox({Key? key, required this.title, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title!, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
      checkColor: Theme.of(context).primaryColor,
      activeColor: Colors.transparent,
      value: Provider.of<SearchProvider>(context).filterIndex == index,
      onChanged: (isChecked) {
        if(isChecked!) {
          Provider.of<SearchProvider>(context, listen: false).setFilterIndex(index);
        }
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

