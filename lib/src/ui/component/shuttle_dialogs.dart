import 'package:flutter/material.dart';
import 'package:shuttles_scanner/src/models/ticket.dart';
import 'package:shuttles_scanner/src/services/ticket_validator/firebase.dart';

class TicketDialog extends StatefulWidget {
  final String ticket;

  const TicketDialog({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketDialog> createState() => _TicketDialogState();
}

class _TicketDialogState extends State<TicketDialog> {
  final FirebaseTicketValidator _validator = FirebaseTicketValidator();

  @override
  Widget build(BuildContext context) {
    return _buildCompostDialog(context);
  }

  Widget _buildCompostDialog(BuildContext context) {
    return FutureBuilder<FirebaseQRTicket>(
      future: _validator.validateTicket(widget.ticket),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: _buildCompostDialogContent(context, snapshot),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween(begin: 0.5, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
        );
      },
    );
  }

  Widget dialogTicketFound(BuildContext context, FirebaseQRTicket ticket) {
    return Dialog(
      key: const Key("dialogTicketFound"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //bar to close with center title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Billet Trouvé !',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 48),
              ],
            ),
            Icon(
              Icons.check_circle,
              color: Theme.of(context).primaryColor,
              size: 120,
            ),
            const SizedBox(height: 24),
            Text(
              ticket.shuttleId,
              style: Theme.of(context).textTheme.headline4!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (ticket.isReturn) ...[
              const Text(
                "Ticket de retour",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              "Billet pour l'horaire",
              style: Theme.of(context).textTheme.headline4!,
              textAlign: TextAlign.center,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    //if ticket is late of more than 5 minutes write "EN RETARD"
                    if (ticket.isLate) ...[
                      const Text(
                        "EN RETARD",
                        style: TextStyle(color: Colors.red, fontSize: 30),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                    Text(
                      ticket.time,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                foregroundColor: Colors.white,
              ),
              onPressed: () => _compostTicket(ticket),
              child: const Text("Composter"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _compostTicket(FirebaseQRTicket s) {
    return _validator.compostTicket(s).then((value) => Navigator.pop(context));
  }

  Future<bool> isAvailableTicket(String s) async {
    return Future.delayed(const Duration(seconds: 2), () => true);
  }

  _buildCompostDialogContent(
      BuildContext context, AsyncSnapshot<FirebaseQRTicket> snapshot) {
    if (snapshot.hasError) {
      return dialogTicketNotFound(context, snapshot.error.toString());
    }
    if (snapshot.hasData) {
      if (snapshot.data != null) {
        return dialogTicketFound(context, snapshot.data!);
      }
    } else {
      return Dialog(
        key: const Key('loading'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Recherche du billet...",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  dialogTicketNotFound(BuildContext context, String error) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //bar to close with center title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Erreur',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 120,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Billet non valide",
                style: Theme.of(context).textTheme.headline4!,
                textAlign: TextAlign.center,
              ),
              //display error message in a card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Text(
                        error,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: const Text("FERMER",),
              ),
            ],
          )),
    );
  }
}
