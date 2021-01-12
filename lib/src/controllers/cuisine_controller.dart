import 'package:flutter/material.dart';
import 'package:markets/generated/l10n.dart';
import 'package:markets/src/models/cuisine.dart';
import 'package:markets/src/models/restaurant.dart';
import 'package:markets/src/repository/cuisine_repository.dart';
import 'package:markets/src/repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class CuisineController extends ControllerMVC {
  List restaurants = <Restaurant>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Cuisine cuisine;

  CuisineController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForRestaurantsByCuisine({String id, String message}) async {
    final Stream<Restaurant> stream = await getRestaurantsByCuisine(id, deliveryAddress.value);
    stream.listen((Restaurant _food) {
      setState(() {
        restaurants.add(_food);
      });
    }, onError: (a) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCuisine({String id, String message}) async {
    final Stream<Cuisine> stream = await getCuisine(id);
    stream.listen((Cuisine _cuisine) {
      setState(() => cuisine = _cuisine);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshCategory() async {
    restaurants.clear();
    cuisine = new Cuisine();
    listenForRestaurantsByCuisine(message: S.of(context).category_refreshed_successfuly);
    listenForCuisine(message: S.of(context).category_refreshed_successfuly);
  }

}