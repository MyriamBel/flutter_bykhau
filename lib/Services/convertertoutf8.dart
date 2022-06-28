import 'dart:convert';

import 'package:html/parser.dart';

class Decodetoutf8{
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }
  static String removeTags(String htmlString){
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
}