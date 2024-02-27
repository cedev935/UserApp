class ConfigModel {
  int? _systemDefaultCurrency;
  bool? _digitalPayment;
  bool? _cod;
  BaseUrls? _baseUrls;
  StaticUrls? _staticUrls;
  String? _aboutUs;
  String? _privacyPolicy;
  List<Faq>? _faq;
  String? _termsConditions;
  RefundPolicy? _refundPolicy;
  RefundPolicy? _returnPolicy;
  RefundPolicy? _cancellationPolicy;
  List<CurrencyList>? _currencyList;
  String? _currencySymbolPosition;
  bool? _maintenanceMode;
  List<String>? _language;
  List<Colors>? _colors;
  List<String>? _unit;
  String? _shippingMethod;
  String? _currencyModel;
  bool? _emailVerification;
  bool? _phoneVerification;
  String? _countryCode;
  List<SocialLogin>? _socialLogin;
  String? _forgetPasswordVerification;
  Announcement? _announcement;
  String? _version;
  String? _businessMode;
  int? _decimalPointSetting;
  String? _inHouseSelectedShippingType;
  int? _billingAddress;
  int? _walletStatus;
  int? _loyaltyPointStatus;
  int? _loyaltyPointExchangeRate;
  int? _loyaltyPointMinimumPoint;
  String? _brandSetting;
  String? _digitalProductSetting;
  bool? _cashOnDelivery;
  int? _deliveryCountryRestriction;
  int? _deliveryZipCodeAreaRestriction;
  PaymentMethods? _paymentMethods;






  ConfigModel(
      {int? systemDefaultCurrency,
        bool? digitalPayment,
        bool? cod,
        BaseUrls? baseUrls,
        StaticUrls? staticUrls,
        String? aboutUs,
        String? privacyPolicy,
        List<Faq>? faq,
        String? termsConditions,
        RefundPolicy? refundPolicy,
        RefundPolicy? returnPolicy,
        RefundPolicy? cancellationPolicy,
        List<CurrencyList>? currencyList,
        String? currencySymbolPosition,
        bool? maintenanceMode,
        List<String>? language,
        List<Colors>? colors,
        List<String>? unit,
        String? shippingMethod,
        String? currencyModel,
        bool? emailVerification,
        bool? phoneVerification,
        String? countryCode,
        List<SocialLogin>? socialLogin,
        String? forgetPasswordVerification,
        Announcement? announcement,
        String? version,
        String? businessMode,
        int? decimalPointSetting,
        String? inHouseSelectedShippingType,
        int? billingAddress,
        int? walletStatus,
        int? loyaltyPointStatus,
        int? loyaltyPointExchangeRate,
        int? loyaltyPointMinimumPoint,
        String? brandSetting,
        String? digitalProductSetting,
        bool? cashOnDelivery,
        int? deliveryCountryRestriction,
        int? deliveryZipCodeAreaRestriction,
        PaymentMethods? paymentMethods

      }) {
    _systemDefaultCurrency = systemDefaultCurrency;
    _digitalPayment = digitalPayment;
    _cod = cod;
    _baseUrls = baseUrls;
    _staticUrls = staticUrls;
    _aboutUs = aboutUs;
    _privacyPolicy = privacyPolicy;
    _faq = faq;
    _termsConditions = termsConditions;
    if (refundPolicy != null) {
      _refundPolicy = refundPolicy;
    }
    if (returnPolicy != null) {
      _returnPolicy = returnPolicy;
    }
    if (cancellationPolicy != null) {
      _cancellationPolicy = cancellationPolicy;
    }
    _currencyList = currencyList;
    _currencySymbolPosition = currencySymbolPosition;
    _maintenanceMode = maintenanceMode;
    _language = language;
    _colors = colors;
    _unit = unit;
    _shippingMethod = shippingMethod;
    _currencyModel = currencyModel;
    _emailVerification = emailVerification;
    _phoneVerification = phoneVerification;
    _countryCode = countryCode;
    _socialLogin = socialLogin;
    _forgetPasswordVerification = forgetPasswordVerification;
    _announcement = announcement;
    _version = version;
    _businessMode = businessMode;
    _decimalPointSetting = decimalPointSetting;
    _inHouseSelectedShippingType = inHouseSelectedShippingType;
    _billingAddress = billingAddress;
    if (walletStatus != null) {
      _walletStatus = walletStatus;
    }
    if (loyaltyPointStatus != null) {
      _loyaltyPointStatus = loyaltyPointStatus;
    }
    if (loyaltyPointExchangeRate != null) {
      _loyaltyPointExchangeRate = loyaltyPointExchangeRate;
    }
    if (loyaltyPointMinimumPoint != null) {
      _loyaltyPointMinimumPoint = loyaltyPointMinimumPoint;
    }
    if (brandSetting != null) {
      _brandSetting = brandSetting;
    }
    if (digitalProductSetting != null) {
      _digitalProductSetting = digitalProductSetting;
    }

    if (cashOnDelivery != null) {
      _cashOnDelivery = cashOnDelivery;
    }
    if (deliveryCountryRestriction != null) {
      _deliveryCountryRestriction = deliveryCountryRestriction;
    }
    if (deliveryZipCodeAreaRestriction != null) {
      _deliveryZipCodeAreaRestriction = deliveryZipCodeAreaRestriction;
    }
    if (paymentMethods != null) {
      _paymentMethods = paymentMethods;
    }

  }

  int? get systemDefaultCurrency => _systemDefaultCurrency;
  bool? get digitalPayment => _digitalPayment;
  bool? get cod => _cod;
  BaseUrls? get baseUrls => _baseUrls;
  StaticUrls? get staticUrls => _staticUrls;
  String? get aboutUs => _aboutUs;
  String? get privacyPolicy => _privacyPolicy;
  List<Faq>? get faq => _faq;
  String? get termsConditions => _termsConditions;
  RefundPolicy? get refundPolicy => _refundPolicy;
  RefundPolicy? get returnPolicy => _returnPolicy;
  RefundPolicy? get cancellationPolicy => _cancellationPolicy;
  List<CurrencyList>? get currencyList => _currencyList;
  String? get currencySymbolPosition => _currencySymbolPosition;
  bool? get maintenanceMode => _maintenanceMode;
  List<String>? get language => _language;
  List<Colors>? get colors => _colors;
  List<String>? get unit => _unit;
  String? get shippingMethod => _shippingMethod;
  String? get currencyModel => _currencyModel;
  bool? get emailVerification => _emailVerification;
  bool? get phoneVerification => _phoneVerification;
  String? get countryCode =>_countryCode;
  List<SocialLogin>? get socialLogin => _socialLogin;
  String? get forgetPasswordVerification => _forgetPasswordVerification;
  Announcement? get announcement => _announcement;
  String? get version => _version;
  String? get businessMode => _businessMode;
  int? get decimalPointSetting => _decimalPointSetting;
  String? get inHouseSelectedShippingType => _inHouseSelectedShippingType;
  int? get billingAddress => _billingAddress;
  int? get walletStatus => _walletStatus;
  int? get loyaltyPointStatus => _loyaltyPointStatus;
  int? get loyaltyPointExchangeRate => _loyaltyPointExchangeRate;
  int? get loyaltyPointMinimumPoint => _loyaltyPointMinimumPoint;
  String? get brandSetting => _brandSetting;
  String? get digitalProductSetting => _digitalProductSetting;
  bool? get cashOnDelivery => _cashOnDelivery;
  int? get deliveryCountryRestriction => _deliveryCountryRestriction;
  int? get deliveryZipCodeAreaRestriction => _deliveryZipCodeAreaRestriction;
  PaymentMethods? get paymentMethods => _paymentMethods;



  ConfigModel.fromJson(Map<String, dynamic> json) {
    _systemDefaultCurrency = json['system_default_currency'];
    _digitalPayment = json['digital_payment'];
    _cod = json['cash_on_delivery'];
    _baseUrls = json['base_urls'] != null
        ? BaseUrls.fromJson(json['base_urls'])
        : null;
    _staticUrls = json['static_urls'] != null
        ? StaticUrls.fromJson(json['static_urls'])
        : null;
    _aboutUs = json['about_us'];
    _privacyPolicy = json['privacy_policy'];
    if (json['faq'] != null) {
      _faq = [];
      json['faq'].forEach((v) {_faq!.add(Faq.fromJson(v));
      });
    }
    _termsConditions = json['terms_&_conditions'];
    _refundPolicy = json['refund_policy'] != null ? RefundPolicy.fromJson(json['refund_policy']) : null;
    _returnPolicy = json['return_policy'] != null ? RefundPolicy.fromJson(json['return_policy']) : null;
    _cancellationPolicy = json['cancellation_policy'] != null ? RefundPolicy.fromJson(json['cancellation_policy']) : null;
    if (json['currency_list'] != null) {
      _currencyList = [];
      json['currency_list'].forEach((v) {_currencyList!.add(CurrencyList.fromJson(v));
      });
    }
    _currencySymbolPosition = json['currency_symbol_position'];
    _maintenanceMode = json['maintenance_mode'];
    _language = json['language'].cast<String>();
    if (json['colors'] != null) {
      _colors = [];
      json['colors'].forEach((v) {_colors!.add(Colors.fromJson(v));
      });
    }

    _unit = json['unit'].cast<String>();
    _shippingMethod = json['shipping_method'];
    _currencyModel = json['currency_model'];
    _emailVerification = json['email_verification'];
    _phoneVerification = json['phone_verification'];
    _countryCode = json['country_code'];
    if (json['social_login'] != null) {
      _socialLogin = [];
      json['social_login'].forEach((v) { _socialLogin!.add(SocialLogin.fromJson(v)); });
    }
    _forgetPasswordVerification = json['forgot_password_verification'];
    _announcement = json['announcement'] != null
        ? Announcement.fromJson(json['announcement'])
        : null;

    if(json['software_version'] != null){
      _version = json['software_version'];
    }
    if(json['business_mode'] != null){
      _businessMode = json['business_mode'];
    }
    if(json['decimal_point_settings'] != null && json['decimal_point_settings'] != "" ){
      _decimalPointSetting = int.parse(json['decimal_point_settings'].toString());
    }
    if(json['inhouse_selected_shipping_type'] != null){
      _inHouseSelectedShippingType = json['inhouse_selected_shipping_type'].toString();
    }else{
      _inHouseSelectedShippingType = 'order_wise';
    }
    if(json['billing_input_by_customer']!=null){
      try{
        _billingAddress = json['billing_input_by_customer'];
      }catch(e){
        _billingAddress = int.parse(json['billing_input_by_customer'].toString());
      }

    }

    _walletStatus = json['wallet_status'];
    _loyaltyPointStatus = json['loyalty_point_status'];


    if(json['loyalty_point_exchange_rate'] != null){
      try{
        _loyaltyPointExchangeRate = json['loyalty_point_exchange_rate'];
      }catch(e){
        _loyaltyPointExchangeRate = int.parse(json['loyalty_point_exchange_rate'].toString());

      }
    }

    if(json['loyalty_point_minimum_point'] != null){
      try{
        _loyaltyPointMinimumPoint = json['loyalty_point_minimum_point'];
      }catch(e){
        _loyaltyPointMinimumPoint = int.parse(json['loyalty_point_minimum_point'].toString());
      }
    }

    _brandSetting = json['brand_setting'].toString();
    _digitalProductSetting = json['digital_product_setting'];
    _cashOnDelivery = json['cash_on_delivery'];



    if(json['delivery_country_restriction'] != null){
      _deliveryCountryRestriction = int.parse(json['delivery_country_restriction'].toString());
    }else{
      _deliveryCountryRestriction = 0;
    }
    if(json['delivery_zip_code_area_restriction'] != null){
      _deliveryZipCodeAreaRestriction = int.parse(json['delivery_zip_code_area_restriction'].toString());
    }else{
      _deliveryZipCodeAreaRestriction = 0;
    }

    _paymentMethods = json['payment_methods'] != null
        ? PaymentMethods.fromJson(json['payment_methods'])
        : null;




  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['system_default_currency'] = _systemDefaultCurrency;
    data['digital_payment'] = _digitalPayment;
    data['cash_on_delivery'] = _cod;
    if (_baseUrls != null) {
      data['base_urls'] = _baseUrls!.toJson();
    }
    if (_staticUrls != null) {
      data['static_urls'] = _staticUrls!.toJson();
    }
    data['about_us'] = _aboutUs;
    data['privacy_policy'] = _privacyPolicy;
    if (_faq != null) {
      data['faq'] = _faq!.map((v) => v.toJson()).toList();
    }
    data['terms_&_conditions'] = _termsConditions;
    if (_refundPolicy != null) {
      data['refund_policy'] = _refundPolicy!.toJson();
    }
    if (_returnPolicy != null) {
      data['return_policy'] = _returnPolicy!.toJson();
    }
    if (_cancellationPolicy != null) {
      data['cancellation_policy'] = _cancellationPolicy!.toJson();
    }
    if (_currencyList != null) {
      data['currency_list'] =
          _currencyList!.map((v) => v.toJson()).toList();
    }
    data['currency_symbol_position'] = _currencySymbolPosition;
    data['maintenance_mode'] = _maintenanceMode;
    data['language'] = _language;
    if (_colors != null) {
      data['colors'] = _colors!.map((v) => v.toJson()).toList();
    }
    data['unit'] = _unit;
    data['shipping_method'] = _shippingMethod;
    data['currency_model'] = _currencyModel;
    data['email_verification'] = _emailVerification;
    data['phone_verification'] = _phoneVerification;
    data['country_code'] = _countryCode;
    if (_socialLogin != null) {
      data['social_login'] = _socialLogin!.map((v) => v.toJson()).toList();
    }
    data['forgot_password_verification'] = _forgetPasswordVerification;
    if (_announcement != null) {
      data['announcement'] = _announcement!.toJson();
    }
    if (_version != null) {
      data['software_version'] = _version;
    }
    if (_businessMode != null) {
      data['business_mode'] = _businessMode;
    }
    if (_decimalPointSetting != null) {
      data['decimal_point_settings'] = _decimalPointSetting;
    }
    if (_inHouseSelectedShippingType != null) {
      data['inhouse_selected_shipping_type'] = _inHouseSelectedShippingType;
    }
    data['wallet_status'] = _walletStatus;
    data['loyalty_point_status'] = _loyaltyPointStatus;
    data['loyalty_point_exchange_rate'] = _loyaltyPointExchangeRate;
    data['loyalty_point_minimum_point'] = _loyaltyPointMinimumPoint;
    data['brand_setting'] = _brandSetting;
    data['digital_product_setting'] = _digitalProductSetting;
    data['cash_on_delivery'] = _cashOnDelivery;
    data['delivery_country_restriction'] = _deliveryCountryRestriction;
    data['delivery_zip_code_area_restriction'] = _deliveryZipCodeAreaRestriction;
    if (_paymentMethods != null) {
      data['payment_methods'] = _paymentMethods!.toJson();
    }
    return data;
  }
}

