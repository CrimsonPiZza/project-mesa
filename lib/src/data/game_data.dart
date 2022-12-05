import 'package:flutter/services.dart';

import '../model/item.dart';

getJson(String path) async {
  return await rootBundle.loadString(path);
}

class GameData {
  static List<Item> items = [];
}

loadData() async {
  GameData.items = itemFromJson(await getJson('assets/jsons/items.json'));
}
