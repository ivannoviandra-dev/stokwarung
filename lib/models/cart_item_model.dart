import 'product_model.dart';

/// Cart item model for POS / Kasir transactions.
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  /// Subtotal for this cart item
  double get subtotal => product.sellPrice * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': product.id,
      'product_name': product.name,
      'price': product.sellPrice,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}
