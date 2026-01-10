import 'package:flutter/material.dart';
import '../../const/constants.dart';
import '../../models/product.dart';
import '../../services/cart_service.dart';
import '../widgets/navigation/image_nav_button.dart';
import '../widgets/chips/info_chip.dart';
import '../widgets/buttons/quantity_button.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  int currentImageIndex = 0;
  final CartService _cartService = CartService();
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product.images.isNotEmpty
        ? product.images
        : [
            ProductImage(
              id: 0,
              url: '',
              productId: product.id,
            ),
          ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Image principale
                  Container(
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: images.isNotEmpty && images[currentImageIndex].url.isNotEmpty
                        ? images[currentImageIndex].url.startsWith('assets/')
                            ? Image.asset(
                                images[currentImageIndex].url,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : Image.network(
                                images[currentImageIndex].url,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                        : const Icon(Icons.image, size: 80, color: Colors.grey),
                  ),
                  // Badge de réduction
                  if (product.hasDiscount)
                    Positioned(
                      top: 60,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '-${product.discount}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Navigation entre images
                  if (images.length > 1)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ImageNavButton(
                            icon: Icons.chevron_left,
                            onPressed: currentImageIndex > 0
                                ? () {
                                    setState(() {
                                      currentImageIndex--;
                                    });
                                  }
                                : null,
                          ),
                          // Miniatures
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentImageIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: currentImageIndex == index ? 40 : 30,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: currentImageIndex == index
                                            ? AppColors.primaryColor
                                            : Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: images[index].url.isNotEmpty
                                          ? images[index].url.startsWith('assets/')
                                              ? Image.asset(
                                                  images[index].url,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey.shade300,
                                                      child: const Icon(
                                                        Icons.image,
                                                        size: 20,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Image.network(
                                                  images[index].url,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey.shade300,
                                                      child: const Icon(
                                                        Icons.image,
                                                        size: 20,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                                )
                                          : const Icon(Icons.image, size: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ImageNavButton(
                            icon: Icons.chevron_right,
                            onPressed: currentImageIndex < images.length - 1
                                ? () {
                                    setState(() {
                                      currentImageIndex++;
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Contenu
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Description
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Informations produit
                    Row(
                      children: [
                        InfoChip(
                          icon: Icons.category,
                          label: product.categoryName,
                        ),
                        const SizedBox(width: 10),
                        InfoChip(
                          icon: Icons.palette,
                          label: product.color,
                        ),
                        const SizedBox(width: 10),
                        InfoChip(
                          icon: Icons.straighten,
                          label: product.size,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Rating
                    if (product.rating != null)
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (index) => Icon(
                              index < product.rating!.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            product.rating!.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 30),
                    // Prix
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.hasDiscount)
                                Text(
                                  '${product.price.toStringAsFixed(2)} DT',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Text(
                                '${product.displayPrice.toStringAsFixed(2)} DT',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              if (product.hasDiscount)
                                Text(
                                  'Économisez ${(product.price - product.displayPrice).toStringAsFixed(2)} DT',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                          if (product.stockQuantity > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.green.shade300),
                              ),
                              child: Text(
                                'En stock',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.red.shade300),
                              ),
                              child: Text(
                                'Rupture de stock',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Quantité
                    Text(
                      'Quantité',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        QuantityButton(
                          icon: Icons.remove,
                          onPressed: quantity > 1
                              ? () {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              : null,
                        ),
                        Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            quantity.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        QuantityButton(
                          icon: Icons.add,
                          onPressed: quantity < product.stockQuantity
                              ? () {
                                  setState(() {
                                    quantity++;
                                  });
                                }
                              : null,
                        ),
                        const Spacer(),
                        Text(
                          'Stock: ${product.stockQuantity}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Bouton ajouter au panier
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: product.stockQuantity > 0 && !_isAddingToCart
                            ? () async {
                                setState(() {
                                  _isAddingToCart = true;
                                });
                                await Future.delayed(const Duration(milliseconds: 300));
                                _cartService.addToCart(product, quantity: quantity);
                                if (!mounted) return;
                                final messenger = ScaffoldMessenger.of(context);
                                messenger.showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.check_circle, color: Colors.white),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              '${product.name} ajouté au panier (x$quantity)',
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                setState(() {
                                  _isAddingToCart = false;
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: _isAddingToCart
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.shopping_cart, size: 24),
                                  SizedBox(width: 12),
                                  Text(
                                    'Ajouter au panier',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

