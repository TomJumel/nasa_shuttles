
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseQRTicket extends Ticket {
  final Future<DocumentSnapshot<Map<String, dynamic>>> validationReference;
  final bool isReturn;

  FirebaseQRTicket(super.id, super.time, super.shuttleId,
      this.validationReference, this.isReturn);

  factory FirebaseQRTicket.fromJson(Map<String, dynamic> json) {
    bool isReturn = json["return"] ?? false;
    final ref = FirebaseFirestore.instance
        .collection(isReturn ? "return-shuttles" : "shuttels")
        .doc(json["shuttleId"])
        .collection("access")
        .doc(json["id"]);
    return FirebaseQRTicket(
      json["id"],
      json["time"],
      json["shuttleId"],
      ref.get(),
      isReturn,
    );
  }
}

class Ticket {
  final String id;
  final String time;
  final String shuttleId;

  Ticket(this.id, this.time, this.shuttleId);

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      json['id'],
      json['time'],
      json['shuttleId'],
    );
  }

  TimeOfDay get timeOfDay {
    final time = this.time.split(":");
    return TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
  }
  //is late with 5mins
  bool get isLate => timeOfDay.hour < DateTime.now().hour || (timeOfDay.hour == DateTime.now().hour && timeOfDay.minute < DateTime.now().minute - 5);
}
