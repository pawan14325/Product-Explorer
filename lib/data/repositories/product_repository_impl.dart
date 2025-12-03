import '../../core/constants/app_strings.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_list_response.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local/product_local_data_source.dart';
import '../datasources/remote/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  ProductRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.connectivityService,
  );

  @override
  Future<ProductListResponse> getProducts({
    required int skip,
    required int limit,
    String? searchQuery,
  }) async {
    final hasInternet = await connectivityService.hasInternetConnection();
    final cacheKey = searchQuery != null && searchQuery.isNotEmpty
        ? 'products_search_$searchQuery'
        : 'products_$skip';

    if (hasInternet) {
      try {
        final response = await remoteDataSource.getProducts(
          skip: skip,
          limit: limit,
          searchQuery: searchQuery,
        );

        // Cache the response
        await localDataSource.cacheProducts(cacheKey, response);

        return response.toEntity();
      } catch (e) {
        // If local fails, try to get from cache
        final cached = await localDataSource.getCachedProducts(cacheKey);
        if (cached != null) {
          return cached.toEntity();
        }
        rethrow;
      }
    } else {
      // No internet, try to get from cache
      final cached = await localDataSource.getCachedProducts(cacheKey);
      if (cached != null) {
        return cached.toEntity();
      }
      throw Exception(AppStrings.noInternetAndNoCache);
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    final hasInternet = await connectivityService.hasInternetConnection();

    if (hasInternet) {
      try {
        final product = await remoteDataSource.getProductById(id);

        // Cache the product
        await localDataSource.cacheProduct(id, product);

        return product.toEntity();
      } catch (e) {
        // If local fails, try to get from cache
        final cached = await localDataSource.getCachedProduct(id);
        if (cached != null) {
          return cached.toEntity();
        }
        rethrow;
      }
    } else {
      // No internet, try to get from cache
      final cached = await localDataSource.getCachedProduct(id);
      if (cached != null) {
        return cached.toEntity();
      }
      throw Exception(AppStrings.noInternetAndNoCache);
    }
  }
}
