import '../entities/product_list_response.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<ProductListResponse> call({
    required int skip,
    required int limit,
    String? searchQuery,
  }) async {
    return await repository.getProducts(
      skip: skip,
      limit: limit,
      searchQuery: searchQuery,
    );
  }
}
