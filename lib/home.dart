import 'package:cov/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'countries.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country Select'),
      ),
      body: _CountryList(),
    );
  }
}

class _CountryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: _buildItem);
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index >= Countries.values.length) {
      return null;
    }
    final country = Countries.values[index];
    return ListTile(
      leading: Text(
        country.flag,
        style: TextStyle(
          fontSize: 32,
        ),
      ),
      title: Text(country.name, style: Theme.of(context).textTheme.title),
      onTap: () => _gotoCountry(country, context),
    );
  }

  _gotoCountry(Country c, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Detail(c)));
  }
}
