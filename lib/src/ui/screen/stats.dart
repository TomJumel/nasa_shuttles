import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuttles_scanner/src/models/shuttle.dart';
import 'package:shuttles_scanner/src/services/statistics/base.dart';

import '../style/colors.dart';

class StatPage extends StatefulWidget {
  final StatisticsService service;

  const StatPage({super.key, required this.service});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  bool returnShuttles = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<ShuttleStatistic>>(
            stream: widget.service.getStreamedStatistics(
                returnShuttles ? "return-shuttles" : "shuttels"),
            builder: (context, snapshot) {
              if (!snapshot.hasData && !snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Une erreur s'est produite"),
                );
              }
              //data are valid
              //extract passed since 30 mins shuttles (parceque il y a toujours du retard)
              TimeOfDay current = returnShuttles
                  ? const TimeOfDay(hour: 0, minute: 0)
                  : TimeOfDay.now();
              current = current.add(const Duration(minutes: -30));
              List<ShuttleStatistic> passed = snapshot.data!
                  .where((element) => element.timeOfDay.isBefore(current))
                  .toList();
              List<ShuttleStatistic> notPassed = snapshot.data!
                  .where((element) => !passed.contains(element))
                  .toList();
              //sort by time
              if (returnShuttles) {
                passed.sort((a, b) => a.timeOfDay.compare(b.timeOfDay));
                notPassed.sort((a, b) => a.timeOfDay.compare(b.timeOfDay));
              } else {
                passed.sort((b, a) => a.timeOfDay.compare(b.timeOfDay));
                notPassed.sort((a, b) => a.timeOfDay.compare(b.timeOfDay));
              }
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    backgroundColor: Colors.white,
                    expandedHeight: 150,
                    elevation: 5,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.only(left: 20, bottom: 15),
                      title: Text(
                        "Statistiques" + (returnShuttles ? " retour" : ""),
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              color: AppColors.primary.shade400,
                            ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(returnShuttles
                            ? Icons.arrow_downward
                            : Icons.arrow_upward),
                        onPressed: () {
                          setState(() {
                            returnShuttles = !returnShuttles;
                          });
                        },
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        if (notPassed.isEmpty)
                          const Center(
                            child: Text("Aucun bus à venir"),
                          ),
                        for (ShuttleStatistic shuttle in notPassed)
                          Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: AppColors.primary.shade50,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Navette de ${shuttle.time}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!,
                                      ),
                                      const Spacer(),
                                      Text(
                                        shuttle.isFull
                                            ? "Complet"
                                            : "Non complet",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(
                                              color: AppColors.primary.shade500,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  _item("Nom", shuttle.id),
                                  _item(
                                    "Nombre de passagers",
                                    shuttle.place,
                                  ),
                                  _item(
                                    "Billet compostées",
                                    shuttle.validated,
                                  ),
                                  _item(
                                    "Capacité max",
                                    shuttle.total,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            "Navettes parties",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        if (passed.isEmpty)
                          const Center(
                            child: Text("Aucune navette n'a encore été lancée"),
                          ),
                        for (ShuttleStatistic shuttle in passed)
                          Container(
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              color: Colors.grey.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Navette de ${shuttle.time}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!,
                                        ),
                                        const Spacer(),
                                        Text(
                                          shuttle.isFull
                                              ? "Complet"
                                              : "Non complet",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(
                                                color:
                                                    AppColors.primary.shade500,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    _item("Nom", shuttle.id),
                                    _item(
                                      "Nombre de passagers",
                                      shuttle.place,
                                    ),
                                    _item(
                                      "Billet compostées",
                                      shuttle.validated,
                                    ),
                                    _item(
                                      "Capacité max",
                                      shuttle.total,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  _item(String title, dynamic value) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
        ),
        const Spacer(),
        Text(
          value.toString(),
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

extension _TimeOfDay on TimeOfDay {
  int compare(TimeOfDay b) {
    if (hour == b.hour) {
      return minute.compareTo(b.minute);
    }
    return hour.compareTo(b.hour);
  }

  bool isBefore(TimeOfDay b) {
    return compare(b) < 0;
  }

  bool isAfter(TimeOfDay b) {
    return compare(b) > 0;
  }

  TimeOfDay add(Duration duration) {
    final int minutes = hour * 60 + minute + duration.inMinutes;
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }
}
