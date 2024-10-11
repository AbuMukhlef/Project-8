import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moyasar/moyasar.dart';
import 'package:onze_cafe/screens/payment/network_functions.dart';

import '../../model/cart_Item.dart';
import '../../reusable_components/animated_snackbar.dart';
import '../payment_confirm_screen.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(BuildContext context, double amount) : super(PaymentInitial()) {
    initialLoad(context, amount);
  }

  int totalPrice = 999;
  PaymentConfig? paymentConfig;
  List<CartItem> cartItems = [];

  void initialLoad(BuildContext context, double amount) async {
    emitLoading();
    totalPrice = (amount * 100).toInt();

    cartItems = await fetchCart(context);

    paymentConfig = PaymentConfig(
      publishableApiKey: dotenv.env['Moyasar_API']!,
      amount: totalPrice,
      description: 'Coffee Order',
      creditCard: CreditCardConfig(saveCard: false, manual: false),
      applePay: ApplePayConfig(
      merchantId: dotenv.env['MERCHANT_ID']!,
        label: 'ABU_Mukhlef',
        manual: true,
      ),
    );

    emitUpdate();
  }

  void navigateToPaymentConfirmation(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const PaymentConfirmScreen()));

  void onPaymentResult(BuildContext context, result) async {
    if (result is PaymentResponse) {
      switch (result.status) {
        case PaymentStatus.paid:
          try {
            await createOrder(context);
            if (context.mounted) navigateToPaymentConfirmation(context);
          } catch (_) {
            if (context.mounted) {
              showSnackBar(
                  context,
                  'Something wrong happened. Please contact support',
                  AnimatedSnackBarType.error);
            }
          }
        case PaymentStatus.failed:
          showSnackBar(context, 'Payment failed!', AnimatedSnackBarType.error);
        case PaymentStatus.initiated:
          showSnackBar(context, 'Payment initiated. Please confirm.',
              AnimatedSnackBarType.info);
        case PaymentStatus.authorized:
          showSnackBar(context, 'Payment authorized. Awaiting capture.',
              AnimatedSnackBarType.info);
        case PaymentStatus.captured:
          showSnackBar(context, 'Payment captured successfully!',
              AnimatedSnackBarType.info);
      }
    }
  }

  void showSnackBar(
      BuildContext context, String msg, AnimatedSnackBarType type) {
    if (context.mounted) {
      animatedSnakbar(msg: msg, type: type).show(context);
    }
  }

  void emitLoading() => emit(LoadingState());
  void emitUpdate() => emit(UpdateUIState());
}
