import 'package:flutter/material.dart';
import '../../const/constants.dart';
import '../../models/product.dart';
import '../../models/category.dart';
import '../../services/cart_service.dart';
import '../widgets/cards/product_card.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Category> categories = [];
  List<Product> products = [];
  bool isLoading = true;
  String selectedCategory = 'Tous';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() {
    
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        categories = _getDemoCategories();
        products = _getDemoProducts();
        isLoading = false;
      });
    });
  }

  List<Category> _getDemoCategories() {
    return [
      Category(id: 1, name: 'Tous', productCount: 12),
      Category(id: 2, name: 'Homme', productCount: 5),
      Category(id: 3, name: 'Femme', productCount: 4),
      Category(id: 4, name: 'Mixte', productCount: 3),
    ];
  }

  
  String _getProductImagePath(int productId, String categoryName) {
    
    switch (productId) {
      case 1:
        return 'assets/images/products/categorieFemmeProduit1.jpg';
      case 2:
        return 'assets/images/products/categorieFemmeProduit1.jpg';
      case 3:
        return 'assets/images/products/categoriehommeProduit1.jpg';
      case 4:
        return 'assets/images/products/categorieMixteProduit1.jpg';
      case 5:
        return 'assets/images/products/categoriehommeProduit2.jpg';
      case 6:
        return 'assets/images/products/categorieFemmeProduit1.jpg';
      default:
        
        if (categoryName == 'Femme') {
          return 'assets/images/products/categorieFemmeProduit1.jpg';
        } else if (categoryName == 'Homme') {
          return 'assets/images/products/categoriehommeProduit1.jpg';
        } else if (categoryName == 'Mixte') {
          return 'assets/images/products/categorieMixteProduit1.jpg';
        }
        return 'assets/images/products/categorieMixteProduit1.jpg';
    }
  }

  List<Product> _getDemoProducts() {
    return [
      Product(
        id: 1,
        name: 'Tenue médicale bleue',
        description: 'Ensemble médical confortable et respirant, composé d\'un haut à manches courtes et d\'un pantalon',
        price: 95.0,
        finalPrice: 85.5,
        size: 'M',
        color: 'Bleu',
        stockQuantity: 50,
        categoryId: 3,
        categoryName: 'Femme',
        discount: 10,
        discountActive: true,
        images: [
          ProductImage(id: 1, url: _getProductImagePath(1, 'Femme'), productId: 1),
        ],
        rating: 4.0,
      ),
      Product(
        id: 2,
        name: 'Tenue médicale rose femme (haut + pantalon)',
        description: 'Ensemble médical moderne et élégant, conçu spécialement pour les étudiantes',
        price: 110.0,
        finalPrice: 93.5,
        size: 'S',
        color: 'Rose',
        stockQuantity: 30,
        categoryId: 3,
        categoryName: 'Femme',
        discount: 15,
        discountActive: true,
        images: [
          ProductImage(id: 2, url: _getProductImagePath(2, 'Femme'), productId: 2),
        ],
        rating: 4.5,
      ),
      Product(
        id: 3,
        name: 'Tenue médicale noire homme',
        description: 'Ensemble médical noir élégant et moderne, spécialement conçu pour les professionnels',
        price: 100.0,
        size: 'L',
        color: 'Noir',
        stockQuantity: 40,
        categoryId: 2,
        categoryName: 'Homme',
        discount: null,
        discountActive: false,
        images: [
          ProductImage(id: 3, url: _getProductImagePath(3, 'Homme'), productId: 3),
        ],
        rating: 3.0,
      ),
      Product(
        id: 4,
        name: 'Sabots médicaux "Love & Butterfly"',
        description: 'Sabots médicaux confortables en matière légère et résistante, spécialement conçus pour les longues journées',
        price: 45.0,
        size: '40',
        color: 'Rose',
        stockQuantity: 25,
        categoryId: 4,
        categoryName: 'Mixte',
        discount: null,
        discountActive: false,
        images: [
          ProductImage(id: 4, url: _getProductImagePath(4, 'Mixte'), productId: 4),
        ],
        rating: 3.5,
      ),
      Product(
        id: 5,
        name: 'Tenue médicale verte',
        description: 'Ensemble médical vert foncé, résistant et facile à entretenir',
        price: 90.0,
        size: 'M',
        color: 'Vert',
        stockQuantity: 35,
        categoryId: 2,
        categoryName: 'Homme',
        discount: 5,
        discountActive: true,
        images: [
          ProductImage(id: 5, url: _getProductImagePath(5, 'Homme'), productId: 5),
        ],
        rating: 4.2,
      ),
      Product(
        id: 6,
        name: 'Blouse médicale blanche',
        description: 'Blouse médicale blanche classique, coupe ajustée et professionnelle',
        price: 75.0,
        size: 'S',
        color: 'Blanc',
        stockQuantity: 60,
        categoryId: 3,
        categoryName: 'Femme',
        discount: null,
        discountActive: false,
        images: [
          ProductImage(id: 6, url: _getProductImagePath(6, 'Femme'), productId: 6),
        ],
        rating: 4.8,
      ),
    ];
  }

  List<Product> get filteredProducts {
    List<Product> filtered = products;

   
    if (selectedCategory != 'Tous') {
      filtered = filtered.where((p) => p.categoryName == selectedCategory).toList();
    }

    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        final nameMatch = p.name.toLowerCase().contains(_searchQuery);
        final descriptionMatch = p.description.toLowerCase().contains(_searchQuery);
        return nameMatch || descriptionMatch;
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Rechercher un produit par nom ou description...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.primaryColor,
                            size: 24,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category.name == selectedCategory;
    return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: FilterChip(
                            label: Text(category.name),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = category.name;
                              });
                            },
                            selectedColor: AppColors.primaryColor,
                            backgroundColor: Colors.white,
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected 
                                  ? Colors.white 
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                SliverPadding(
                  padding: const EdgeInsets.all(15),
                  sliver: filteredProducts.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Text(
                                'Aucun produit disponible',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.56,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = filteredProducts[index];
                              return ProductCard(
                                product: product,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailPage(product: product),
                                    ),
                                  );
                                },
                                onAddToCart: () {
                                  _cartService.addToCart(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.check_circle, color: Colors.white),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              '${product.name} ajouté au panier',
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
                                },
                              );
                            },
                            childCount: filteredProducts.length,
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
