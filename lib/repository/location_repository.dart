import 'package:geolocator/geolocator.dart';

class LocationRepository {
  final _geolocator = Geolocator();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Future getCurrentLocation() async {

    Position position = await _geolocatorPlatform.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  }
}