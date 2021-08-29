import 'package:flutter_mask/model/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoreRepository {

  Future<List<Store>> fetch() async {

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

    var response = await http.get(url);
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
        stores.add(Store.fromJson(e));
      });
      // isLoading = false;
    // });

    print('fetch 완료');

    return stores;
  }
}