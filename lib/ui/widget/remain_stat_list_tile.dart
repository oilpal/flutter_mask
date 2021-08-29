import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mask/model/store.dart';
import 'package:url_launcher/url_launcher.dart';

class RemainStatListTile extends StatelessWidget {
  // const RemainStatListTile({Key? key}) : super(key: key);

  final Store? store;

  RemainStatListTile(this.store);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(store?.name ?? 'No title'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(store?.addr ?? 'No Address'),
          Text('${store?.km}km')
        ],
      ),
      trailing: _buildRemainStatWidget(store),
      onTap: () {
        print('tap');
        _launchURL(store?.lat as double, store?.lng as double);
      },
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

    switch (store?.remainStat) {
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
        Text(remainStat,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)
        ),
        Text(description, style: TextStyle(color: color))
      ],
    );
  }

  _launchURL(double lat, double lng) async {
    var _url = 'https://google.com/maps/search/?api=1&query=';
    _url += '$lat,';
    _url += '$lng';
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }
}