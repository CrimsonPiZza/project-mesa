
// ignore_for_file: prefer_if_null_operators, unnecessary_null_comparison

import 'dart:convert';

Statistic statisticFromJson(String str) => Statistic.fromJson(json.decode(str));

String statisticToJson(Statistic data) => json.encode(data.toJson());

class Statistic {
  Statistic({
    required this.payload,
  });

  final Payload payload;

  factory Statistic.fromJson(Map<String, dynamic> json) => Statistic(
        payload: Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "payload": payload.toJson(),
      };
}

class Payload {
  Payload({
    required this.statisticsClosed,
    required this.statisticsLive,
  });

  final StatisticsClosed statisticsClosed;
  final StatisticsLive statisticsLive;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        statisticsClosed: StatisticsClosed.fromJson(json["statistics_closed"]),
        statisticsLive: StatisticsLive.fromJson(json["statistics_live"]),
      );

  Map<String, dynamic> toJson() => {
        "statistics_closed": statisticsClosed.toJson(),
        "statistics_live": statisticsLive.toJson(),
      };
}

class StatisticsClosed {
  StatisticsClosed({
    required this.the48Hours,
    required this.the90Days,
  });

  final List<StatisticsClosed48Hour> the48Hours;
  final List<StatisticsClosed48Hour> the90Days;

  factory StatisticsClosed.fromJson(Map<String, dynamic> json) =>
      StatisticsClosed(
        the48Hours: List<StatisticsClosed48Hour>.from(
            json["48hours"].map((x) => StatisticsClosed48Hour.fromJson(x))),
        the90Days: List<StatisticsClosed48Hour>.from(
            json["90days"].map((x) => StatisticsClosed48Hour.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "48hours": List<dynamic>.from(the48Hours.map((x) => x.toJson())),
        "90days": List<dynamic>.from(the90Days.map((x) => x.toJson())),
      };
}

class StatisticsClosed48Hour {
  StatisticsClosed48Hour({
    required this.datetime,
    required this.volume,
    required this.minPrice,
    required this.maxPrice,
    required this.openPrice,
    required this.closedPrice,
    required this.avgPrice,
    required this.median,
    required this.modRank,
  });

  final DateTime datetime;
  final int volume;
  final int minPrice;
  final int maxPrice;
  final int openPrice;
  final int closedPrice;
  final double avgPrice;
  final double median;
  final int? modRank;

  factory StatisticsClosed48Hour.fromJson(Map<String, dynamic> json) =>
      StatisticsClosed48Hour(
        datetime: DateTime.parse(json["datetime"]),
        volume: json["volume"],
        minPrice: json["min_price"],
        maxPrice: json["max_price"],
        openPrice: json["open_price"],
        closedPrice: json["closed_price"],
        avgPrice: json["avg_price"].toDouble(),
        median: json["median"].toDouble(),
        modRank: json["mod_rank"] == null ? null : json["mod_rank"],
      );

  Map<String, dynamic> toJson() => {
        "datetime": datetime.toIso8601String(),
        "volume": volume,
        "min_price": minPrice,
        "max_price": maxPrice,
        "open_price": openPrice,
        "closed_price": closedPrice,
        "avg_price": avgPrice,
        "median": median,
        "mod_rank": modRank == null ? null : modRank,
      };
}

class StatisticsLive {
  StatisticsLive({
    required this.the48Hours,
    required this.the90Days,
  });

  final List<StatisticsLive48Hour> the48Hours;
  final List<StatisticsLive48Hour> the90Days;

  factory StatisticsLive.fromJson(Map<String, dynamic> json) => StatisticsLive(
        the48Hours: List<StatisticsLive48Hour>.from(
            json["48hours"].map((x) => StatisticsLive48Hour.fromJson(x))),
        the90Days: List<StatisticsLive48Hour>.from(
            json["90days"].map((x) => StatisticsLive48Hour.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "48hours": List<dynamic>.from(the48Hours.map((x) => x.toJson())),
        "90days": List<dynamic>.from(the90Days.map((x) => x.toJson())),
      };
}

class StatisticsLive48Hour {
  StatisticsLive48Hour({
    required this.datetime,
    required this.volume,
    required this.minPrice,
    required this.maxPrice,
    required this.avgPrice,
    required this.median,
    required this.orderType,
    required this.modRank,
  });

  final DateTime datetime;
  final int volume;
  final double minPrice;
  final double maxPrice;
  final double avgPrice;
  final double median;
  final String orderType;
  final int? modRank;

  factory StatisticsLive48Hour.fromJson(Map<String, dynamic> json) =>
      StatisticsLive48Hour(
        datetime: DateTime.parse(json["datetime"]),
        volume: json["volume"],
        minPrice: json["min_price"].toDouble(),
        maxPrice: json["max_price"].toDouble(),
        avgPrice: json["avg_price"].toDouble(),
        median: json["median"].toDouble(),
        orderType: json["order_type"],
        modRank: json["mod_rank"] == null ? null : json["mod_rank"],
      );

  Map<String, dynamic> toJson() => {
        "datetime": datetime.toIso8601String(),
        "volume": volume,
        "min_price": minPrice,
        "max_price": maxPrice,
        "avg_price": avgPrice,
        "median": median,
        "order_type": orderType,
        "mod_rank": modRank == null ? null : modRank,
      };
}
