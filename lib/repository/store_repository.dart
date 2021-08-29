import 'dart:math';

import 'package:flutter_mask/model/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoreRepository {

  String calcDistance(
      double lat1, double lon1, double lat2, double lon2, String unit) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    if (unit == 'K') {
      dist = dist * 1.609344;
    } else if (unit == 'N') {
      dist = dist * 0.8684;
    }
    return dist.toStringAsFixed(2);
  }

  double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  double rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }

  Future<List<Store>> fetch(double latitude, double longitude) async {

    final stores = List.generate(0, (index) => Store());

    // setState(() {
    //   isLoading = true;
    // });

    // var url = Uri.parse('https://example.com/whatsit/create');
    // var response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    //
    // print(await http.read('https://example.com/foobar.txt'));

    var url = Uri.parse('https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json');

    var response = await http.get(url).timeout(
      // 5초 타임아웃.
      Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 500);
      }
    );

    if(response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      // print('Response data: ${response.body}');
      // print('Response data: ${utf8.decode(response.bodyBytes)}');
      // print('Response data: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      final jsonResult = jsonDecode(utf8.decode(response.bodyBytes));
      // print(jsonResult['stores']);

      final jsonStores = jsonResult['stores'];

      // setState(() {
      //   stores.clear();
      jsonStores.forEach((e) {
        final store = Store.fromJson(e);
        final String km = calcDistance(store.lat as double, store.lng as double,
            latitude as double, longitude as double, 'K');
        // _distance.as(LengthUnit.Kilometer,
        //     LatLng(store.lat as double, store.lng as double),
        //     LatLng(latitude as double, longitude as double));

        store.km = num.parse(km);
        stores.add(store);
      });
      // isLoading = false;
      // });

      print('fetch 완료');

      return stores.where((e) {
        return e?.remainStat == 'plenty' ||
            e?.remainStat == 'some' ||
            e?.remainStat == 'few';
      }).toList()
        ..sort((a, b) => a.km!.compareTo(b.km ?? 0.0));
    }
    else {
      return [];
    }
  }
}