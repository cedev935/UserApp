import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/top_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/topSeller/top_seller_product_screen.dart';
import 'package:provider/provider.dart';
class SellerCard extends StatefulWidget {
  final TopSellerModel? sellerModel;
  const SellerCard({Key? key, this.sellerModel}) : super(key: key);

  @override
  State<SellerCard> createState() => _SellerCardState();
}

class _SellerCardState extends State<SellerCard> {
  bool vacationIsOn = false;
  @override
  Widget build(BuildContext context) {

    if(widget.sellerModel!.vacationEndDate != null){
      DateTime vacationDate = DateTime.parse(widget.sellerModel!.vacationEndDate!);
      DateTime vacationStartDate = DateTime.parse(widget.sellerModel!.vacationStartDate!);
      final today = DateTime.now();
      final difference = vacationDate.difference(today).inDays;
      final startDate = vacationStartDate.difference(today).inDays;

      if(difference >= 0 && widget.sellerModel!.vacationStatus == 1 && startDate <= 0){
        vacationIsOn = true;
      }

      else{
        vacationIsOn = false;
      }
      if (kDebugMode) {
        print('------=>${widget.sellerModel!.name}${widget.sellerModel!.vacationEndDate}/${widget.sellerModel!.vacationStartDate}${vacationIsOn.toString()}/${difference.toString()}/${startDate.toString()}');
      }

    }


    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => TopSellerProductScreen(topSeller: widget.sellerModel)));
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                    color: Theme.of(context).highlightColor,

                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      placeholder: Images.placeholder,
                      image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.shopImageUrl!}/${widget.sellerModel!.image!}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_1x1, fit: BoxFit.cover,),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if(widget.sellerModel!.temporaryClose == 1  || vacationIsOn)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.5),
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
              ),
            ),

          widget.sellerModel!.temporaryClose ==1?
            Center(child: Text(getTranslated('temporary_closed', context)!, textAlign: TextAlign.center,
              style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge),)):
          vacationIsOn?
          Center(child: Text(getTranslated('close_for_now', context)!, textAlign: TextAlign.center,
            style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge),)):
          const SizedBox()
        ],
      ),
    );
  }
}
