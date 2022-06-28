import 'dart:convert';

import 'package:bykhau/Services/convertertoutf8.dart';

import 'constants.dart';
import 'package:http/http.dart' as http;
import 'package:bykhau/Models/articles.dart';
import 'package:bykhau/Models/tourarticles.dart';
import 'package:bykhau/Models/tourobjects.dart';

final Map <String, String> headers = {
  'Access-Control-Allow-Credentials': 'true',
  'accept': 'application/json',
  'Authorization': 'No Auth',
  'Content-Type': 'application/json; charset=utf-8',
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'origin, x-requested-with, content-type',
};

class ServicesArticles {

  static const domain = Constants.URL_DOMAIN;
  static const path = Constants.APP_ARTICLES_PATH;

  //получить статьи с ресурса
  static Future <List<Articles>> getArticles() async {
    var uri = Uri.http(domain, path);
    try {
      final response = await http.get(uri, headers: headers);
      if (200 == response.statusCode) {
        final articles = parseArticles(response.body);
        return articles;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  //парсим ответ сервера и передаем в верхнюю функцию
  static List<Articles> parseArticles(String responseBody){
    List<Articles> articles = <Articles>[];
    List<dynamic> d = [];
    d = json.decode(responseBody);
    for(int i=0;i<d.length;i++){
      Map<String, dynamic> map = d[i];
      map.forEach((key, value) { //добавлено это, тест конвертации во время записи в бд
        if(map[key] is String)
        map[key] = Decodetoutf8.removeTags(Decodetoutf8.utf8convert(value.toString()));
      });
      articles.add(Articles.fromMap(map));
    }
    return articles;
  }
}

class ServicesTourarticles {
  static const domain = Constants.URL_DOMAIN;
  static const path = Constants.APP_TOURARTICLES_PATH;

  //получить статьи туристам с ресурса
  static Future <List<Tourarticle>> getTourarticles() async {
    var uri = Uri.http(domain, path);
    try {
      final response = await http.get(uri, headers: headers);
      if (200 == response.statusCode) {
        final tourarticles = parseTourArticles(response.body);
        return tourarticles;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  //парсим ответ сервера и передаем в верхнюю функцию
  static List<Tourarticle> parseTourArticles(String responseBody){
    List<Tourarticle> tourarticles = <Tourarticle>[];
    List<dynamic> d = [];
    d = json.decode(responseBody);
    for(int i=0;i<d.length;i++){
      Map<String, dynamic> map = d[i];
      map.forEach((key, value) {
        if(map[key] is String)
        map[key] = Decodetoutf8.removeTags(Decodetoutf8.utf8convert(value.toString()));
      });
      tourarticles.add(Tourarticle.fromMap(map));
    }
    return tourarticles;
  }
}

class ServicesTourobjects{
  static const domain = Constants.URL_DOMAIN;
  static const path = Constants.APP_TOUROBJECT_PATH;

//  получить туробъекты с ресурса
  static Future<List<Tourobject>> getTourobjects() async {
    var uri = Uri.http(domain, path);
    try{
      final response = await http.get(uri, headers: headers);
      if (200 == response.statusCode){
        final tourobjects = parseTourobjects(response.body);
        return tourobjects;
      } else {
        return [];
      }
    } catch(e){
      return[];
    }
  }

  //парсим ответ сервера и передаем результат в верхнюю функцию
  static List<Tourobject> parseTourobjects(String responseBody){
    List<Tourobject> tourobjects = <Tourobject>[];
    List<dynamic> d = [];
    d = json.decode(responseBody);
    for (int i=0; i<d.length; i++){
      Map<String, dynamic> map = d[i];
      map.forEach((key, value) {
        if (map[key] is String) {
          map[key] = Decodetoutf8.removeTags(
              Decodetoutf8.utf8convert(value.toString()));
        } else if (map[key] is List) {for (var item in value) {
          item.forEach((key2, value2) {
            if (item[key2] is String) {
              item[key2] = Decodetoutf8.removeTags(
                  Decodetoutf8.utf8convert(value2.toString()));
            }
          });
        }
      }
      });
      tourobjects.add(Tourobject.fromMap(map));
    }
    return tourobjects;
  }
}