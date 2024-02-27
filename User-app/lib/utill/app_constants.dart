import 'package:flutter_sixvalley_ecommerce/data/model/response/language_model.dart';

class AppConstants {
  static const String appName = 'Pet Time First';
  static const String appVersion = '14.0';
  static const String baseUrl = 'https://ecom.hypegps.com';
  static const String userId = 'userId';
  static const String name = 'name';
  static const String categoriesUri = '/api/v1/categories';
  static const String SUB_CATEGORY_URI = '/api/v1/categories/childes/';
  static const String CATEGORY_PRODUCT_URI = '/api/v1/categories/products/';
  static const String brandUri = '/api/v1/brands';
  static const String brandProductUri = '/api/v1/brands/products/';
  static const String categoryProductUri = '/api/v1/categories/products/';
  static const String registrationUri = '/api/v1/auth/register';
  static const String loginUri = '/api/v1/auth/login';
  static const String latestProductUri = '/api/v1/products/latest?limit=10&&offset=';
  static const String newArrivalProductUri = '/api/v1/products/latest?limit=10&&offset=';
  static const String topProductUri = '/api/v1/products/top-rated?limit=10&&offset=';
  static const String bestSellingProductUri = '/api/v1/products/best-sellings?limit=1&offset=';
  static const String discountedProductUri = '/api/v1/products/discounted-product?limit=10&&offset=';
  static const String featuredProductUri = '/api/v1/products/featured?limit=10&&offset=';
  static const String homeCategoryProductUri = '/api/v1/products/home-categories';
  static const String productDetailsUri = '/api/v1/products/details/';
  static const String productReviewUri = '/api/v1/products/reviews/';
  static const String searchUri = '/api/v1/products/search?name=';
  static const String configUri = '/api/v1/config';
  static const String addWishListUri = '/api/v1/customer/wish-list/add?product_id=';
  static const String removeWishListUri = '/api/v1/customer/wish-list/remove?product_id=';
  static const String updateProfileUri = '/api/v1/customer/update-profile';
  static const String customerUri = '/api/v1/customer/info';
  static const String addressListUri = '/api/v1/customer/address/list';
  static const String removeAddressUri = '/api/v1/customer/address?address_id=';
  static const String addAddressUri = '/api/v1/customer/address/add';
  static const String getWishListUri = '/api/v1/customer/wish-list';
  static const String supportTicketUri = '/api/v1/customer/support-ticket/create';
  static const String mainBannerUri = '/api/v1/banners?banner_type=main_banner';
  static const String footerBannerUri = '/api/v1/banners?banner_type=footer_banner';
  static const String mainSectionBannerUri = '/api/v1/banners?banner_type=main_section_banner';
  static const String relatedProductUri = '/api/v1/products/related-products/';
  static const String orderUri = '/api/v1/customer/order/list';
  static const String orderDetailsUri = '/api/v1/customer/order/details?order_id=';
  static const String orderPlaceUri = '/api/v1/customer/order/place';
  static const String sellerUri = '/api/v1/seller?seller_id=';
  static const String sellerProductUri = '/api/v1/seller/';
  static const String topSeller = '/api/v1/seller/top';
  static const String trackingUri = '/api/v1/order/track?order_id=';
  static const String forgetPasswordUri = '/api/v1/auth/forgot-password';
  static const String getSupportTicketUri = '/api/v1/customer/support-ticket/get';
  static const String supportTicketConversationUri = '/api/v1/customer/support-ticket/conv/';
  static const String supportTicketReplyUri = '/api/v1/customer/support-ticket/reply/';
  static const String submitReviewUri = '/api/v1/products/reviews/submit';
  static const String flashDealUri = '/api/v1/flash-deals';
  static const String featuredDealUri = '/api/v1/deals/featured';
  static const String flashDealProductUri = '/api/v1/flash-deals/products/';
  static const String counterUri = '/api/v1/products/counter/';
  static const String socialLinkUri = '/api/v1/products/social-share-link/';
  static const String shippingUri = '/api/v1/products/shipping-methods';
  static const String chosenShippingUri = '/api/v1/shipping-method/chosen';
  static const String couponUri = '/api/v1/coupon/apply?code=';
  static const String messageUri = '/api/v1/customer/chat/get-messages/';
  static const String chatInfoUri = '/api/v1/customer/chat/list/';
  static const String searchChat = '/api/v1/customer/chat/search/';
  static const String sendMessageUri = '/api/v1/customer/chat/send-message/';
  static const String tokenUri = '/api/v1/customer/cm-firebase-token';
  static const String notificationUri = '/api/v1/notifications';
  static const String getCartDataUri = '/api/v1/cart';
  static const String addToCartUri = '/api/v1/cart/add';
  static const String updateCartQuantityUri = '/api/v1/cart/update';
  static const String removeFromCartUri = '/api/v1/cart/remove';
  static const String getShippingMethod = '/api/v1/shipping-method/by-seller';
  static const String chooseShippingMethod = '/api/v1/shipping-method/choose-for-order';
  static const String chosenShippingMethod = '/api/v1/shipping-method/chosen';
  static const String getShippingInfo = '/api/v1/shipping-method/detail/1';
  static const String checkPhoneUri = '/api/v1/auth/check-phone';
  static const String resendPhoneOtpUri = '/api/v1/auth/resend-otp-check-phone';
  static const String verifyPhoneUri = '/api/v1/auth/verify-phone';
  static const String socialLoginUri = '/api/v1/auth/social-login';
  static const String checkEmailUri = '/api/v1/auth/check-email';
  static const String resendEmailOtpUri = '/api/v1/auth/resend-otp-check-email';
  static const String verifyEmailUri = '/api/v1/auth/verify-email';
  static const String resetPasswordUri = '/api/v1/auth/reset-password';
  static const String verifyOtpUri = '/api/v1/auth/verify-otp';
  static const String refundRequestUri = '/api/v1/customer/order/refund-store';
  static const String refundRequestPreReqUri = '/api/v1/customer/order/refund';
  static const String refundResultUri = '/api/v1/customer/order/refund-details';
  static const String cancelOrderUri = '/api/v1/order/cancel-order';
  static const String getSelectedShippingTypeUri = '/api/v1/shipping-method/check-shipping-type';
  static const String dealOfTheDay = '/api/v1/dealsoftheday/deal-of-the-day';
  static const String walletTransactionUri = '/api/v1/customer/wallet/list?limit=10&offset=';
  static const String loyaltyPointUri = '/api/v1/customer/loyalty/list?limit=20&offset=';
  static const String loyaltyPointConvert = '/api/v1/customer/loyalty/loyalty-exchange-currency';
  static const String deleteCustomerAccount = '/api/v1/customer/account-delete';
  static const String deliveryRestrictedCountryList = '/api/v1/customer/get-restricted-country-list';
  static const String deliveryRestrictedZipList = '/api/v1/customer/get-restricted-zip-list';
  static const String getOrderFromOrderId = '/api/v1/customer/order/get-order-by-id?order_id=';
  static const String offlinePayment = '/api/v1/customer/order/place-by-offline-payment';
  static const String walletPayment = '/api/v1/customer/order/place-by-wallet';

