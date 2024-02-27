import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/review_body.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ReviewBottomSheet extends StatefulWidget {
  final String productID;
  final Function? callback;
  const ReviewBottomSheet({Key? key, required this.productID, required this.callback}) : super(key: key);

  @override
  ReviewBottomSheetState createState() => ReviewBottomSheetState();
}

class ReviewBottomSheetState extends State<ReviewBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final List<File> _files = [File(''), File(''), File('')];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [

        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.cancel, color: ColorResources.getRed(context)),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        Text(getTranslated('review_your_experience', context)!, style: titilliumRegular),
        const Divider(height: 5),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Row(children: [
            Expanded(child: Text(getTranslated('your_rating', context)!,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall))),
            Container(
              height: 30,
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorResources.getLowGreen(context),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Icon(Icons.star, size: 20,
                      color: Provider.of<ProductDetailsProvider>(context).rating < (index+1) ?
                      Theme.of(context).highlightColor : ColorResources.getYellow(context),
                    ),
                    onTap: () => Provider.of<ProductDetailsProvider>(context, listen: false).setRating(index+1),
                  );
                },
              ),
            ),
          ]),
        ),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CustomTextField(
            maxLine: 4,
            hintText: getTranslated('write_your_experience_here', context),
            controller: _controller,
            textInputAction: TextInputAction.done,
            fillColor: ColorResources.getLowGreen(context),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Row(children: [
            Expanded(child: Text(getTranslated('upload_images', context)!,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall))),
            SizedBox(
              height: 40,
              child: ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                reverse: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                    child: InkWell(
                      onTap: () async {
                        if(index == 0 || _files[index-1].path.isNotEmpty) {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery,
                              maxWidth: 500, maxHeight: 500, imageQuality: 50);
                          if(pickedFile != null) {
                            _files[index] = File(pickedFile.path);
                            setState(() {});
                          }
                        }
                      },
                      child: _files[index].path.isEmpty ? Container(
                        height: 40,
                        width: 50,
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Icon(Icons.cloud_upload_outlined, color: Theme.of(context).primaryColor),
                            CustomPaint(
                              size: const Size(100, 40),
                              foregroundPainter: MyPainter(completeColor: ColorResources.getColombiaBlue(context), width: 2),
                            ),
                          ],
                        ),
                      ) : ClipRRect(borderRadius: BorderRadius.circular(5),
                          child: Image.file(_files[index], height: 50, width: 50, fit: BoxFit.cover)),
                    ),
                  );
                },
              ),
            ),
          ]),
        ),

        Provider.of<ProductDetailsProvider>(context).errorText != null ?
        Text(Provider.of<ProductDetailsProvider>(context).errorText!,
            style: titilliumRegular.copyWith(color: ColorResources.red)) : const SizedBox.shrink(),

        Builder(
          builder: (context) => !Provider.of<ProductDetailsProvider>(context).isLoading ? Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: CustomButton(
              buttonText: getTranslated('submit', context),
              onTap: () {
                if(Provider.of<ProductDetailsProvider>(context, listen: false).rating == 0) {
                  Provider.of<ProductDetailsProvider>(context, listen: false).setErrorText('Add a rating');
                }else if(_controller.text.isEmpty) {
                  Provider.of<ProductDetailsProvider>(context, listen: false).setErrorText('Write something');
                }else {
                  Provider.of<ProductDetailsProvider>(context, listen: false).setErrorText('');
                  ReviewBody reviewBody = ReviewBody(
                    productId: widget.productID,
                    rating: Provider.of<ProductDetailsProvider>(context, listen: false).rating.toString(),
                    comment: _controller.text.isEmpty ? '' : _controller.text,
                  );
                  Provider.of<ProductDetailsProvider>(context, listen: false).submitReview(reviewBody,
                      _files, Provider.of<AuthProvider>(context, listen: false).getUserToken()).then((value) {
                    if(value.isSuccess) {
                      Navigator.pop(context);
                      widget.callback!();
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      _controller.clear();
                    }else {
                      Provider.of<ProductDetailsProvider>(context, listen: false).setErrorText(value.message);
                    }
                  });
                }
              },
            ),
          ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
        ),

      ]),
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor =  Colors.transparent;
  Color? completeColor;
  double? width;
  MyPainter({this.completeColor, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = Paint()
      ..color = completeColor!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width!;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    var percent = (size.width *0.001) / 2;
    double arcAngle = 2 * pi * percent;

    for (var i = 0; i < 8; i++) {
      var init = (-pi / 2)*(i/2);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), init, arcAngle, false, complete);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
