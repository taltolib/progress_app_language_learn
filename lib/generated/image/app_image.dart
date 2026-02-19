import 'dart:ui';

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

class AppImage {

  final _Widgets widgets = _Widgets();
  final _Logo logo = _Logo();



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