import 'dart:convert';

class Statistics {
  final int total;
  final int death;
  final int recovered;
  final List<Daily> recentDays;

  Statistics(this.total, this.death, this.recovered): recentDays = [];
}

class Daily {
  final DateTime date;
  final int totalCases;
  final int activeCases;
  final int newCases;

  Daily(this.date, this.totalCases, this.activeCases, this.newCases);
}

Statistics fromJson(String response) {
  final Map<String, dynamic> payload = jsonDecode(response);
  final int total = payload['total'];
  final int deaths = payload['deaths'];
  final int recovered = payload['recovered'];
  final stats = Statistics(total, deaths, recovered);
  final List<dynamic> days = payload['days'];
  for (final d in days) {
    stats.recentDays.insert(0, Daily(_toDateTime(d['date']), d['total'], d['active'], d['new']));
  }
  return stats;
}

DateTime _toDateTime(String d) {
  return DateTime.parse(d);
}