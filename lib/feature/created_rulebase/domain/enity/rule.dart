import 'dart:convert';

class Rule {
  final String id;
  final List<double> x;
  double y;
  double weight;

  Rule({
    required this.id,
    required this.x,
    required this.y,
    required this.weight,
  });

  factory Rule.fromJson(Map<String, dynamic> json) {
    return _ruleFromJson(json);
  }

  factory Rule.fromJsonStr(String jsonStr) {
    final Map<String, dynamic> json = jsonDecode(jsonStr);
    return _ruleFromJson(json);
  }

  static Rule _ruleFromJson(Map<String, dynamic> json) {
    return Rule(
      id: json['id'],
      x: List<double>.from(json['x']),
      y: json['y'],
      weight: json['weight'],
    );
  }

  static List<Rule> fromJsonToList(String jsonStr) {
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    return jsonList.map((content) => Rule.fromJson(content)).toList();
  }

  String toJsonStr() {
    return jsonEncode(ruleToJson());
  }

  Map<String, dynamic> ruleToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['x'] = x;
    data['y'] = y;
    data['weight'] = weight;

    return data;
  }

  static List<Map<String, dynamic>> toJsonList(List<Rule> rules) {
    return rules.map((rule) => rule.ruleToJson()).toList();
  }

  static String toJsonStrList(List<Rule> rules) {
    return jsonEncode(toJsonList(rules));
  }
}
