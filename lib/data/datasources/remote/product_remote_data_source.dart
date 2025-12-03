import 'package:dio/dio.dart';
import '../../../core/constants/app_endpoints.dart';
import '../../../core/constants/app_strings.dart';
import '../../models/product_list_response_model.dart';
import '../../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductListResponseModel> getProducts({
    required int skip,
    required int limit,
    String? searchQuery,
  });

  Future<ProductModel> getProductById(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<ProductListResponseModel> getProducts({
    required int skip,
    required int limit,
    String? searchQuery,
  }) async {
    try {
      final String url;

      if (searchQuery != null && searchQuery.isNotEmpty) {
        url = AppEndpoints.searchProducts(searchQuery);
      } else {
        url = AppEndpoints.getProducts(skip: skip, limit: limit);
      }

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return ProductListResponseModel.fromJson(response.data);
      } else {
        throw Exception(
          '${AppStrings.failedToLoadProducts}: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(AppStrings.connectionTimeout);
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception('${AppStrings.serverError}: ${e.response?.statusCode}');
      } else {
        throw Exception('${AppStrings.networkError}: ${e.message}');
      }
    } catch (e) {
      throw Exception('${AppStrings.unexpectedError}: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await dio.get(AppEndpoints.productById(id));

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw Exception(
          '${AppStrings.failedToLoadProduct}: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(AppStrings.connectionTimeout);
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception('${AppStrings.serverError}: ${e.response?.statusCode}');
      } else {
        throw Exception('${AppStrings.networkError}: ${e.message}');
      }
    } catch (e) {
      throw Exception('${AppStrings.unexpectedError}: $e');
    }
  }
}
