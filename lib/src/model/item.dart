// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

List<Item> itemFromJson(String str) =>
    List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

String itemToJson(List<Item> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Item {
  Item({
    required this.thumb,
    required this.id,
    required this.urlName,
    required this.itemName,
    required this.vaulted,
  });

  final String thumb;
  final String id;
  final String urlName;
  final String itemName;
  final bool? vaulted;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        thumb: json["thumb"],
        id: json["id"],
        urlName: json["url_name"],
        itemName: json["item_name"],
        vaulted: json["vaulted"] == null ? null : json["vaulted"],
      );

  Map<String, dynamic> toJson() => {
        "thumb": thumb,
        "id": id,
        "url_name": urlName,
        "item_name": itemName,
        "vaulted": vaulted == null ? null : vaulted,
      };
}