class BaseUrls {
  String? _productImageUrl;
  String? _productThumbnailUrl;
  String? _brandImageUrl;
  String? _customerImageUrl;
  String? _bannerImageUrl;
  String? _categoryImageUrl;
  String? _reviewImageUrl;
  String? _sellerImageUrl;
  String? _shopImageUrl;
  String? _notificationImageUrl;
  String? _digitalProductUrl;
  String? _deliveryManImage;

  BaseUrls(
      {String? productImageUrl,
        String? productThumbnailUrl,
        String? brandImageUrl,
        String? customerImageUrl,
        String? bannerImageUrl,
        String? categoryImageUrl,
        String? reviewImageUrl,
        String? sellerImageUrl,
        String? shopImageUrl,
        String? notificationImageUrl,
        String? digitalProductUrl,
        String? deliveryManImage,
      }) {
    _productImageUrl = productImageUrl;
    _productThumbnailUrl = productThumbnailUrl;
    _brandImageUrl = brandImageUrl;
    _customerImageUrl = customerImageUrl;
    _bannerImageUrl = bannerImageUrl;
    _categoryImageUrl = categoryImageUrl;
    _reviewImageUrl = reviewImageUrl;
    _sellerImageUrl = sellerImageUrl;
    _shopImageUrl = shopImageUrl;
    _notificationImageUrl = notificationImageUrl;
    if (digitalProductUrl != null) {
      _digitalProductUrl = digitalProductUrl;
    }
    _deliveryManImage = deliveryManImage;
  }

