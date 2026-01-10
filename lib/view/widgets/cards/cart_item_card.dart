import 'package:flutter/material.dart';
import '../../../const/constants.dart';
import '../../../services/cart_service.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey.shade200,
                child: product.images.isNotEmpty
                    ? product.images.first.url.startsWith('assets/')
                        ? Image.asset(
                            product.images.first.url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  color: Colors.grey);
                            },
                          )
                        : Image.network(
                            product.images.first.url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  color: Colors.grey);
                            },
                          )
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            // Informations
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.size} • ${product.color}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.hasDiscount)
                            Text(
                              '${product.price.toStringAsFixed(2)} DT',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            '${product.displayPrice.toStringAsFixed(2)} DT',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      // Bouton supprimer
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: onRemove,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Quantité
                  Row(
                    children: [
                      const Text(
                        'Qté: ',
                        style: TextStyle(fontSize: 13),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: item.quantity > 1
                                  ? () => onQuantityChanged(item.quantity - 1)
                                  : null,
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                item.quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: item.quantity < product.stockQuantity
                                  ? () => onQuantityChanged(item.quantity + 1)
                                  : null,
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          'Total: ${item.totalPrice.toStringAsFixed(2)} DT',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

