import 'package:flutter/material.dart';
import 'stripe_services_simple.dart';

/// Example usage of StripeService
class StripeExample {
  static final StripeService _stripeService = StripeService();

  /// Initialize Stripe when app starts
  static Future<void> initializeStripe() async {
    try {
      print('🚀 Starting Stripe initialization...');

      await _stripeService.initialize();

      print('✅ Stripe initialized successfully');
    } catch (e) {
      print('❌ Error initializing Stripe: $e');
    }
  }

  /// Example: Create a checkout session and launch web checkout
  static Future<void> processPayment({
    required double amount,
    required String currency,
    required String customerId,
    String? description,
  }) async {
    try {
      print('💳 Processing payment: $amount $currency');

      // 1. Create checkout session
      final session = await _stripeService.createCheckoutSession(
        amount: amount,
        currency: currency,
        successUrl: 'https://your-app.com/success',
        cancelUrl: 'https://your-app.com/cancel',
        customerId: customerId,
        description: description ?? 'Payment for services',
      );

      if (session != null) {
        print('✅ Checkout session created: ${session['id']}');

        // 2. Launch Stripe Checkout in browser
        final result = await _stripeService.launchStripeCheckout(
          sessionId: session['id'],
          successUrl: 'https://your-app.com/success',
          cancelUrl: 'https://your-app.com/cancel',
        );

        if (result.isPending) {
          print('🌐 Stripe Checkout launched: ${result.checkoutUrl}');
        } else if (result.isSuccess) {
          print('✅ Payment successful: ${result.paymentIntentId}');
        } else {
          print('❌ Payment failed: ${result.error}');
        }
      } else {
        print('❌ Failed to create checkout session');
        print('❌ Failed to create checkout session');
      }
    } catch (e) {
      print('❌ Error processing payment: $e');
    }
  }

  /// Example: Check payment status
  static Future<void> checkPaymentStatus(String paymentIntentId) async {
    try {
      print('🔍 Checking payment status: $paymentIntentId');

      final status = await _stripeService.getPaymentIntentStatus(
        paymentIntentId,
      );

      if (status != null) {
        print('✅ Payment status: ${status['status']}');
        print('💰 Amount: ${status['amount']}');
        print('📅 Created: ${status['created']}');
      } else {
        print('❌ Failed to get payment status');
      }
    } catch (e) {
      print('❌ Error checking payment status: $e');
    }
  }

  /// Example: Process refund
  static Future<void> processRefund({
    required String paymentIntentId,
    double? amount,
    String? reason,
  }) async {
    try {
      print('💰 Processing refund: $paymentIntentId');

      final refund = await _stripeService.refundPayment(
        paymentIntentId: paymentIntentId,
        amount: amount,
        reason: reason,
      );

      if (refund != null) {
        print('✅ Refund processed: ${refund['id']}');
        print('💰 Refund amount: ${refund['amount']}');
        print('📅 Refunded at: ${refund['created']}');
      } else {
        print('❌ Failed to process refund');
      }
    } catch (e) {
      print('❌ Error processing refund: $e');
    }
  }

  /// Example: Cancel payment intent
  static Future<void> cancelPayment(String paymentIntentId) async {
    try {
      print('❌ Cancelling payment: $paymentIntentId');

      final cancelled = await _stripeService.cancelPaymentIntent(
        paymentIntentId,
      );

      if (cancelled) {
        print('✅ Payment cancelled successfully');
      } else {
        print('❌ Failed to cancel payment');
      }
    } catch (e) {
      print('❌ Error cancelling payment: $e');
    }
  }

  /// Example: Get customer payment methods
  static Future<void> getCustomerPaymentMethods(String customerId) async {
    try {
      print('💳 Getting payment methods for customer: $customerId');

      final paymentMethods = await _stripeService.getCustomerPaymentMethods(
        customerId,
      );

      print('✅ Found ${paymentMethods.length} payment methods:');

      for (final method in paymentMethods) {
        print('  - Type: ${method['type']}');
        print('  - ID: ${method['id']}');
        print('  - Last 4: ${method['card']?['last4'] ?? 'N/A'}');
        print('  - Brand: ${method['card']?['brand'] ?? 'N/A'}');
        print('  ---');
      }
    } catch (e) {
      print('❌ Error getting payment methods: $e');
    }
  }

  /// Get current service status
  static bool get isProcessing => _stripeService.isProcessing;
  static String? get lastError => _stripeService.lastErrorMessage;
  static String? get lastPaymentIntentId => _stripeService.lastPaymentIntentId;

  /// Clear error message
  static void clearError() {
    _stripeService.clearError();
  }
}