  String? get productImageUrl => _productImageUrl;
  String? get productThumbnailUrl => _productThumbnailUrl;
  String? get brandImageUrl => _brandImageUrl;
  String? get customerImageUrl => _customerImageUrl;
  String? get bannerImageUrl => _bannerImageUrl;
  String? get categoryImageUrl => _categoryImageUrl;
  String? get reviewImageUrl => _reviewImageUrl;
  String? get sellerImageUrl => _sellerImageUrl;
  String? get shopImageUrl => _shopImageUrl;
  String? get notificationImageUrl => _notificationImageUrl;
  String? get digitalProductUrl => _digitalProductUrl;
  String? get deliveryManImage => _deliveryManImage;


  BaseUrls.fromJson(Map<String, dynamic> json) {
    _productImageUrl = json['product_image_url'];
    _productThumbnailUrl = json['product_thumbnail_url'];
    _brandImageUrl = json['brand_image_url'];
    _customerImageUrl = json['customer_image_url'];
    _bannerImageUrl = json['banner_image_url'];
    _categoryImageUrl = json['category_image_url'];
    _reviewImageUrl = json['review_image_url'];
    _sellerImageUrl = json['seller_image_url'];
    _shopImageUrl = json['shop_image_url'];
    _notificationImageUrl = json['notification_image_url'];
    _digitalProductUrl = json['digital_product_url'];
    _deliveryManImage = json['delivery_man_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_image_url'] = _productImageUrl;
    data['product_thumbnail_url'] = _productThumbnailUrl;
    data['brand_image_url'] = _brandImageUrl;
    data['customer_image_url'] = _customerImageUrl;
    data['banner_image_url'] = _bannerImageUrl;
    data['category_image_url'] = _categoryImageUrl;
    data['review_image_url'] = _reviewImageUrl;
    data['seller_image_url'] = _sellerImageUrl;
    data['shop_image_url'] = _shopImageUrl;
    data['notification_image_url'] = _notificationImageUrl;
    data['digital_product_url'] = _digitalProductUrl;
    data['delivery_man_image_url'] = _deliveryManImage;
    return data;
  }
}

