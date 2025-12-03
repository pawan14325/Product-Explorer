import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local/product_local_data_source.dart';
import '../../data/datasources/remote/product_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/use_cases/get_product_by_id_use_case.dart';
import '../../domain/use_cases/get_products_use_case.dart';
import '../../presentation/viewmodels/product_detail_view_model.dart';
import '../../presentation/viewmodels/product_list_view_model.dart';
import '../constants/app_endpoints.dart';
import '../services/cache_service.dart';
import '../services/connectivity_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Dio setup
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options = BaseOptions(
      baseUrl: AppEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    );

    // Add Pretty Dio Logger only in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    return dio;
  });

  // Services
  getIt.registerLazySingleton<CacheService>(
    () => CacheServiceImpl(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(),
  );

  // Data sources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(getIt<CacheService>()),
  );

  // Repository
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      getIt<ProductRemoteDataSource>(),
      getIt<ProductLocalDataSource>(),
      getIt<ConnectivityService>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt<ProductRepository>()),
  );
  getIt.registerLazySingleton<GetProductByIdUseCase>(
    () => GetProductByIdUseCase(getIt<ProductRepository>()),
  );

  // ViewModels
  getIt.registerFactory<ProductListViewModel>(
    () => ProductListViewModel(getIt<GetProductsUseCase>()),
  );
  getIt.registerFactory<ProductDetailViewModel>(
    () => ProductDetailViewModel(getIt<GetProductByIdUseCase>()),
  );
}
