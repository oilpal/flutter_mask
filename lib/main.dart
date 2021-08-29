import 'package:flutter/material.dart';
import 'package:flutter_mask/model/store.dart';
import 'package:flutter_mask/repository/store_repository.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var stores = List.generate(0, (index) => Store());
  var isLoading = false;

  final storeRepository = StoreRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storeRepository.fetch().then((value) => {
      setState(() {
        stores = value;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('마스크 재고 있는 곳 : ${stores.length}'),
        actions: <Widget>[
          IconButton(onPressed: () {
            storeRepository.fetch().then((value) => {
              setState(() {
                stores = value;
              })
            });
          }, icon: Icon(Icons.refresh))
        ],
      ),
      body: isLoading ? loadingWidget() :
        ListView(
          children: stores
              .where((e) => e?.remainStat == 'plenty' ||
                            e?.remainStat == 'some' ||
                            e?.remainStat == 'few')
              .map((e) {
                return ListTile(title: Text(e?.name ?? 'No title곳'),
                  subtitle: Text(e?.addr ?? 'No address'),
                  trailing: _buildRemainStatWidget(e),
                  );
              }).toList(),
        ),
    );
  }

  Widget _buildRemainStatWidget(Store? store) {
    var remainStat = '판매중지';
    var description = '판매중지';
    var color = Colors.black;

    if (store?.remainStat == 'plenty') {
      remainStat = '충분';
      description = '100개 이상';
      color = Colors.green;
    } else if (store?.remainStat == 'plenty') {
      remainStat = '충분';
      description = '100개 이상';
      color = Colors.green;
    }

    switch(store?.remainStat) {
      case 'plenty':
        remainStat = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some':
        remainStat = '보통';
        description = '30 ~ 100개';
        color = Colors.yellow;
        break;
      case 'few':
        remainStat = '부족';
        description = '2 ~ 30개';
        color = Colors.red;
        break;
      case 'empty':
        remainStat = '소진임박';
        description = '1개 이하';
        color = Colors.grey;
        break;
      default:
        break;
    }

    return Column(
     children: <Widget>[
       Text(remainStat, style: TextStyle(color: color, fontWeight: FontWeight.bold)
       ),
       Text(description, style: TextStyle(color: color))
     ],
    );
  }

  Widget loadingWidget () {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('정보를 가져오는 중'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