class StaticUrls {
  String? _contactUs;
  String? _brands;
  String? _categories;
  String? _customerAccount;

  StaticUrls(
      {String? contactUs,
        String? brands,
        String? categories,
        String? customerAccount}) {
    _contactUs = contactUs;
    _brands = brands;
    _categories = categories;
    _customerAccount = customerAccount;
  }

  String? get contactUs => _contactUs;
  String? get brands => _brands;
  String? get categories => _categories;
  String? get customerAccount => _customerAccount;


  StaticUrls.fromJson(Map<String, dynamic> json) {
    _contactUs = json['contact_us'];
    _brands = json['brands'];
    _categories = json['categories'];
    _customerAccount = json['customer_account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contact_us'] = _contactUs;
    data['brands'] = _brands;
    data['categories'] = _categories;
    data['customer_account'] = _customerAccount;
    return data;
  }
}

class SocialLogin {
  String? _loginMedium;
  bool? _status;

  SocialLogin({String? loginMedium, bool? status}) {
    _loginMedium = loginMedium;
    _status = status;
  }

  String? get loginMedium => _loginMedium;
  bool? get status => _status;

  SocialLogin.fromJson(Map<String, dynamic> json) {
    _loginMedium = json['login_medium'];
    _status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login_medium'] = _loginMedium;
    data['status'] = _status;
    return data;
  }
}

