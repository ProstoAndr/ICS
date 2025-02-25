import 'package:flutter/painting.dart';

abstract final class MainColors {
  static Color neutral010 = HexColor.fromHex('#FFFFFF');
  static Color neutral020 = HexColor.fromHex('#FCFCFD');
  static Color neutral030 = HexColor.fromHex('#F5F5F9');
  static Color hover = HexColor.fromHex('#F3F2F6');
  static Color neutral040 = HexColor.fromHex('#29292B').withOpacity(0.2);
  static Color neutral050 = HexColor.fromHex('#AEAEB2');
  static Color neutral060 = HexColor.fromHex('#6C6C70');
  static Color neutral070 = HexColor.fromHex('#29292B').withOpacity(0.85);
  static Color neutral085 = HexColor.fromHex('#29292B');
  static Color primary010 = HexColor.fromHex('#AEFFCA');
  static Color primary020 = HexColor.fromHex('#94FFB8');
  static Color primary030 = HexColor.fromHex('#8FF8B2');
  static Color secondary010 = HexColor.fromHex('#DEEDFF');
  static Color secondary020 = HexColor.fromHex('#B1D5FF');
  static Color secondary030 = HexColor.fromHex('#006BE9');
  static Color secondary040 = HexColor.fromHex('#003470').withOpacity(0.80);
  static Color secondary050 = HexColor.fromHex('#003470');
  static Color critical = HexColor.fromHex('#FF2D55');
  static Color success = HexColor.fromHex('#129273');
  static Color orange = HexColor.fromHex('#FCAA49');
  static Color purple = HexColor.fromHex('#5558B9');
}

extension HexColor on Color {
  /// Строка может иметь формат "aabbcc" или "ffaabbcc" с необязательным префиксом "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('FF');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Флаг leadingHashSign, отвечающий за наличие знака решетки в начале по умолчанию равен `true`.
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
