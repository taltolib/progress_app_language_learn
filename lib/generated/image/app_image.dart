import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget _svg(String path, double? width, double? height, Color? color) {
  return SvgPicture.asset(
    path,
    width: width,
    height: height,
    colorFilter: color != null
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null,
    fit: BoxFit.contain,
  );
}
Widget _png(String path, double? width, double? height, Color? color) {
  return Image.asset(
    path,
    width: width,
    height: height,
    color: color,
    fit: BoxFit.contain,
  );
}

class AppImage {
  // ignore: library_private_types_in_public_api
  final _Widgets widgets = _Widgets();
  // ignore: library_private_types_in_public_api
  final _Logo logo = _Logo();
  // ignore: library_private_types_in_public_api
  final _Character character = _Character();
}

class _Widgets {
  static const String _base = 'assets/image/icons';

  Widget s({double? width, double? height, Color? color}) =>
      _svg('$_base/e_sim_icon.svg', width, height, color);
}

class _Logo {
  static const String _base = 'assets/image/logo';

  Widget logoBrand({double? width, double? height, Color? color}) =>
      _svg('$_base/logo_brand.svg', width, height, color);
}

class _Character {
  static const String _base = 'assets/image/icons';

  Widget angry({double? width, double? height, Color? color}) =>
      _png('$_base/angry.png', width, height, color);

  Widget celebration({double? width, double? height, Color? color}) =>
      _png('$_base/celebration.png', width, height, color);

  Widget curious({double? width, double? height, Color? color}) =>
      _png('$_base/curious.png', width, height, color);

  Widget excited({double? width, double? height, Color? color}) =>
      _png('$_base/excited.png', width, height, color);

  Widget fluent({double? width, double? height, Color? color}) =>
      _png('$_base/fluent.png', width, height, color);

  Widget fluent2({double? width, double? height, Color? color}) =>
      _png('$_base/fluent_2.png', width, height, color);

  Widget happy({double? width, double? height, Color? color}) =>
      _png('$_base/happy.png', width, height, color);

  Widget hardWork({double? width, double? height, Color? color}) =>
      _png('$_base/hard_work.png', width, height, color);

  Widget hushed({double? width, double? height, Color? color}) =>
      _png('$_base/hushed.png', width, height, color);

  Widget nervous({double? width, double? height, Color? color}) =>
      _png('$_base/nervous.png', width, height, color);

  Widget proud({double? width, double? height, Color? color}) =>
      _png('$_base/proud.png', width, height, color);

  Widget proud2({double? width, double? height, Color? color}) =>
      _png('$_base/proud_2.png', width, height, color);

  Widget sad({double? width, double? height, Color? color}) =>
      _png('$_base/sad.png', width, height, color);

  Widget shocked({double? width, double? height, Color? color}) =>
      _png('$_base/shocked.png', width, height, color);

  Widget shocked2({double? width, double? height, Color? color}) =>
      _png('$_base/shocked_2.png', width, height, color);

  Widget dance({double? width, double? height, Color? color}) =>
      _png('$_base/dance.png', width, height, color);

  Widget thinking({double? width, double? height, Color? color}) =>
      _png('$_base/thinking.png', width, height, color);

  Widget tired({double? width, double? height, Color? color}) =>
      _png('$_base/tired.png', width, height, color);
}
