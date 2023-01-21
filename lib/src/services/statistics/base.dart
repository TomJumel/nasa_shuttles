import 'package:shuttles_scanner/src/models/shuttle.dart';

abstract class StatisticsService {
  Future<List<ShuttleStatistic>> getShuttleStatistics([String collection = 'shuttels']);
  Stream<List<ShuttleStatistic>> getStreamedStatistics([String collection = 'shuttels']);
}