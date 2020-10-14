import 'package:flutter/material.dart';
import 'package:flutter_memory/MemoryMonitorManager.dart';
import 'package:flutter_memory/SecondPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
    );
  }
}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final wordPair = new WordPair.random();
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(wordPair.asPascalCase),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//
//  @override
//  void initState() {
//    /// 初始化状态，加载用户信息
//    print("initState:${new DateTime.now()}");
//    _loadUserInfo();
//    print("initState:${new DateTime.now()}");
//    super.initState();
//  }
//
//  Future _getUserInfo() async {
//    await new Future.delayed(new Duration(milliseconds: 3000));
//    return "我是用户";
//  }
//
//  /// 加载用户信息，顺便打印时间看看顺序
//  Future _loadUserInfo() async {
//    print("_loadUserInfo:${new DateTime.now()}");
//    print(await _getUserInfo());
//    print("_loadUserInfo:${new DateTime.now()}");
//  }
//}

class FirstPage extends StatelessWidget {
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SecondPage(
                    value: "1234567",
                  );
                }));
              })),
    );
  }

  void memoryTest() {
    Expando<String> expando = Expando();
    Widget target = Text("TEST");
    expando[target] = "Test";
    MemoryMonitorManager memoryMonitorManager = MemoryMonitorManager();
    memoryMonitorManager.init();
    memoryMonitorManager.processObject(expando);
  }
}
