import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shuttles_scanner/src/models/shuttle.dart';
import 'package:shuttles_scanner/src/services/statistics/base.dart';

class FirebaseStatsShuttles extends StatisticsService {
  @override
  Future<List<ShuttleStatistic>> getShuttleStatistics([String collection = 'shuttels']) async {
    return FirebaseFirestore.instance.collection(collection).get().then(
        (value) => value.docs
            .map((e) => ShuttleStatistic.fromJson(e.data()))
            .toList());
  }

  @override
  Stream<List<ShuttleStatistic>> getStreamedStatistics([String collection = 'shuttels']) {
    return FirebaseFirestore.instance.collection(collection).snapshots().map(
        (event) => event.docs
            .map((e) => ShuttleStatistic.fromJson(e.data()))
            .toList());
  }
}
