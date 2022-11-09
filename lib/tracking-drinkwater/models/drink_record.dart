import 'package:flutter/material.dart';

class DrinkRecord {
  final String  id;
  final int capacity;
  final TimeOfDay time;

  const DrinkRecord({required this.id, required this.capacity, required this.time});
}


class Uploaddrinkwaterjson {
  String? id;

  int? capacityChooserIndex;
  int? target;

  Uploaddrinkwaterjson({this.id, this.capacityChooserIndex, this.target});

  Uploaddrinkwaterjson.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["capacityChooserIndex"] is int) {
      capacityChooserIndex = json["capacityChooserIndex"];
    }
    if (json["target"] is int) {
      target = json["target"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["capacityChooserIndex"] = capacityChooserIndex;
    _data["target"] = target;
    return _data;
  }
}
