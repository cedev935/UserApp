import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/specification_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';


class ProductSpecification extends StatelessWidget {
  final String productSpecification;
  const ProductSpecification({Key? key, required this.productSpecification}) : super(key: key);

  @override
  Widget build(BuildContext context) {




    if(Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    return Column(
      children: [
        TitleRow(title: getTranslated('specification', context), isDetailsPage: true,),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),


        productSpecification.isNotEmpty ?
        Expanded(child: Html(data: productSpecification,
          //tagsList: Html.tags,
         // customRenders: {
         //   tableMatcher(): tableRender(),
        //  },
          style: {
            "table": Style(
              backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
            ),
            "tr": Style(
              border: const Border(bottom: BorderSide(color: Colors.grey)),
            ),
            "th": Style(
              padding: HtmlPaddings.all(6),
              backgroundColor: Colors.grey,
            ),
            "td": Style(
              padding: HtmlPaddings.all(6),
              alignment: Alignment.topLeft,
            ),

          },),
        ) :
        const Center(child: Text('No specification')),
        const SizedBox(height: Dimensions.paddingSizeDefault),


        InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SpecificationScreen(specification: productSpecification))),
            child: Text(getTranslated('view_full_detail', context)!,
              style: titleRegular.copyWith(color: Theme.of(context).primaryColor),))

      ],
    );
  }
}