class Faq {
  int? _id;
  String? _question;
  String? _answer;
  int? _ranking;
  int? _status;
  String? _createdAt;
  String? _updatedAt;

  Faq(
      {int? id,
        String? question,
        String? answer,
        int? ranking,
        int? status,
        String? createdAt,
        String? updatedAt}) {
    _id = id;
    _question = question;
    _answer = answer;
    _ranking = ranking;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  String? get question => _question;
  String? get answer => _answer;
  int? get ranking => _ranking;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  Faq.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _question = json['question'];
    _answer = json['answer'];
    _ranking = json['ranking'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['question'] = _question;
    data['answer'] = _answer;
    data['ranking'] = _ranking;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}

class CurrencyList {
  int? _id;
  String? _name;
  String? _symbol;
  String? _code;
  double? _exchangeRate;
  int? _status;
  String? _createdAt;
  String? _updatedAt;

  CurrencyList(
      {int? id,
        String? name,
        String? symbol,
        String? code,
        double? exchangeRate,
        int? status,
        String? createdAt,
        String? updatedAt}) {
    _id = id;
    _name = name;
    _symbol = symbol;
    _code = code;
    _exchangeRate = exchangeRate;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  String? get name => _name;
  String? get symbol => _symbol;
  String? get code => _code;
  double? get exchangeRate => _exchangeRate;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  CurrencyList.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _symbol = json['symbol'];
    _code = json['code'];
    _exchangeRate = json['exchange_rate'].toDouble();
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['symbol'] = _symbol;
    data['code'] = _code;
    data['exchange_rate'] = _exchangeRate;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}

class Colors {
  int? _id;
  String? _name;
  String? _code;
  String? _createdAt;
  String? _updatedAt;

  Colors(
      {int? id, String? name, String? code, String? createdAt, String? updatedAt}) {
    _id = id;
    _name = name;
    _code = code;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  String? get name => _name;
  String? get code => _code;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  Colors.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['code'] = _code;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}
class Announcement {
  String? _status;
  String? _color;
  String? _textColor;
  String? _announcement;

  Announcement({String? status, String? color,String? textColor, String? announcement}) {
    if (status != null) {
      _status = status;
    }
    if (color != null) {
      _color = color;
    }
    if (textColor != null) {
      _textColor = textColor;
    }
    if (announcement != null) {
      _announcement = announcement;
    }
  }

  String? get status => _status;
  String? get color => _color;
  String? get textColor => _textColor;
  String? get announcement => _announcement;
  Announcement.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _color = json['color'];
    _textColor = json['text_color'];
    _announcement = json['announcement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['color'] = _color;
    data['text_color'] = _textColor;
    data['announcement'] = _announcement;
    return data;
  }
}

class RefundPolicy {
  int? _status;
  String? _content;

  RefundPolicy({int? status, String? content}) {
    if (status != null) {
      _status = status;
    }
    if (content != null) {
      _content = content;
    }
  }

  int? get status => _status;
  String? get content => _content;


  RefundPolicy.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['content'] = _content;
    return data;
  }
}


class PaymentMethods {
  bool? _offlinePayment;
  bool? _sslCommerzPayment;
  bool? _paypal;
  bool? _stripe;
  bool? _razorPay;
  bool? _senangPay;
  bool? _paytabs;
  bool? _paystack;
  bool? _paymobAccept;
  bool? _fawryPay;
  bool? _mercadopago;
  bool? _liqpay;
  bool? _flutterwave;
  bool? _paytm;
  bool? _bkash;

  PaymentMethods(
      {
        bool? offlinePayment,
        bool? sslCommerzPayment,
        bool? paypal,
        bool? stripe,
        bool? razorPay,
        bool? senangPay,
        bool? paytabs,
        bool? paystack,
        bool? paymobAccept,
        bool? fawryPay,
        bool? mercadopago,
        bool? liqpay,
        bool? flutterwave,
        bool? paytm,
        bool? bkash}) {

    if (offlinePayment != null) {
      _offlinePayment = offlinePayment;
    }
    if (sslCommerzPayment != null) {
      _sslCommerzPayment = sslCommerzPayment;
    }
    if (paypal != null) {
      _paypal = paypal;
    }
    if (stripe != null) {
      _stripe = stripe;
    }
    if (razorPay != null) {
      _razorPay = razorPay;
    }
    if (senangPay != null) {
      _senangPay = senangPay;
    }
    if (paytabs != null) {
      _paytabs = paytabs;
    }
    if (paystack != null) {
      _paystack = paystack;
    }
    if (paymobAccept != null) {
      _paymobAccept = paymobAccept;
    }
    if (fawryPay != null) {
      _fawryPay = fawryPay;
    }
    if (mercadopago != null) {
      _mercadopago = mercadopago;
    }
    if (liqpay != null) {
      _liqpay = liqpay;
    }
    if (flutterwave != null) {
      _flutterwave = flutterwave;
    }
    if (paytm != null) {
      _paytm = paytm;
    }
    if (bkash != null) {
      _bkash = bkash;
    }
  }


  bool? get offlinePayment => _offlinePayment;
  bool? get sslCommerzPayment => _sslCommerzPayment;
  bool? get paypal => _paypal;
  bool? get stripe => _stripe;
  bool? get razorPay => _razorPay;
  bool? get senangPay => _senangPay;
  bool? get paytabs => _paytabs;
  bool? get paystack => _paystack;
  bool? get paymobAccept => _paymobAccept;
  bool? get fawryPay => _fawryPay;
  bool? get mercadopago => _mercadopago;
  bool? get liqpay => _liqpay;
  bool? get flutterwave => _flutterwave;
  bool? get paytm => _paytm;
  bool? get bkash => _bkash;

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    _offlinePayment = json['offline_payment'];
    _sslCommerzPayment = json['ssl_commerz_payment'];
    _paypal = json['paypal'];
    _stripe = json['stripe'];
    _razorPay = json['razor_pay'];
    _senangPay = json['senang_pay'];
    _paytabs = json['paytabs'];
    _paystack = json['paystack'];
    _paymobAccept = json['paymob_accept'];
    _fawryPay = json['fawry_pay'];
    _mercadopago = json['mercadopago'];
    _liqpay = json['liqpay'];
    _flutterwave = json['flutterwave'];
    _paytm = json['paytm'];
    _bkash = json['bkash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offline_payment'] = _offlinePayment;
    data['ssl_commerz_payment'] = _sslCommerzPayment;
    data['paypal'] = _paypal;
    data['stripe'] = _stripe;
    data['razor_pay'] = _razorPay;
    data['senang_pay'] = _senangPay;
    data['paytabs'] = _paytabs;
    data['paystack'] = _paystack;
    data['paymob_accept'] = _paymobAccept;
    data['fawry_pay'] = _fawryPay;
    data['mercadopago'] = _mercadopago;
    data['liqpay'] = _liqpay;
    data['flutterwave'] = _flutterwave;
    data['paytm'] = _paytm;
    data['bkash'] = _bkash;
    return data;
  }
}
