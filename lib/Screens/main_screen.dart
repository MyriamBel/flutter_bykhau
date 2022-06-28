import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bykhau/Screens/articlesstateful.dart';
import 'package:bykhau/Screens/tourarticlesstateful.dart';
import 'package:bykhau/Screens/tourobjectsstateful.dart';
import 'package:url_launcher/url_launcher.dart';

class MainStatelessScreen extends StatefulWidget {
  @override
  _MainStatelessScreenState createState() => _MainStatelessScreenState();
}

class _MainStatelessScreenState extends State<MainStatelessScreen> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState(){
    tabController = TabController(length: 3, vsync: this,);
    super.initState();
  }

  @override
  void dispose(){
    this.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          title: Text(
            "Быхов Туристический",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Color.fromRGBO(255, 101, 0, 1),
            controller: tabController,
            tabs: [
              Tab(
                text: "Статьи",
              ),
              Tab(
                text: "Туристам",
              ),
              Tab(
                text: "Объекты",
              ),
            ],
            labelColor: Colors.black,
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            Center(
              // child: Text("It's rainy cool"),
              child: ArticlesScreen(),
            ),
            Center(
              // child: Text("It's sunny cool"),
              child: TourarticlesScreen(),
            ),
            Center(
              // child: Text("It's cloudly cool"),
              child: TourobjectsScreen(),
            ),
          ],
        ),
        drawer: _buildDrawer(context),
      ),
    );
  }
}

Widget _buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        _drawerHeader(),
        _drawerList(context),
        _drawerProjectText(),
        _drawerProjectLogo(),
      ],
    ),
  );
}

SizedBox _drawerHeader() {
  return SizedBox(
    height: 85,
    child: DrawerHeader(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
        child: Row(
          children: <Widget>[
            Padding(
                child: Image.asset('assets/icons/logo.png'),
                padding: EdgeInsets.fromLTRB(0, 5, 15, 5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'БЫХОВ',
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'ТУРИСТИЧЕСКИЙ',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFF5722)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Padding _drawerProjectLogo() {
  return Padding(
    padding: EdgeInsets.fromLTRB(15, 0, 15, 25),
    child: Row(
      children: <Widget>[
        Image.asset(
          'assets/icons/es-logo.png',
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Image.asset(
            'assets/icons/minek-logo.png',
          ),
        ),
        Image.asset(
          'assets/icons/undp-logo.png',
        ),
      ],
    ),
  );
}

Padding _drawerProjectText() {
  return Padding(
    padding: EdgeInsets.fromLTRB(0, 40, 15, 20),
    child: ListTile(
        title: Text(
          'Приложение разработано в рамках реализации инициативы «Быхов-инновационный», в рамках проекта «Поддержка экономического развития на местном уровне в Республике Беларусь», который финансируется Европейским союзом (ЕС) и реализуется Программой развития ООН (ПРООН) в партнерстве с Министерством экономики Республики Беларусь.',
          style: TextStyle(
            height: 1.5,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            letterSpacing: 0.32,
            color: Colors.black,
          ),
        )),
  );
}

ListView _drawerList(BuildContext context) {

  return ListView(
    shrinkWrap: true,
    itemExtent: 50.0,
    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
    children: <Widget>[
      GestureDetector(
        onTap: (){
          return showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('О нас'),
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: const Text(
                      ' Быхов – это уникальное место с богатой историей. \n\n'
                      ' Город в Могилевской области, который в старину был одной из сильнейших крепостей Великого Княжества Литовского, а также резиденцией могущественного рода Ходкевичей. \n\n'
                      ' Современный Быхов с честью носит звание защитника и сейчас, как город информационной и кибернетической безопасности. \n\n'
                      ' Все это стало возможным благодаря реализации инициативы по программе ПРООН. \n\n'
                      ' Что дало городу новую жизнь, а быховчанам – новые возможности. \n\n'
                      ' Здесь вы можете увлечься военным баталиями, светскими историями, природой, кухней, памятниками, религией. \n\n'
                      ' Наш туристический портал — информационно-познавательный проект по туризму, посвященный путешествиям по Быхову и Быховскому району. \n\n'
                      ' Наша деятельность направлена на создание единого информационного ресурса в сфере туризма, предоставляющего доступную и полную информацию о туристических возможностях города. \n\n'
                      ' Мы знакомим читателя с районными достопримечательностями, которые включают в себя объекты историко-культурного наследия, природные памятники и заповедные зоны, традиционные ремесла, а также с объектами малого бизнеса. \n\n'
                      ' Мы публикуем популярные туристические маршруты, познавательные статьи, анонсы мероприятий, происходящие в Быховском районе, рассказываем о самобытности региона, создаем спецпроекты, посвященные туристическим направлениям. \n\n'
                      ' На нашем портале вы можете построить свой уникальный маршрут, узнать о достопримечательностях поблизости, а также предложить свой контент или дать обратную связь.'
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('Назад'),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(255, 101, 0, 1)
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
            child: ListTile(
              leading: Image.asset(
                'assets/icons/InfoSquare.png',
                width: 20.0,
                height: 20.0,
              ),
              title: Text(
                'О нас',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
      GestureDetector(
        onTap: (){
          return Utils().openEmail(
            toEmail: 'bykhautour@gmail.com',
            subject: 'Быхов туристический - обратная связь',
            body: 'Введите Ваше сообщение',
            context: context
          );
        },
        child: ListTile(
          leading: Icon(
            Icons.mail_rounded,
            color: Color(0xFFC0C3C7),
            size: 20.0,
          ),
          title: Text(
            'Напишите нам',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
      //TODO: Это пока уберем, добавим в следующей версии приложения
      // ListTile(
      //   leading: Icon(
      //     Icons.settings,
      //     color: Color(0xFFC0C3C7),
      //     size: 20.0,
      //   ),
      //   title: Text(
      //     'Язык',
      //     style: TextStyle(
      //       fontSize: 14,
      //       fontFamily: 'Roboto',
      //       fontWeight: FontWeight.w500,
      //       color: Colors.black,
      //     ),
      //   ),
      // ),
    ],
  );
}

class Utils {
  BuildContext context;

  Future _launchUrl(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
    else {
      return showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              title: Text("Ошибка!"),
              content: Text("Почтовое приложение по умолчанию не найдено"),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(255, 101, 0, 1)
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ок"),
                ),
              ],
            ),
      );
    }
  }

  Future openEmail({
    @required String toEmail,
    @required String subject,
    @required String body,
    @required context
  }) async {
    String url = 'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
    await _launchUrl(url, context);
  }
}