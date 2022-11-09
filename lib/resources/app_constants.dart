import 'package:flutter/material.dart';

class ColorConstant {
  static const blueGradient = [
    // Color(0xff996699),
    // Color(0xffCCFF33),
    Colors.white,
    Color(0xff003366),
  ];
  static const progress_background_color = const Color(0xff1B2153);
  static const common_bg_dark = Color.fromARGB(255, 23, 32, 74);
  static const transparent = Colors.transparent;
  static const primary = Color(0xff003366);
  static const secondary = Color(0xff00FF99);
  static const secondary1 = Color(0xffCCFF33);
  static const black = Color(0xff000326);
  static const white = Color(0xfff0f2f1);
  static const gray9e9e9e = Color(0xff9e9e9e);
  static const text = Color(0xff9e9e9e);
  static const grey70747E = Color(0xff70747E);
  static const pinkFFF1F3 = Color(0xffFFF1F3);
  static const blue265AE8 = Color(0xff265AE8);
  static const yellowFFF2AF = Color(0xffFFF2AF);
  static const grey = Color.fromARGB(12, 118, 118, 128);
  static const redpink = Color(0xfffe546e);
  static const redStop = Color(0xffF70D1A);
  static const cyanResume = Color(0xffCCFFFF);
  static const green = Color(0xff5adc78);
}

class TextStyleConstant {
  static const _fontWeightBold = FontWeight.w500;
  static const _fontWeightNormal = FontWeight.normal;

  static const blueBold16 = TextStyle(
    fontSize: 16,
    color: ColorConstant.blue265AE8,
    fontWeight: _fontWeightBold,
  );
  static const blueRegular16 = TextStyle(
    fontSize: 16,
    color: ColorConstant.blue265AE8,
    fontWeight: _fontWeightNormal,
  );

  static const blackBold16 = TextStyle(
    fontSize: 16,
    color: ColorConstant.black,
    fontWeight: _fontWeightBold,
  );


  static const blackRegular16 = TextStyle(
    fontSize: 16,
    color: ColorConstant.black,
    fontWeight: _fontWeightNormal,
  );

  static const whiteBold16 = TextStyle(
    fontSize: 16,
    color: ColorConstant.white,
    fontWeight: _fontWeightBold,
  );
      static const whiteBold22 = TextStyle(
    fontSize: 22,
    color: ColorConstant.white,
    fontWeight: _fontWeightBold,
  );
    static const whiteBold25 = TextStyle(
    fontSize: 25,
    color: ColorConstant.white,
    fontWeight: _fontWeightBold,
  );

  static const whiteRegular16 = TextStyle(
    fontSize: 16,
    color: ColorConstant.white,
    fontWeight: _fontWeightNormal,
  );
  static const greyRegular16 = TextStyle(
    fontSize: 16,
    color: ColorConstant.grey,
    fontWeight: _fontWeightNormal,
  );
  static const textBold16 = TextStyle(
    fontSize: 16,
    color: ColorConstant.text,
    fontWeight: _fontWeightBold,
  );

  static const textRegular16 = TextStyle(
    fontSize: 16,
    color: ColorConstant.text,
    fontWeight: _fontWeightNormal,
  );

  static const text1Regular116 = TextStyle(
    fontSize: 16,
    color: ColorConstant.secondary,
    fontWeight: _fontWeightNormal,
  );
}
class Palette {
  static final Color scaffold = Colors.blueGrey.shade900;
  static const Color foregroundColor = Colors.white;
  static final Color secondaryForegroundColor = foregroundColor.withOpacity(0.3);

  static const Color blue = Color.fromARGB(255, 63, 167, 252);
  static const Color lighterBlue = Color.fromARGB(255, 106, 188, 255);
}

class AssetIconPaths {
  static const String _basePath = 'assets/icons';
  static const String bottle = '$_basePath/ic_bottle.png';
  static const String minus = '$_basePath/ic_minus.png';
  static const String plus = '$_basePath/ic_plus.png';
  static const String upArrow = '$_basePath/ic_up_arrow.png';

  static const String empty100 = '$_basePath/ic_empty_100.png';
  static const String empty150 = '$_basePath/ic_empty_150.png';
  static const String empty250 = '$_basePath/ic_empty_250.png';
  static const String empty500 = '$_basePath/ic_empty_500.png';

  static const String fill100 = '$_basePath/ic_fill_100.png';
  static const String fill150 = '$_basePath/ic_fill_150.png';
  static const String fill250 = '$_basePath/ic_fill_250.png';
  static const String fill500 = '$_basePath/ic_fill_500.png';

  static const String fillPlus100 = '$_basePath/ic_fill_plus_100.webp';
  static const String fillPlus150 = '$_basePath/ic_fill_plus_150.png';
  static const String fillPlus250 = '$_basePath/ic_fill_plus_250.webp';
  static const String fillPlus500 = '$_basePath/ic_fill_plus_500.webp';

  static const Map<int, Map<String, String>> mapCapcityWithIconPath = {
    100: {'empty': empty100, 'fill': fill100, 'fillPlus': fillPlus100},
    150: {'empty': empty150, 'fill': fill150, 'fillPlus': fillPlus150},
    250: {'empty': empty250, 'fill': fill250, 'fillPlus': fillPlus250},
    500: {'empty': empty500, 'fill': fill500, 'fillPlus': fillPlus500},
  };
}

