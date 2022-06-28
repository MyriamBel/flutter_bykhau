import 'package:bykhau/Screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bykhau/Models/articles.dart';
import 'package:bykhau/Services/services.dart';
import 'package:bykhau/Services/dbhelper.dart';
import 'package:bykhau/Models/tourarticles.dart';
import 'package:bykhau/Models/tourobjects.dart';
import 'package:bykhau/Services/processing.dart';
import 'package:bykhau/Screens/detail_screen.dart';
import 'package:bykhau/Services/constants.dart';
import 'dart:async';

void main() {
  runApp(
        MyApp()
  );
}

class SplashScreen extends StatefulWidget{
  SplashScreen(): super();

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  List<Tourarticle> tourarticles;
  List<Articles> articles;
  List<Tourobject> tourobjects;
  bool loaded;
  DBHelper dbHelper;
  Processor processor;
  AnimationController _controller;
  Animation _animation;
  double opacityLevel = 0.0;

  @override
  void initState() {
    loaded = false;
    processor = Processor();
    dbHelper = DBHelper();
    void getInfo() async {
      await dbHelper.truncateTable();
      await dbHelper.truncateCategoryTable();
      await dbHelper.truncateEmailsTable();
      await dbHelper.truncateLinksTable();
      await dbHelper.truncatePhonesTable();
      await dbHelper.truncatePhotosTable();
      await dbHelper.truncateRelationsTable();
      await dbHelper.truncateTourarticleTable();
      await dbHelper.truncateTourobjectTable();
      articles = await getArticles();
      tourarticles = await getTourarticles();
      tourobjects = await getTourobjects();
    }
    getInfo();
    loaded = true;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 370),
    )
      ..repeat(reverse: true);

    _animation = Tween(
        begin: opacityLevel, end: opacityLevel + 1.0,
    ).animate(_controller);
    super.initState();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  //получим и сохраним в бд статьи
  getArticles() async {
    ServicesArticles.getArticles().then((allArticles) async{
      articles = allArticles;
      if (articles.isNotEmpty) {
        articles.forEach((element) =>
        {
          dbHelper.truncateTable().then((val) {
            insert(element); //ниже находится функция вставки в бд
          })
        });
      }
      // await dbHelper.articlesCount();
      // await dbHelper.getArticlesFromDB().then((value) => print(value.length));
      return articles;
    });
  }

  getTourarticles() {
    // setState(() {
    //   loaded = false;
    // });
    ServicesTourarticles.getTourarticles().then((tourArticles) {
      tourarticles = tourArticles;
      if (tourarticles.isNotEmpty) {
        tourarticles.forEach((element) {
          dbHelper.truncateTourarticleTable().then((value) {
            insertTourarticle(element);
          });
        });
      }
      // setState(() {
      //   loaded = true;
      // });
      return tourarticles;
    });
  }

  getTourobjects() {
    // setState(() {
    //   loaded = false;
    // });
    ServicesTourobjects.getTourobjects().then((tourObjects) async {
      tourobjects = tourObjects;
      if (tourobjects.isNotEmpty) {
        await Future.wait(tourobjects.map((element) async {
          await processor.proccess_subtourobject(element);
        }));
      }
      return tourobjects;
    });
    //TODO здесь был сетстейт
  }

  //вставка статей в бд
  insert(Articles article) {
    dbHelper.save(article).then((val) {
      return;
    });
  }

  insertTourarticle(Tourarticle tarticl) {
    dbHelper.saveTourarticle(tarticl).then((value) {
      return;
    });
  }

  @override
  Widget build (BuildContext context) {
  return AnimatedSplashScreen.withScreenFunction(
    screenFunction: ()async {
      // return MainStatelessScreen();
      return MainStatelessScreen();
    },
      // splashTransition: SplashTransition.fadeTransition,
      // pageTransitionType: PageTransitionType.fade,
    splash: FadeTransition(
      opacity: _animation,
        child: Image.asset('assets/icons/logo.png')),
    backgroundColor: Colors.white,
      // splash: Icons.file_download,
  );
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  @override
  Widget build(BuildContext context) {
    return StartInheritedWidgetProvider(
      FirstStartRepository(),
      InheritedWidgetProvider(
        DataRepository(),
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black),
            ),
            fontFamily: 'Roboto',
            canvasColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          title: 'Bykhau Tourist',
          home: SafeArea(
            top: true,
            bottom: true,
            // child: MainStatelessScreen(),
            child: SplashScreen(),
          ),
          routes: {
            PagesList.DETAIL_PAGE: (context) => DetailScreen(),
          },
          initialRoute: '/',
        ),
      ),
    );
  }
}

class FirstStartRepository extends ChangeNotifier{
  bool firstStartValue = true;
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

class StartInheritedWidgetProvider extends InheritedWidget{
  final FirstStartRepository startRepository;

  const StartInheritedWidgetProvider(this.startRepository, child): super(child: child);

  @override
  bool updateShouldNotify(StartInheritedWidgetProvider old) {
    return startRepository != old.startRepository;
  }

  static StartInheritedWidgetProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StartInheritedWidgetProvider>();
  }
}

class DataRepository extends ChangeNotifier{
  List<SubTourobject> tourobjects = [];
  DBHelper _dbHelper;
  Map<int, bool> listWidget = {};
  String searchText = "";
  bool ascend = true;

  void sortTourobjects() {
    if (ascend == true) {
      tourobjects.sort((b, a) => a.name.compareTo(b.name));
      ascend = false;
    } else {
      tourobjects.sort((a,b) => a.name.compareTo(b.name));
      ascend = true;
    }
    notifyListeners();
  }

  //получим список категорий
  getCategories() async {
    _dbHelper = DBHelper();
    var listCategory = await _dbHelper.getCategoryFromDB();
    return listCategory.toList();
  }

  //метод выбирает категории и входящие в них туробъекты и перезаписывает ими
  //глобальный список туробъектов
  //входные данные - список id категорий и поисковая строка(с символами или пустая)
  //выходные данные - измененный глобальный список туробъектов
  Future getTourobjects(List indexes) async{
    _dbHelper = DBHelper();
    final _tourobjectsfromdb = await _dbHelper.getTourobjectsByClassIdAndSearchCondition(
        indexes, searchText);
    print(_tourobjectsfromdb.last.toMap());
    tourobjects.clear();
      for(var i in _tourobjectsfromdb)
        tourobjects.add(i);

    notifyListeners();
  }

  //метод проходит по массиву кнопок и ищет активные(выбранные). Если есть,
  //сохраним id кнопки(она же категории) в список и передадим список в
  // функцию-выборщик туробъектов
  void getData() {
    List _indexes = [];
    listWidget.forEach((key, value) {
      if (value == true) {
        _indexes.add(key);
      }
    });
    getTourobjects(_indexes);
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

class InheritedWidgetProvider extends InheritedWidget{
  final DataRepository dataRepository;

  const InheritedWidgetProvider(this.dataRepository, child): super(child: child);

  @override
  bool updateShouldNotify(InheritedWidgetProvider old) {
    return dataRepository != old.dataRepository;
  }

  static InheritedWidgetProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedWidgetProvider>();
  }
}
