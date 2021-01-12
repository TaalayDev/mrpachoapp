import 'package:markets/src/models/category.dart';

import '../models/media.dart';

class Cuisine extends Category {
  String id;
  String name;
  String description;
  Media image;

  Cuisine();

  Cuisine.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      description = jsonMap['description'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
    } catch (e) {
      id = '';
      name = '';
      description = '';
      image = new Media();
      print(e);
    }
  }
}