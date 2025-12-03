// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListResponseModel _$ProductListResponseModelFromJson(
  Map<String, dynamic> json,
) => ProductListResponseModel(
  products: (json['products'] as List<dynamic>)
      .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  skip: (json['skip'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$ProductListResponseModelToJson(
  ProductListResponseModel instance,
) => <String, dynamic>{
  'products': instance.products.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'skip': instance.skip,
  'limit': instance.limit,
};
