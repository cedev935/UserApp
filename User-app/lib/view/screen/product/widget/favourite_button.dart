import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:provider/provider.dart';

class FavouriteButton extends StatelessWidget {
  final Color backgroundColor;
  final Color favColor;
  final bool isSelected;
  final int? productId;
  const FavouriteButton({Key? key, this.backgroundColor = Colors.black, this.favColor = Colors.white, this.isSelected = false, this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    feedbackMessage(String message) {
      if (message != '') {
        showCustomSnackBar(message, context, isError: false);
      }
    }

    return GestureDetector(
      onTap: () {
        if (isGuestMode) {
          showAnimatedDialog(context, const GuestDialog(), isFlip: true);
        } else {
          Provider.of<WishListProvider>(context, listen: false).isWish ?
          Provider.of<WishListProvider>(context, listen: false).removeWishList(productId, feedbackMessage: feedbackMessage) :
          Provider.of<WishListProvider>(context, listen: false).addWishList(productId, feedbackMessage: feedbackMessage);
        }
      },
      child: Consumer<WishListProvider>(
        builder: (context, wishListProvider, child) => Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          color: Theme.of(context).cardColor,
          child: Padding(padding: const EdgeInsets.all(8),
            child: Image.asset(
              wishListProvider.isWish ? Images.wishImage : Images.wishlist,
              color: favColor, height: 16, width: 16,
            ),
          ),
        ),
      ),
    );
  }
}
