import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GetLocationScreen extends StatefulWidget {
  const GetLocationScreen({super.key});

  @override
  State<GetLocationScreen> createState() => _GetLocationScreenState();
}

class _GetLocationScreenState extends State<GetLocationScreen> {
  String latitude = '';
  String longitude = '';
  String address = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint(permission.toString());

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint(permission.toString());
        if (permission == LocationPermission.denied) {
          setState(() {
            isLoading = false;
            address = 'Permission denied!';
          });
        }
      }

      // If permission is denied forever, then open setting
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          isLoading = false;
          address = 'Permission denied forever. Please enable from setting';
        });
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      debugPrint(placemarks[0].toString());

      Placemark placemark = placemarks[0];
      setState(() {
        isLoading = false;
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        address =
            '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
      });

      debugPrint('Latitude: $latitude\nLongitude: $longitude');
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoLocator and GeoCode'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Data Geo Locator',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Latitude: $latitude\nLongitude: $longitude',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(address),
                ],
              ),
      ),
    );
  }
}
