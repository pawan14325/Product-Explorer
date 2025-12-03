import 'dart:convert';
import '../../../core/services/cache_service.dart';
import '../../models/product_list_response_model.dart';
import '../../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(String key, ProductListResponseModel products);
  Future<ProductListResponseModel?> getCachedProducts(String key);
  Future<void> cacheProduct(int id, ProductModel product);
  Future<ProductModel?> getCachedProduct(int id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final CacheService cacheService;

  ProductLocalDataSourceImpl(this.cacheService);

  @override
  Future<void> cacheProducts(
    String key,
    ProductListResponseModel products,
  ) async {
    final jsonString = jsonEncode(products.toJson());
    await cacheService.saveProducts(key, jsonString);
  }

  @override
  Future<ProductListResponseModel?> getCachedProducts(String key) async {
    final jsonString = await cacheService.getProducts(key);
    if (jsonString != null) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ProductListResponseModel.fromJson(json);
    }
    return null;
  }

  @override
  Future<void> cacheProduct(int id, ProductModel product) async {
    final jsonString = jsonEncode(product.toJson());
    await cacheService.saveProducts('product_$id', jsonString);
  }

  @override
  Future<ProductModel?> getCachedProduct(int id) async {
    final jsonString = await cacheService.getProducts('product_$id');
    if (jsonString != null) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ProductModel.fromJson(json);
    }
    return null;
  }
}
