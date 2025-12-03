import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product_list_response.dart';
import 'product_model.dart';

part 'product_list_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductListResponseModel {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  const ProductListResponseModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListResponseModelToJson(this);

  ProductListResponse toEntity() {
    return ProductListResponse(
      products: products.map((p) => p.toEntity()).toList(),
      total: total,
      skip: skip,
      limit: limit,
    );
  }
}
