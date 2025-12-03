class AppEndpoints {
  AppEndpoints._();

  // Base URL
  static const String baseUrl = 'https://dummyjson.com';

  // Products
  static const String products = '/products';
  static const String productsSearch = '/products/search';
  static String productById(int id) => '/products/$id';
  static const String productsCategoryList = '/products/category-list';

  // Helper methods
  static String getProducts({int? skip, int? limit}) {
    if (skip != null && limit != null) {
      return '$products?skip=$skip&limit=$limit';
    }
    return products;
  }

  static String searchProducts(String query) {
    return '$productsSearch?q=${Uri.encodeComponent(query)}';
  }
}
