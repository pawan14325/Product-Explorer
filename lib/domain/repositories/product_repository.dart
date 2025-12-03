import '../entities/product.dart';
import '../entities/product_list_response.dart';

abstract class ProductRepository {
  Future<ProductListResponse> getProducts({
    required int skip,
    required int limit,
    String? searchQuery,
  });

  Future<Product> getProductById(int id);
}
