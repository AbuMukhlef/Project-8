import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onze_cafe/extensions/color_ext.dart';

import 'package:onze_cafe/extensions/string_ex.dart';
import 'package:onze_cafe/model/cart_Item.dart';

import 'package:onze_cafe/reusable_components/buttons/custom_back_btn.dart';

import 'package:onze_cafe/extensions/img_ext.dart';
import 'package:onze_cafe/reusable_components/buttons/custom_circle_btn.dart';
import 'package:onze_cafe/screens/cart/cart_cubit.dart';
import 'package:onze_cafe/screens/cart/network_functions.dart';
import 'package:onze_cafe/screens/cart/subviews/card_item_view.dart';
import '../../model/menu_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.cart, required this.menuItems});
  final List<CartItem> cart;
  final List<MenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return BlocProvider(
      create: (context) => CartCubit(cart, menuItems),
      child: Builder(builder: (context) {
        final cubit = context.read<CartCubit>();

        return Scaffold(
          backgroundColor: C.bg1(brightness),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: CustomeBackBtn(brightness: brightness),
          ),
          body: BlocBuilder<CartCubit, CartState>(builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Image(image: Img.star4),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Cart").styled(
                          size: 20,
                          color: C.primary(brightness),
                          weight: FontWeight.bold),
                      Spacer(),
                      TextButton(
                          onPressed: () => cubit.updatedCart(context),
                          child: Text("Update").styled(
                              size: 14,
                              color: C.secondary(brightness),
                              weight: FontWeight.w400))
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ListView(
                      children: cubit.cartItems.isEmpty
                          ? [
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: AspectRatio(
                                    aspectRatio: 1.3,
                                    child: Image(
                                        image: Img.box, fit: BoxFit.contain)),
                              )
                            ]
                          : cubit.cartItems
                              .map((cartItem) => CartItemView(
                                  cubit: context.read<CartCubit>(),
                                  cartItem: cartItem))
                              .toList(),
                    ),
                  ),
                ),
                CustomCircleBtn(
                  brightness: brightness,
                  onTap: cubit.cartItems.isEmpty
                      ? () => cubit.showSnackBar(
                          context, 'cart is empty', AnimatedSnackBarType.error)
                      : () => cubit.navigateToPayment(context),
                  title: 'Total: ${cubit.totalPrice()}',
                  subTitle: 'Proceed to Checkout',
                )
              ],
            );
          }),
        );
      }),
    );
  }
}
