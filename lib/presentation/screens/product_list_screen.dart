import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/di/injection_container.dart';
import '../../core/utils/page_transitions.dart';
import '../viewmodels/product_list_view_model.dart';
import '../widgets/animated_product_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_error_widget.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  late final ProductListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ProductListViewModel>();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadProducts();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.8;

    if (currentScroll >= threshold && maxScroll > 0) {
      if (_viewModel.hasMore &&
          _viewModel.state != ProductListState.loadingMore &&
          _viewModel.state != ProductListState.loading) {
        _viewModel.loadMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Consumer<ProductListViewModel>(
          builder: (context, viewModel, child) {
            return RefreshIndicator(
              displacement: 180,
              onRefresh: () async {
                await viewModel.loadProducts(isRefresh: true);
              },
              color: AppColors.white,
              backgroundColor: AppColors.cardBackground,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.black,
                    surfaceTintColor: AppColors.black,
                    pinned: true,
                    expandedHeight: 140,
                    floating: false,
                    title: Text(
                      AppStrings.appName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: AppTextField(
                          onSearchChanged: (query) {
                            viewModel.searchProducts(query);
                          },
                        ),
                      ),
                    ),
                  ),
                  _buildSliverBody(viewModel),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverBody(ProductListViewModel viewModel) {
    switch (viewModel.state) {
      case ProductListState.initial:
      case ProductListState.loading:
        return SliverFillRemaining(
          child: Center(
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
          ),
        );

      case ProductListState.loadingMore:
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index < viewModel.products.length) {
              final product = viewModel.products[index];
              return AnimatedProductCard(
                product: product,
                index: index,
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransitions.slideRoute(
                      ProductDetailScreen(productId: product.id),
                    ),
                  );
                },
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.white),
                ),
              );
            }
          }, childCount: viewModel.products.length + 1),
        );

      case ProductListState.loaded:
        if (viewModel.products.isEmpty) {
          return SliverFillRemaining(
            child: Center(child: Text(AppStrings.noProductsFound)),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < viewModel.products.length) {
                final product = viewModel.products[index];
                return AnimatedProductCard(
                  product: product,
                  index: index,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransitions.slideRoute(
                        ProductDetailScreen(productId: product.id),
                      ),
                    );
                  },
                );
              } else if (viewModel.hasMore) {
                // Trigger load more when reaching the end
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  viewModel.loadMore();
                });
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            childCount: viewModel.hasMore
                ? viewModel.products.length + 1
                : viewModel.products.length,
          ),
        );

      case ProductListState.error:
        return SliverFillRemaining(
          child: AppErrorWidget(
            message: viewModel.errorMessage ?? AppStrings.errorOccurred,
            onRetry: () => viewModel.loadProducts(isRefresh: true),
          ),
        );
    }
  }
}
