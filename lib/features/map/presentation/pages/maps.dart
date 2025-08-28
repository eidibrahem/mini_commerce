import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants.dart';
import '../../../../core/localization/app_strings.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapCtrl = Completer();
  LatLng? _myLatLng;
  bool _loading = true;
  bool _permissionDenied = false;

  /// نصف القطر بالكيلومتر لفلترة المتاجر القريبة
  double _radiusKm = 3;

  /// أمثلة متاجر قريبة (بدّلها ببياناتك لاحقًا)
  final List<_Store> _allStores = const [
    _Store('Alpha Store', LatLng(25.2048, 55.2708)), // Dubai center
    _Store('Beta Mart',  LatLng(25.1972, 55.2744)),
    _Store('Gamma Shop', LatLng(25.2300, 55.3000)),
    _Store('Delta Market',LatLng(25.1800, 55.2600)),
  ];

  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      // 1) خدمة الموقع مُفعّلة؟
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _permissionDenied = true;
          _loading = false;
        });
        return;
      }

      // 2) الصلاحيات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _permissionDenied = true;
          _loading = false;
        });
        return;
      }

      // 3) إحداثيات المستخدم
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _myLatLng = LatLng(pos.latitude, pos.longitude);

      _rebuildMapData();
    } catch (_) {
      setState(() {
        _permissionDenied = true;
        _loading = false;
      });
    }
  }

  void _rebuildMapData() {
    if (_myLatLng == null) return;

    // فلترة المتاجر داخل نصف القطر
    final nearby = _allStores.where((s) {
      final d = _distanceInKm(_myLatLng!, s.position);
      return d <= _radiusKm;
    }).toList();

    // ماركر لموقعي + ماركر للمتاجر
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('me'),
        position: _myLatLng!,
        infoWindow: InfoWindow(
          title: AppStrings.getString(context, 'you_are_here') ?? 'You are here',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
      ...nearby.map((s) => Marker(
            markerId: MarkerId(s.name),
            position: s.position,
            infoWindow: InfoWindow(
              title: s.name,
              snippet: AppStrings.getString(context, 'tap_to_navigate') ?? 'Tap to navigate',
              onTap: () => _openInMaps(s.position, s.name),
            ),
          )),
    };

    // دائرة نصف القطر
    final circles = <Circle>{
      Circle(
        circleId: const CircleId('radius'),
        center: _myLatLng!,
        radius: _radiusKm * 1000, // بالمتر
        strokeWidth: 2,
        strokeColor: AppConstants.primaryColor.withOpacity(0.5),
        fillColor: AppConstants.primaryColor.withOpacity(0.12),
      ),
    };

    setState(() {
      _markers = markers;
      _circles = circles;
      _loading = false;
    });

    _moveCamera(_myLatLng!, zoom: 13.0);
  }

  Future<void> _moveCamera(LatLng target, {double zoom = 14}) async {
    final ctrl = await _mapCtrl.future;
    await ctrl.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: target, zoom: zoom),
    ));
  }

  // هافرسين (أو تقدر تستخدم Geolocator.distanceBetween)
  double _distanceInKm(LatLng a, LatLng b) {
    const earthRadius = 6371.0;
    final dLat = _deg2rad(b.latitude - a.latitude);
    final dLon = _deg2rad(b.longitude - a.longitude);
    final lat1 = _deg2rad(a.latitude);
    final lat2 = _deg2rad(b.latitude);

    final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
    return earthRadius * c;
  }

  double _deg2rad(double deg) => deg * (math.pi / 180);

  Future<void> _openInMaps(LatLng dest, String label) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${dest.latitude},${dest.longitude}'
      '&travelmode=driving&dir_action=navigate',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppStrings.getTextDirection(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.getString(context, 'map') ?? 'Map'),
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : (_permissionDenied || _myLatLng == null)
                ? _PermissionView(onRetry: _initLocation)
                : Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _myLatLng!,
                          zoom: 14,
                        ),
                        onMapCreated: (c) => _mapCtrl.complete(c),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        markers: _markers,
                        circles: _circles,
                        zoomControlsEnabled: false,
                        compassEnabled: true,
                      ),
                      // لوحة التحكم في نصف القطر
                      Positioned(
                        left: 12,
                        right: 12,
                        top: 12,
                        child: Material(
                          color: Colors.white,
                          elevation: 3,
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingMedium,
                              vertical: AppConstants.paddingSmall,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.store, color: Colors.black54),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${AppStrings.getString(context, 'radius') ?? 'Radius'}: '
                                    '${_radiusKm.toStringAsFixed(1)} km',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                IconButton(
                                  tooltip: AppStrings.getString(context, 'increase') ?? 'Increase',
                                  onPressed: () {
                                    setState(() => _radiusKm = (_radiusKm + 1).clamp(1, 20));
                                    _rebuildMapData();
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                IconButton(
                                  tooltip: AppStrings.getString(context, 'decrease') ?? 'Decrease',
                                  onPressed: () {
                                    setState(() => _radiusKm = (_radiusKm - 1).clamp(1, 20));
                                    _rebuildMapData();
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // أزرار سريعة
                      Positioned(
                        right: 12,
                        bottom: 24,
                        child: Column(
                          children: [
                            _RoundBtn(
                              icon: Icons.my_location,
                              tooltip: AppStrings.getString(context, 'center_on_me') ?? 'Center on me',
                              onTap: () => _moveCamera(_myLatLng!, zoom: 15),
                            ),
                            const SizedBox(height: 12),
                            _RoundBtn(
                              icon: Icons.refresh,
                              tooltip: AppStrings.getString(context, 'refresh') ?? 'Refresh',
                              onTap: _rebuildMapData,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _PermissionView extends StatelessWidget {
  final VoidCallback onRetry;
  const _PermissionView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 56, color: Colors.grey),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              AppStrings.getString(context, 'location_permission_denied') ??
                  'Location permission denied or unavailable.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: onRetry,
              child: Text(AppStrings.getString(context, 'try_again') ?? 'Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  const _RoundBtn({required this.icon, required this.onTap, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(blurRadius: 6, spreadRadius: -2, offset: Offset(0, 2))],
          ),
          child: Icon(icon, color: Colors.black87),
        ),
      ),
    );
  }
}

class _Store {
  final String name;
  final LatLng position;
  const _Store(this.name, this.position);
}
