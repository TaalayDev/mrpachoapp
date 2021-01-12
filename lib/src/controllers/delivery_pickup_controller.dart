import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class DeliveryPickupController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  model.Address deliveryAddress;
  List<Cart> carts = [];

  String name = '', phone = '';

  DeliveryPickupController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCart();
    listenForDeliveryAddress();
    getNameAndPhone();
    print(settingRepo.deliveryAddress.value.toMap());
  }

  void getNameAndPhone() async {
    name = await settingRepo.getName();
    phone = await settingRepo.getPhone();
    setState(() {});
  }

  void setName(String name) async {
    this.name = name;
    await settingRepo.setName(name);
  }

  void setPhone(String phone) async {
    this.phone = phone;
    await settingRepo.setPhone(phone);
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      setState(() {
        carts.add(_cart);
      });
    });
  }

  void listenForDeliveryAddress() async {
    this.deliveryAddress = settingRepo.deliveryAddress.value;
    print('deladdr' + this.deliveryAddress.id);
  }

  void addAddress(model.Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).new_address_added_successfully),
      ));
    });
  }

  void updateAddress(model.Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).the_address_updated_successfully),
      ));
    });
  }
}
