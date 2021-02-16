import 'dart:async';
import 'package:sqflite/sqflite.dart';

final String tableTodo = 'count_table';
final String columnId = '_id';
final String columnCount = 'count';

class CountObject {
  int id;
  int count;

  CountObject();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCount: count,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  CountObject.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    count = map[columnCount];
  }
}

class CounterStorage {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
            create table $tableTodo ( 
              $columnId integer primary key autoincrement, 
              $columnCount integer not null)
            ''');
    });
  }

  Future<CountObject> getCount(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnCount],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return CountObject.fromMap(maps.first);
    }
    return null;
  }

  Future<CountObject> insert(CountObject countInstance) async {
    countInstance.id = await db.insert(tableTodo, countInstance.toMap());
    return countInstance;
  }

  Future<int> update(CountObject countInstance) async {
    return await db.update(tableTodo, countInstance.toMap(),
        where: '$columnId = ?', whereArgs: [countInstance.id]);
  }

  Future close() async => db.close();


  Future<bool> writeCounter(int counter, int id) async {
    await open("mydata.db");
    CountObject co = new CountObject();
    co.count=counter;
    co.id = id;
    await update(co);
    await close();
    return true;
  }

  Future<int> readCounter(int id) async {
    await open("mydata.db");
    CountObject co = await getCount(id);
    if(co==null){
      co = new CountObject();
      co.count=0;
      co = await insert(co);
    }
    await close();
    return co.count;
  }
}
