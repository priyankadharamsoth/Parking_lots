import 'package:geolocator/geolocator.dart';

class GeoLocatorService {
  static Future<Position> getLocation() async {
    var geolocator = Geolocator();
    return await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        locationPermissionLevel: GeolocationPermission.location);
  }
}
