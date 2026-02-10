import 'package:get/get.dart';
import '../../../data/models/product.dart';
import '../../products/controllers/products_controller.dart';

class WishlistController extends GetxController {
  final ProductsController _productsController = Get.find();

  List<Product> get favorites => _productsController.favoriteProductsList;

  void remove(Product product) {
    _productsController.toggleFavorite(product);
  }
}
