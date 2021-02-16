import 'package:counterstate/storage.dart';
import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Flutter Demo', storage: CounterStorage()),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title, this.storage}) : super(key: key);

  final String title;
  final CounterStorage storage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = -1;
  int _counter2 = -1;

  void getCount() async{
    int counter = await widget.storage.readCounter(1);
    int counter2 = await widget.storage.readCounter(2);
    setState(() {
      _counter = counter;
      _counter2 = counter2;
    });
  }

  @override
  void initState() {
    super.initState();
    getCount();
  }


  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    widget.storage.writeCounter(_counter, 1);
  }

  Future<void> _incrementCounter2() async {
    setState(() {
      _counter2++;
    });
    widget.storage.writeCounter(_counter2, 2);
  }

  Future<void> _decrementCounter() async {
    setState(() {
      _counter--;
    });
    widget.storage.writeCounter(_counter, 1);
  }
  Future<void> _decrementCounter2() async {
    setState(() {
      _counter2--;
    });
    widget.storage.writeCounter(_counter2, 2);
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
            _counter2==-1 ? CircularProgressIndicator():Column(
              children: [
                Text('Like Count 2:'),
                Text('$_counter2'),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed:
                        _counter2 <= 0 ? null : _decrementCounter2,
                        child: Text("-")),
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
                      ),
                    IconButton(
                      onPressed: _counter2 >= 10 ? null : _incrementCounter2,
                      icon: Icon(
                          Icons.favorite,
                          color: _counter2 < 10? Colors.red: Colors.grey
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
