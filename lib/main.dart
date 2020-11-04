import 'package:flutter/material.dart';
import 'package:flutter_memory/MemoryMonitorManager.dart';
import 'package:flutter_memory/SecondPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
      routes: {
        // 导航监听的路径
        '/home': (context) => FirstPage(),
        '/second': (context) => SecondTestPage(value: "1234567"),
      },
      navigatorObservers: [
        GLObserver(),
        routeObserver, // 路由监听
      ],
    );
  }
}

class FirstPage extends StatelessWidget {
  FirstPage() {
    MemoryMonitorManager.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FirstPage'),
      ),
      body: SafeArea(
          child: RaisedButton(
              child: Text(" Navigator.push SecondPage"),
              onPressed: () {
                //导航到SecondPage
                Navigator.pushNamed(context, '/second');
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return SecondPage1(
                //     value: "1234567",
                //   );
                // }));
              })),
    );
  }
}

class GLObserver extends NavigatorObserver {
// 添加导航监听后，跳转的时候需要使用Navigator.push路由
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);

    var previousName = '';
    if (previousRoute == null) {
      previousName = 'null';
    } else {
      previousName = previousRoute.settings.name;
    }
    print('NavObserverDidPush-Current:' + route.settings.name + '  Previous:' + previousName);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);

    var previousName = '';
    if (previousRoute == null) {
      previousName = 'null';
    } else {
      previousName = previousRoute.settings.name;
    }
    print('NavObserverDidPop--Current:' + route.settings.name + '  Previous:' + previousName);
  }
}
