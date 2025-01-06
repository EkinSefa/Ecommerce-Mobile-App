import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<LatLng> markers = [];
  late SharedPreferences prefs;
  final MapController mapController = MapController();

  // Marker bilgilerini saklamak için bir Map kullanalım
  Map<String, Map<String, String>> storeInfo =
      {}; // Store ID'sine bağlı olarak bilgileri tutan map

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  // Markerları SharedPreferences'ten yükle
  _loadMarkers() async {
    prefs = await SharedPreferences.getInstance();
    List<String>? savedMarkers = prefs.getStringList('markers');
    if (savedMarkers != null) {
      setState(() {
        markers = savedMarkers
            .map((e) => LatLng(
                double.parse(e.split(',')[0]), double.parse(e.split(',')[1])))
            .toList();

        // Marker bilgilerini yükleyelim
        for (var i = 1; i < markers.length; i++) {
          storeInfo['store_$i'] = {
            'name': 'Mağaza $i', // Her marker için bir mağaza ismi
            'description': 'Mağaza kunumumuz ' // Marker için bir açıklama
          };
        }
      });
    }
  }

  // Yeni bir marker ekle
  _addMarker(LatLng position) async {
    String storeId = 'store_${markers.length}'; // Yeni mağaza ID'si
    setState(() {
      markers.add(position);
      storeInfo[storeId] = {
        'name': 'Mağaza ${markers.length}', // Mağaza ismi
        'description': ' ${markers.length} .Şübe' // Mağaza açıklaması
      };
    });
    _saveMarkers();
  }

  // Markerları SharedPreferences'e kaydet
  _saveMarkers() async {
    List<String> savedMarkers =
        markers.map((e) => '${e.latitude},${e.longitude}').toList();
    await prefs.setStringList('markers', savedMarkers);
  }

  // Marker sil
  _removeMarker(String storeId) async {
    setState(() {
      LatLng positionToRemove = markers.firstWhere((element) =>
          storeInfo['store_${markers.indexOf(element)}'] == storeInfo[storeId]);
      markers.remove(positionToRemove);
      storeInfo.remove(storeId); // Store ID'yi de silelim
    });
    _saveMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Locations'),
        // Yenileme butonunu kaldırdık
        actions: const [],
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onTap: (tapPosition, point) {
            // Haritaya tıklanınca marker ekleyin
            _addMarker(point);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: markers
                .asMap()
                .map(
                  (index, latLng) {
                    String storeId =
                        'store_$index'; // Her marker için unique store ID
                    return MapEntry(
                      index,
                      Marker(
                        point: latLng,
                        width: 40.0,
                        height: 40.0,
                        child: GestureDetector(
                          onTap: () {
                            _showStoreInfo(
                                storeId); // Marker'a tıklandığında mağaza bilgilerini göster
                          },
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ),
                    );
                  },
                )
                .values
                .toList(),
          ),
        ],
      ),
    );
  }

  // Marker'a tıklandığında mağaza bilgilerini gösteren bir pop-up aç
  void _showStoreInfo(String storeId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Yüksekliği küçültmek için
            children: [
              Text(
                storeInfo[storeId]?['name'] ?? 'Unknown Store',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                storeInfo[storeId]?['description'] ??
                    'No description available.',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Silme işlemi
                  _removeMarker(storeId);
                  Navigator.pop(context); // Pop-up'ı kapat
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }
}
