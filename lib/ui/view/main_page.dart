import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mask/model/store.dart';
import 'package:flutter_mask/viewmodel/store_model.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storeModel = Provider.of<StoreModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('마스크 재고 있는 곳 : ${storeModel.stores.length}'),
        actions: <Widget>[
          IconButton(onPressed: () {
            storeModel.fetch();
          }, icon: Icon(Icons.refresh))
        ],
      ),
      body: storeModel.isLoading ?
      loadingWidget()
      : ListView(
        children: storeModel.stores
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
