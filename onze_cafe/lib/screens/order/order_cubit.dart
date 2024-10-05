import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:onze_cafe/mockData/mock_data.dart';
import 'package:onze_cafe/model/cart_Item.dart';
import 'package:onze_cafe/model/menu_item.dart';
import 'package:onze_cafe/model/placed_order.dart';
import 'package:onze_cafe/screens/order_details/order_details_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());
  List<PlacedOrder> orders = [];

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<void> handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));
  }

  void fetchOrders() {
    orders =
        MockData().placedOrders.where((order) => order.userId == '1').toList();
  }

  List<CartItem> fetchCartItems(PlacedOrder order) {
    return MockData()
        .cart
        .where((cartItem) => cartItem.placedOrderId == order.id)
        .toList();
  }

  MenuItem? fetchMenuItem(CartItem cart) {
    return MockData()
        .menuItems
        .where((item) => item.id == cart.menuItemId)
        .toList()
        .firstOrNull;
  }

  double totalPrice(PlacedOrder order) {
    var total = 0.0;
    var cartItems = fetchCartItems(order);
    for (var cartItem in cartItems) {
      var quantity = cartItem.quantity;
      var item = fetchMenuItem(cartItem);
      if (item != null) {
        total += item.price * quantity;
      }
    }
    return total;
  }

  void navigateToOrderDetails(BuildContext context, PlacedOrder order) {
    final price = totalPrice(order);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          orderId: order.id ?? '',
          price: price,
        ),
      ),
    );
  }

  void emitLoading() => LoadingState();
  void emitUpdate() => UpdateUIState();
}
