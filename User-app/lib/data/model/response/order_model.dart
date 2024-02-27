class OrderModel {
  int? _id;
  int? _customerId;
  String? _customerType;
  String? _paymentStatus;
  String? _orderStatus;
  String? _paymentMethod;
  String? _transactionRef;
  double? _orderAmount;
  int? _shippingAddress;
  int? _billingAddress;
  ShippingAddressData? _shippingAddressData;
  BillingAddressData? _billingAddressData;
  int? _sellerId;
  int? _shippingMethodId;
  double? _shippingCost;
  String? _createdAt;
  String? _updatedAt;
  double? _discountAmount;
  String? _discountType;
  String? _orderNote;
  String? _orderType;
  double? _extraDiscount;
  String? _extraDiscountType;
  String? _thirdPartyServiceName;
  String? _thirdPartyTrackingId;
  DeliveryMan? _deliveryMan;


  OrderModel(
      {int? id,
        int? customerId,
        String? customerType,
        String? paymentStatus,
        String? orderStatus,
        String? paymentMethod,
        String? transactionRef,
        double? orderAmount,
        int? shippingAddress,
        int? billingAddress,
        ShippingAddressData? shippingAddressData,
        BillingAddressData? billingAddressData,
        int? sellerId,
        int? shippingMethodId,
        double? shippingCost,
        String? createdAt,
        String? updatedAt,
        double? discountAmount,
        String? discountType,
        String? orderNote,
        String? orderType,
        double? extraDiscount,
        String? extraDiscountType,
        String? thirdPartyServiceNam,
        String? thirdPartyTrackingId,
        DeliveryMan? deliveryMan
      }) {
    _id = id;
    _customerId = customerId;
    _customerType = customerType;
    _paymentStatus = paymentStatus;
    _orderStatus = orderStatus;
    _paymentMethod = paymentMethod;
    _transactionRef = transactionRef;
    _orderAmount = orderAmount;
    _shippingAddress = shippingAddress;
    if (shippingAddressData != null) {
      _shippingAddressData = shippingAddressData;
    }
    _billingAddress = billingAddress;
    _billingAddressData = billingAddressData;
    _sellerId = sellerId;
    _shippingCost = shippingCost;
    _shippingMethodId = shippingMethodId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _discountAmount = discountAmount;
    _discountType = discountType;
    _orderNote = orderNote;
    _orderType = orderType;
    if (extraDiscount != null) {
      _extraDiscount = extraDiscount;
    }
    if (extraDiscountType != null) {
      _extraDiscountType = extraDiscountType;
    }
    if (thirdPartyServiceNam != null) {
      _thirdPartyServiceName = thirdPartyServiceNam;
    }
    if (thirdPartyTrackingId != null) {
      _thirdPartyTrackingId = thirdPartyTrackingId;
    }
    if (deliveryMan != null) {
      _deliveryMan = deliveryMan;
    }

  }

  int? get id => _id;
  int? get customerId => _customerId;
  String? get customerType => _customerType;
  String? get paymentStatus => _paymentStatus;
  String? get orderStatus => _orderStatus;
  String? get paymentMethod => _paymentMethod;
  String? get transactionRef => _transactionRef;
  double? get orderAmount => _orderAmount;
  int? get shippingAddress => _shippingAddress;
  ShippingAddressData? get shippingAddressData => _shippingAddressData;
  int? get billingAddress => _billingAddress;
  BillingAddressData? get billingAddressData => _billingAddressData;
  int? get shippingMethodId => _shippingMethodId;
  int? get sellerId => _sellerId;
  double? get shippingCost => _shippingCost;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  double? get discountAmount => _discountAmount;
  String? get discountType => _discountType;
  String? get orderNote => _orderNote;
  String? get orderType => _orderType;
  double? get extraDiscount => _extraDiscount;
  String? get extraDiscountType => _extraDiscountType;
  String? get  thirdPartyServiceName => _thirdPartyServiceName;
  String? get  thirdPartyTrackingId => _thirdPartyTrackingId;
  DeliveryMan? get deliveryMan => _deliveryMan;

  OrderModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _customerType = json['customer_type'];
    _paymentStatus = json['payment_status'];
    _orderStatus = json['order_status'];
    _paymentMethod = json['payment_method'];
    _transactionRef = json['transaction_ref'];
    _orderAmount = json['order_amount'].toDouble();
    _shippingAddress = json['shipping_address'];
    _shippingAddressData = json['shipping_address_data'] != null
        ? ShippingAddressData.fromJson(json['shipping_address_data'])
        : null;
    _billingAddress = json['billing_address'];
    _billingAddressData = json['billing_address_data'] != null
        ? BillingAddressData.fromJson(json['billing_address_data'])
        : null;

    if(json['seller_id'] !=null && json['seller_id'] != ''){
      _sellerId = json['seller_id'];
    }
    _shippingMethodId = int.parse(json['shipping_method_id'].toString());
    _shippingCost = double.parse(json['shipping_cost'].toString());
    if(json['created_at'] != null){
      _createdAt = json['created_at'];
    }
    _updatedAt = json['updated_at'];
    _discountAmount = json['discount_amount'].toDouble();
    _discountType = json['discount_type'];
    _orderNote = json['order_note'];
    _orderType = json['order_type'];
    _extraDiscount = json['extra_discount'].toDouble();
    _extraDiscountType = json['extra_discount_type'];
    if(json['delivery_service_name']!=null && json['delivery_service_name']!= ""){
      _thirdPartyServiceName = json['delivery_service_name'];
    }
    if(json['third_party_delivery_tracking_id']!=null && json['third_party_delivery_tracking_id']!= ""){
      _thirdPartyTrackingId = json['third_party_delivery_tracking_id'];
    }
    _deliveryMan = json['delivery_man'] != null
        ? DeliveryMan.fromJson(json['delivery_man'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['customer_id'] = _customerId;
    data['customer_type'] = _customerType;
    data['payment_status'] = _paymentStatus;
    data['order_status'] = _orderStatus;
    data['payment_method'] = _paymentMethod;
    data['transaction_ref'] = _transactionRef;
    data['order_amount'] = _orderAmount;
    data['shipping_address'] = _shippingAddress;
    if (_shippingAddressData != null) {
      data['shipping_address_data'] = _shippingAddressData!.toJson();
    }
    data['billing_address'] = _billingAddress;
    if (billingAddressData != null) {
      data['billing_address_data'] = billingAddressData!.toJson();
    }
    data['shipping_method_id'] = _shippingMethodId;
    data['seller_id'] = _sellerId;
    data['shipping_cost'] = _shippingCost;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['discount_amount'] = _discountAmount;
    data['discount_type'] = _discountType;
    data['order_note'] = _orderNote;
    data['order_type'] = _orderType;
    data['extra_discount'] = _extraDiscount;
    data['extra_discount_type'] = _extraDiscountType;
    data['delivery_service_name'] = _thirdPartyServiceName;
    data['third_party_delivery_tracking_id'] = _thirdPartyTrackingId;
    if (_deliveryMan != null) {
      data['delivery_man'] = _deliveryMan!.toJson();
    }

    return data;
  }
}
class BillingAddressData {
  int? id;
  int? customerId;
  String? contactPersonName;
  String? addressType;
  String? address;
  String? city;
  String? zip;
  String? phone;
  String? createdAt;
  String? updatedAt;
  String? country;
  String? latitude;
  String? longitude;
  int? isBilling;

  BillingAddressData(
      {this.id,
        this.customerId,
        this.contactPersonName,
        this.addressType,
        this.address,
        this.city,
        this.zip,
        this.phone,
        this.createdAt,
        this.updatedAt,
        this.country,
        this.latitude,
        this.longitude,
        this.isBilling});

  BillingAddressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    contactPersonName = json['contact_person_name'];
    addressType = json['address_type'];
    address = json['address'];
    city = json['city'];
    zip = json['zip'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    country = json['country'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isBilling = json['is_billing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['contact_person_name'] = contactPersonName;
    data['address_type'] = addressType;
    data['address'] = address;
    data['city'] = city;
    data['zip'] = zip;
    data['phone'] = phone;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['country'] = country;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['is_billing'] = isBilling;
    return data;
  }
}

class ShippingAddressData {
  int? _id;
  int? _customerId;
  String? _contactPersonName;
  String? _addressType;
  String? _address;
  String? _city;
  String? _zip;
  String? _phone;
  String? _createdAt;
  String? _updatedAt;
  String? _country;

  ShippingAddressData(
      {int? id,
        int? customerId,
        String? contactPersonName,
        String? addressType,
        String? address,
        String? city,
        String? zip,
        String? phone,
        String? createdAt,
        String? updatedAt,
        void state,
        String? country}) {
    if (id != null) {
      _id = id;
    }
    if (customerId != null) {
      _customerId = customerId;
    }
    if (contactPersonName != null) {
      _contactPersonName = contactPersonName;
    }
    if (addressType != null) {
      _addressType = addressType;
    }
    if (address != null) {
      _address = address;
    }
    if (city != null) {
      _city = city;
    }
    if (zip != null) {
      _zip = zip;
    }
    if (phone != null) {
      _phone = phone;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }

    if (country != null) {
      _country = country;
    }
  }

  int? get id => _id;
  int? get customerId => _customerId;
  String? get contactPersonName => _contactPersonName;
  String? get addressType => _addressType;
  String? get address => _address;
  String? get city => _city;
  String? get zip => _zip;
  String? get phone => _phone;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get country => _country;


  ShippingAddressData.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _contactPersonName = json['contact_person_name'];
    _addressType = json['address_type'];
    _address = json['address'];
    _city = json['city'];
    _zip = json['zip'];
    _phone = json['phone'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['customer_id'] = _customerId;
    data['contact_person_name'] = _contactPersonName;
    data['address_type'] = _addressType;
    data['address'] = _address;
    data['city'] = _city;
    data['zip'] = _zip;
    data['phone'] = _phone;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['country'] = _country;
    return data;
  }
}

class DeliveryMan {
  int? _id;
  String? _fName;
  String? _lName;
  String? _phone;
  String? _email;
  String? _image;
  DeliveryMan(
      {
        int? id,
        String? fName,
        String? lName,
        String? phone,
        String? email,
        String? image
      }) {

    if (id != null) {
      _id = id;
    }
    if (fName != null) {
      _fName = fName;
    }
    if (lName != null) {
      _lName = lName;
    }
    if (phone != null) {
      _phone = phone;
    }
    if (email != null) {
      _email = email;
    }

    if (image != null) {
      _image = image;
    }

  }


  int? get id => _id;
  String? get fName => _fName;
  String? get lName => _lName;
  String? get phone => _phone;
  String? get email => _email;
  String? get image => _image;

  DeliveryMan.fromJson(Map<String, dynamic> json) {

    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _phone = json['phone'];
    _email = json['email'];
    _image = json['image'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = _id;
    data['f_name'] = _fName;
    data['l_name'] = _lName;
    data['phone'] = _phone;
    data['email'] = _email;
    data['image'] = _image;
    return data;
  }
}