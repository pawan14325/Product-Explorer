import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class AppTextField extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Duration debounceDuration;

  const AppTextField({
    super.key,
    required this.onSearchChanged,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String _previousValue = '';
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final currentValue = _controller.text;
    if (currentValue != _previousValue) {
      _previousValue = currentValue;
      setState(() {}); // Update UI to show/hide clear button
      Future.delayed(widget.debounceDuration, () {
        if (_controller.text == currentValue) {
          widget.onSearchChanged(currentValue);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      key: ValueKey(_controller.text),
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        widget.onSearchChanged('');
                      },
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }
}
