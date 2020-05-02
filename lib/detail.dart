import 'package:flutter/cupertino.dart';
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
        return ss.hasData
            ? _buildResultBody(context, ss.data)
            : ss.hasError
                ? _buildErrorBody(context, ss.error)
                : Center(child: CircularProgressIndicator());
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

  Widget _buildErrorBody(BuildContext context, dynamic error) {
    return Center(
      child: Text('Error: $error}'),
    );
  }
}

class CovDaily extends StatelessWidget {
  final Daily day;

  CovDaily(this.day);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openInfoModal(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
            _createBox(Colors.white,
                '${NumberFormat.decimalPattern().format(day.totalCases)}'),
            SizedBox(width: 4),
            _createBox(Colors.red,
                '+${NumberFormat.decimalPattern().format(day.newCases)}'),
            SizedBox(width: 4),
            _createBox(Colors.orange,
                '${NumberFormat.decimalPattern().format(day.activeCases)}'),
          ],
        ),
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
            borderRadius: BorderRadius.all(Radius.circular(4))),
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

  void _openInfoModal(BuildContext context) {
    showDialog(
      context: context,
      child: SimpleDialog(
        contentPadding: EdgeInsets.zero,
        title: Text(
          formatDate(day.date),
          textAlign: TextAlign.center,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ...[
                  ['Total', '${NumberFormat.decimalPattern().format(day.totalCases)}'],
                  ['New', '${NumberFormat.decimalPattern().format(day.newCases)}'],
                  ['Active', '${NumberFormat.decimalPattern().format(day.activeCases)}'],
                ].map(
                  (p) => Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          p[0],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          p[1],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: FlatButton(
                onPressed: () => Navigator.pop(context), child: Text('OK')),
          ),
        ],
        titlePadding: EdgeInsets.all(10),
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
                _createColumn(
                    'Total', '${NumberFormat.compact().format(data.total)}'),
                _createColumn('Recovered',
                    '${NumberFormat.compact().format(data.recovered)}'),
                _createColumn(
                    'Death', '${NumberFormat.compact().format(data.death)}'),
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
