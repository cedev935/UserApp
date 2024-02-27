import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/banner_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/banner_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo? bannerRepo;

  BannerProvider({required this.bannerRepo});

  List<BannerModel>? _mainBannerList;
  List<BannerModel>? _footerBannerList;
  List<BannerModel>? _mainSectionBannerList;
  Product? _product;
  int? _currentIndex;

  List<BannerModel>? get mainBannerList => _mainBannerList;
  List<BannerModel>? get footerBannerList => _footerBannerList;
  List<BannerModel>? get mainSectionBannerList => _mainSectionBannerList;
  Product? get product => _product;
  int? get currentIndex => _currentIndex;

  Future<void> getBannerList(bool reload) async {
    if (_mainBannerList == null || reload) {
      ApiResponse apiResponse = await bannerRepo!.getBannerList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _mainBannerList = [];
        apiResponse.response!.data.forEach((bannerModel) => _mainBannerList!.add(BannerModel.fromJson(bannerModel)));

        _currentIndex = 0;
        notifyListeners();
      } else {
        ApiChecker.checkApi( apiResponse);
      }
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }



  Future<void> getFooterBannerList() async {
    ApiResponse apiResponse = await bannerRepo!.getFooterBannerList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _footerBannerList = [];
      apiResponse.response!.data.forEach((bannerModel) => _footerBannerList!.add(BannerModel.fromJson(bannerModel)));
      notifyListeners();
    } else {
      ApiChecker.checkApi( apiResponse);
    }
  }

  Future<void> getMainSectionBanner() async {
    ApiResponse apiResponse = await bannerRepo!.getMainSectionBannerList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _mainSectionBannerList = [];
      apiResponse.response!.data.forEach((bannerModel) => _mainSectionBannerList!.add(BannerModel.fromJson(bannerModel)));
      notifyListeners();
    } else {
      ApiChecker.checkApi( apiResponse);
    }
  }

}
