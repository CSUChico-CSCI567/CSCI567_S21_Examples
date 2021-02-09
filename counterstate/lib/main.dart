import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // int _counter;
  int _counter = -1;



  void getCount() async{
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });

  }

  @override
  void initState() {
    super.initState();
    getCount();
  }

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;
    bool success = await prefs.setInt("counter", counter);
    if(success){
      setState(() {
        _counter = counter;
      });
    }
  }

  Future<void> _decrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) - 1;
    bool success = await prefs.setInt("counter", counter);
    if(success){
      setState(() {
        _counter = counter;
      });
    }
  }


  // void _incrementCounter() {
  //   setState(add);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _counter==-1 ? CircularProgressIndicator():Column(
              children: [
                Text('Like Count:'),
                Text('$_counter'),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed:
                            _counter <= 0 ? null : _decrementCounter,
                        child: Text("-")),
                    // ElevatedButton(
                    //     onPressed: _counter >= 10 ? null : _incrementCounter,
                    //     child: Icon(
                    //       Icons.favorite,
                    //       color: _counter < 10? Colors.red: Colors.grey
                    //     ),
                    //     ),
                    IconButton(
                      onPressed: _counter >= 10 ? null : _incrementCounter,
                        icon: Icon(
                          Icons.favorite,
                          color: _counter < 10? Colors.red: Colors.grey
                        ),
                      )
                  ],
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _counter >= 10 ? null : _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
