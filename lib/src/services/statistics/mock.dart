import 'package:shuttles_scanner/src/models/shuttle.dart';

import 'base.dart';

class MockStatisticsService implements StatisticsService {

  @override
  Future<List<ShuttleStatistic>> getShuttleStatistics([String collection = 'shuttels']) async {
    //generate 20 random shuttle statistics
    return Future.delayed(
      const Duration(seconds: 1),
      () => List.generate(
        20,
        (index) => ShuttleStatistic.mock(),
      ),
    );
  }

  @override
  Stream<List<ShuttleStatistic>> getStreamedStatistics([String collection = 'shuttels']) {
    // TODO: implement getStreamedStatistics
    throw UnimplementedError();
  }

}