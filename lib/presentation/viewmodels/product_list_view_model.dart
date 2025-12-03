import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/use_cases/get_products_use_case.dart';

enum ProductListState { initial, loading, loaded, error, loadingMore }

class ProductListViewModel extends ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;

  ProductListViewModel(this.getProductsUseCase);

  ProductListState _state = ProductListState.initial;
  List<Product> _products = [];
  String? _errorMessage;
  bool _hasMore = true;
  int _currentSkip = 0;
  final int _limit = 10;
  String? _searchQuery;
  bool _isLoadingMore = false;

  ProductListState get state => _state;
  List<Product> get products => _products;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  String? get searchQuery => _searchQuery;

  Future<void> loadProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentSkip = 0;
      _products = [];
      _hasMore = true;
      _isLoadingMore = false;
    }

    if (!_hasMore && !isRefresh) return;
    if (_isLoadingMore && !isRefresh) return;

    try {
      if (_currentSkip == 0) {
        _state = ProductListState.loading;
      } else {
        _state = ProductListState.loadingMore;
        _isLoadingMore = true;
      }
      notifyListeners();

      final response = await getProductsUseCase(
        skip: _currentSkip,
        limit: _limit,
        searchQuery: _searchQuery,
      );

      if (isRefresh) {
        _products = response.products;
      } else {
        _products.addAll(response.products);
      }

      _currentSkip = _products.length;
      _hasMore = _products.length < response.total;

      _state = ProductListState.loaded;
      _isLoadingMore = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _state = ProductListState.error;
      _isLoadingMore = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    _searchQuery = query.isEmpty ? null : query;
    _currentSkip = 0;
    _products = [];
    _hasMore = true;
    loadProducts(isRefresh: true);
  }

  void loadMore() {
    if (_hasMore &&
        !_isLoadingMore &&
        _state != ProductListState.loadingMore &&
        _state != ProductListState.loading) {
      loadProducts();
    }
  }
}
