import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityService {
  Future<bool> hasInternetConnection();
  Stream<bool> get connectivityStream;
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }
}

