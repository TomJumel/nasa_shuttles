import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shuttles_scanner/src/models/ticket.dart';
import 'package:shuttles_scanner/src/services/ticket_validator/base.dart';

class FirebaseTicketValidator extends ValidateTicket<FirebaseQRTicket> {
  @override
  Future<void> compostTicket(FirebaseQRTicket ticket) {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final ref = await ticket.validationReference;
      if (ref.exists && !ref.get("accessValidated")) {
        transaction.update(
          ref.reference,
          {
            "accessValidated": true,
            "at": FieldValue.serverTimestamp(),
          },
        );
        transaction.update(
          FirebaseFirestore.instance
              .collection(ticket.isReturn?"return-shuttles" : "shuttels")
              .doc(ticket.shuttleId),
          {
            "validated": FieldValue.increment(1),
          },
        );
      }
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
  }

  @override
  Future<bool> isAvailableTicket(FirebaseQRTicket ticket) {
    return ticket.validationReference.then((value) => value.exists);
  }

  @override
  FirebaseQRTicket parseTicket(String qrCodePayload) {
    String s = String.fromCharCodes(base64Decode(qrCodePayload));
    return FirebaseQRTicket.fromJson(jsonDecode(s));
  }

  @override
  Future<bool> isCompostable(FirebaseQRTicket ticket) {
    return ticket.validationReference
        .then((value) => !value.get("accessValidated"));
  }
}
