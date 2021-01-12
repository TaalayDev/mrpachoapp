import '../models/option.dart';
import '../models/food.dart';

class FoodOrder {
  String id;
  double price;
  double quantity;
  List<Option> options;
  Food food;
  DateTime dateTime;
  FoodOrder();

  FoodOrder.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      quantity = jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;
      food = jsonMap['food'] != null ? Food.fromJSON(jsonMap['food']) : new Food();
      dateTime = DateTime.parse(jsonMap['updated_at']);
      options = jsonMap['options'] != null ? List.from(jsonMap['options']).map((element) => Option.fromJSON(element)).toList() : [];
    } catch (e) {
      id = '';
      price = 0.0;
      quantity = 0.0;
      food = new Food();
      dateTime = DateTime(0);
      options = [];
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["price"] = price;
    map["quantity"] = quantity;
    map["food_id"] = food.id;
    map["options"] = options.map((element) => element.id).toList();
    return map;
  }
}
