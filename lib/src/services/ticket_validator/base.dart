import 'package:shuttles_scanner/src/models/ticket.dart';

abstract class ValidateTicket<T extends Ticket> {
  Future<T> validateTicket(String ticket) async {
    T t;
    try {
      t = parseTicket(ticket);
    } catch (e) {
      throw ValidateTicketException("Ticket invalide");
    }
    if (!await isAvailableTicket(t)) {
      throw ValidateTicketException(
          "Ticket pas dispo : info ${t.shuttleId} à ${t.time}");
    }
    if (!await isCompostable(t)) {
      throw ValidateTicketException("Ticket deja utilise");
    }
    return t;
  }

  T parseTicket(String qrCodePayload);

  Future<bool> isAvailableTicket(T ticket);

  Future<bool> isCompostable(T ticket);

  Future<void> compostTicket(T ticket);
}

class ValidateTicketException implements Exception {
  final String message;

  ValidateTicketException(this.message);

  @override
  String toString() {
    return message;
  }
}
