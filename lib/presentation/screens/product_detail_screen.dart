import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/di/injection_container.dart';
import '../viewmodels/product_detail_view_model.dart';
import '../widgets/animated_content_section.dart';
import '../widgets/app_error_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailViewModel _viewModel;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ProductDetailViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadProduct(widget.productId);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.black,
          surfaceTintColor: AppColors.black,
          title: const Text(AppStrings.productDetails),
        ),
        body: Consumer<ProductDetailViewModel>(
          builder: (context, viewModel, child) {
            switch (viewModel.state) {
              case ProductDetailState.initial:
              case ProductDetailState.loading:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: AppColors.white),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.loading,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );

              case ProductDetailState.loaded:
                final product = viewModel.product!;
                return SingleChildScrollView(
                  child: Padding(
                    padding:  EdgeInsets.only(bottom:20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContentSection(
                          delay: 0,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 300,
                                child: PageView.builder(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    viewModel.updateImageIndex(index);
                                  },
                                  itemCount: product.images.length,
                                  itemBuilder: (context, index) {
                                    return Hero(
                                      tag: index == 0
                                          ? 'product_thumbnail_${product.id}'
                                          : 'product_image_${product.id}_$index',
                                      child: CachedNetworkImage(
                                        imageUrl: product.images[index],
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          width: double.infinity,
                                          height: 300,
                                          color: AppColors.imagePlaceholder,
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              width: double.infinity,
                                              height: 300,
                                              color: AppColors.imagePlaceholder,
                                              child: Icon(
                                                Icons.image_not_supported,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (product.images.length > 1)
                                Positioned(
                                  bottom: 16,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      product.images.length,
                                      (index) => AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              viewModel.currentImageIndex == index
                                              ? AppColors.white
                                              : AppColors.white.withValues(
                                                  alpha: 0.4,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        AnimatedContentSection(
                          delay: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (product.brand != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    product.brand!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: AppColors.amber,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${product.rating}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      '(${product.stock} ${AppStrings.inStock})',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                if (product.discountPercentage > 0) ...[
                                  const SizedBox(height: 8),
                                  AnimatedContentSection(
                                    delay: 200,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${product.discountPercentage.toStringAsFixed(1)}% ${AppStrings.off}',
                                        style: const TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        AnimatedContentSection(
                          delay: 200,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  AppStrings.description,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBackground,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.category,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        product.category,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              case ProductDetailState.error:
                return AppErrorWidget(
                  message: viewModel.errorMessage ?? AppStrings.errorOccurred,
                  onRetry: () => viewModel.loadProduct(widget.productId),
                );
            }
          },
        ),
      ),
    );
  }
}
