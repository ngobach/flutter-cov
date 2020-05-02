class Country {
  final String name;
  final String code;
  final String flag;
  const Country(this.name, this.code, this.flag);
}

class Countries {
  static const VietNam = Country('Viet Nam', 'viet-nam', '🇻🇳');
  static const China = Country('China', 'china', '🇨🇳');
  static const USA = Country('USA', 'us', '🇺🇸');
  static const values = <Country>[
    VietNam,
    China,
    USA,
  ];
}