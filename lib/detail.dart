import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'countries.dart';
import 'statistics.dart';

Future<Statistics> _rawGet(String url) async {
  final response = await http.get(url);
  final stats = fromJson(response.body);
  return stats;
}

class Detail extends StatefulWidget {
  final Country country;

  Detail(this.country);

  @override
  _DetailState createState() =>
      _DetailState(_rawGet('http://cov.ngobach.com/${country.code}?json'));
}

class _DetailState extends State<Detail> {
  Future<Statistics> future;

  _DetailState(this.future);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      builder: (ctx, ss) {
        return !ss.hasData
            ? Center(child: CircularProgressIndicator())
            : _buildResultBody(context, ss.data);
      },
      future: future,
    );
  }

  _buildResultBody(BuildContext context, Statistics data) {
    return Column(
      children: <Widget>[
        CovSummary(data, widget.country),
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx, idx) {
              if (idx < data.recentDays.length * 2) {
                return idx % 2 == 0
                    ? CovDaily(data.recentDays[idx ~/ 2])
                    : Divider(height: 1);
              } else {
                return null;
              }
            },
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}

class CovDaily extends StatelessWidget {
  final Daily day;

  CovDaily(this.day);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              '${formatDate(day.date)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
                fontSize: 16,
              ),
            ),
          ),
          _createBox(Colors.white, '${NumberFormat.decimalPattern().format(day.totalCases)}'),
          SizedBox(width: 4),
          _createBox(Colors.red, '+${NumberFormat.decimalPattern().format(day.newCases)}'),
          SizedBox(width: 4),
          _createBox(Colors.orange, '${NumberFormat.decimalPattern().format(day.activeCases)}'),
        ],
      ),
    );
  }

  Widget _createBox(Color color, String text) {
    return SizedBox(
      width: 60,
      height: 24,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class CovSummary extends StatelessWidget {
  final Statistics data;
  final Country country;

  CovSummary(this.data, this.country);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              '${country.flag} ${country.name}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _createColumn('Total', '${NumberFormat.compact().format(data.total)}'),
                _createColumn('Recovered', '${NumberFormat.compact().format(data.recovered)}'),
                _createColumn('Death', '${NumberFormat.compact().format(data.death)}'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createColumn(String title, String value) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green.shade200,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ],
    );
  }
}

String formatDate(DateTime date) {
  return DateFormat('y/MM/dd').format(date);
}
