import 'package:flutter/material.dart';

class ProductRatingWidget extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showRating;

  const ProductRatingWidget({
    super.key,
    required this.rating,
    this.size = 20.0,
    this.color,
    this.showRating = false,
  });

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? Colors.amber;
    final fullStars = rating.floor();
    final hasHalfStar = rating - fullStars >= 0.5;
    final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Full stars
        ...List.generate(
          fullStars,
          (index) => _buildStar(starColor, true, false),
        ),

        // Half star
        if (hasHalfStar) _buildStar(starColor, false, true),

        // Empty stars
        ...List.generate(
          emptyStars,
          (index) => _buildStar(starColor, false, false),
        ),

        // Show rating number if requested
        if (showRating) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.6,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStar(Color color, bool isFull, bool isHalf) {
    return Icon(
      isFull ? Icons.star : (isHalf ? Icons.star_half : Icons.star_border),
      color: color,
      size: size,
    );
  }
}

class AnimatedRatingWidget extends StatefulWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showRating;
  final Duration duration;

  const AnimatedRatingWidget({
    super.key,
    required this.rating,
    this.size = 20.0,
    this.color,
    this.showRating = false,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedRatingWidget> createState() => _AnimatedRatingWidgetState();
}

class _AnimatedRatingWidgetState extends State<AnimatedRatingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.rating,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ProductRatingWidget(
          rating: _animation.value,
          size: widget.size,
          color: widget.color,
          showRating: widget.showRating,
        );
      },
    );
  }
}