  //address
  static const String updateAddressUri = '/api/v1/customer/address/update/';
  static const String geocodeUri = '/api/v1/mapapi/geocode-api';
  static const String searchLocationUri = '/api/v1/mapapi/place-api-autocomplete';
  static const String placeDetailsUri = '/api/v1/mapapi/place-api-details';
  static const String distanceMatrixUri = '/api/v1/mapapi/distance-api';
  static const String chatWithDeliveryMan = '/api/v1/mapapi/distance-api';



  // sharePreference
  static const String token = 'token';
  static const String user = 'user';
  static const String userEmail = 'user_email';
  static const String userPassword = 'user_password';
  static const String homeAddress = 'home_address';
  static const String searchAddress = 'search_address';
  static const String officeAddress = 'office_address';
  static const String cartList = 'cart_list';
  static const String config = 'config';
  static const String guestMode = 'guest_mode';
  static const String currency = 'currency';
  static const String langKey = 'lang';
  static const String intro = 'intro';

  // order status
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String processing = 'processing';
  static const String processed = 'processed';
  static const String delivered = 'delivered';
  static const String failed = 'failed';
  static const String returned = 'returned';
  static const String cancelled = 'canceled';
  static const String outForDelivery = 'out_for_delivery';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String theme = 'theme';
  static const String topic = 'sixvalley';
  static const String userAddress = 'user_address';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'العربیة', countryCode: 'SA', languageCode: 'ar'),
    LanguageModel(imageUrl: '', languageName: 'کوردی', countryCode: 'SA', languageCode: 'fa'),
  ];
}
