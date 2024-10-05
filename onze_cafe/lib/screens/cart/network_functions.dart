import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:onze_cafe/model/cart_Item.dart';
import 'package:onze_cafe/screens/cart/cart_cubit.dart';

import '../../supabase/supabase_cart.dart';

extension NetworkFunctions on CartCubit {
  Future removeCartItem(BuildContext context, CartItem cartItem) async {
    emitLoading();
    try {
      final response = await SupabaseCart.deleteCartItem(cartItem);
      cartItems.remove(cartItem);
      emitUpdate();
      return response;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), AnimatedSnackBarType.error);
      }
      emitUpdate();
    }
  }
}