//{
// "id":"1",
// "time":"12h20",
// "seats":{
//    "available": 10,
//    "total": 20,
//    "validated": 5
//  }
// }

import 'dart:math';

import 'package:flutter/material.dart';

class ShuttleStatistic {
  final String id;
  final String time;
  final int available;
  final int total;
  final int validated;

  ShuttleStatistic(
      this.id, this.time, this.available, this.total, this.validated);

  factory ShuttleStatistic.fromJson(Map<String, dynamic> json) {
    return ShuttleStatistic(
      json['name'],
      json['departureTime'],
      (json['disponibleSeats']??0) - (json["reservedSeat"]??0),
      json['disponibleSeats']??0,
      json['validated']??0,
    );
  }

  get isFull => available == 0;

  int get place => total - available;

  //fake
  static ShuttleStatistic mock() {
    //generate random id, time, available, total, validated
    final random = Random();
    //available <= total
    final available = random.nextInt(20).abs() + 1;
    //validated <= available
    final validated = random.nextInt(available).abs();
    //total >= available
    final total = random.nextInt(80) + available;
    return ShuttleStatistic(
      Random().nextInt(100).toString(),
      "${Random().nextInt(24)}:${Random().nextInt(60)}",
      available,
      total,
      validated,
    );
  }

  //copy with
  ShuttleStatistic copyWith({
    String? id,
    String? time,
    int? available,
    int? total,
    int? validated,
  }) {
    return ShuttleStatistic(
      id ?? this.id,
      time ?? this.time,
      available ?? this.available,
      total ?? this.total,
      validated ?? this.validated,
    );
  }

  TimeOfDay get timeOfDay {
    final timeSplit = time.split(':');
    return TimeOfDay(
        hour: int.parse(timeSplit[0]), minute: int.parse(timeSplit[1]));
  }
}
