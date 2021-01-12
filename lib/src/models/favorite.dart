import '../models/option.dart';
import '../models/food.dart';

class Favorite {
  String id;
  Food food;
  List<Option> options;
  String userId;

  Favorite();

  Favorite.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      food = jsonMap['food'] != null ? Food.fromJSON(jsonMap['food']) : new Food();
      options = jsonMap['options'] != null
          ? List.from(jsonMap['options']).map((element) => Option.fromJSON(element)).toList()
          : null;
    } catch (e) {
      id = '';
      food = new Food();
      options = [];
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["food_id"] = food.id;
    map["user_id"] = userId;
    map["options"] = options.map((element) => element.id).toList();
    return map;
  }
}
