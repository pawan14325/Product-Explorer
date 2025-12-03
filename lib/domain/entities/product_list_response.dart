import 'package:equatable/equatable.dart';
import 'product.dart';

class ProductListResponse extends Equatable {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  const ProductListResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  @override
  List<Object?> get props => [products, total, skip, limit];
}
