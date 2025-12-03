import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/use_cases/get_product_by_id_use_case.dart';

enum ProductDetailState { initial, loading, loaded, error }

class ProductDetailViewModel extends ChangeNotifier {
  final GetProductByIdUseCase getProductByIdUseCase;

  ProductDetailViewModel(this.getProductByIdUseCase);

  ProductDetailState _state = ProductDetailState.initial;
  Product? _product;
  String? _errorMessage;
  int _currentImageIndex = 0;

  ProductDetailState get state => _state;
  Product? get product => _product;
  String? get errorMessage => _errorMessage;
  int get currentImageIndex => _currentImageIndex;

  Future<void> loadProduct(int id) async {
    try {
      _state = ProductDetailState.loading;
      _errorMessage = null;
      _currentImageIndex = 0;
      notifyListeners();

      _product = await getProductByIdUseCase(id);

      _state = ProductDetailState.loaded;
      notifyListeners();
    } catch (e) {
      _state = ProductDetailState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void updateImageIndex(int index) {
    _currentImageIndex = index;
    notifyListeners();
  }
}
