import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripeService {
  static final StripeService _instance = StripeService._internal();
  factory StripeService() => _instance;
  StripeService._internal();

  // Stripe configuration
  static const String _publishableKey =
      'pk_test_...'; // Replace with your publishable key
  static const String _secretKey =
      'sk_test_...'; // Replace with your secret key (server-side only)
  static const String _stripeApiUrl = 'https://api.stripe.com/v1';

  // Payment intent status
  bool _isProcessing = false;
  String? _lastPaymentIntentId;
  String? _lastErrorMessage;

  // Getters
  bool get isProcessing => _isProcessing;
  String? get lastPaymentIntentId => _lastPaymentIntentId;
  String? get lastErrorMessage => _lastErrorMessage;

  /// Initialize Stripe
  Future<void> initialize() async {
    try {
      print('🚀 StripeService: Initializing Stripe...');

      // Configure Stripe
      Stripe.publishableKey = _publishableKey;

      // Set up Stripe configuration
      await Stripe.instance.applySettings();

      print('✅ StripeService: Stripe initialized successfully');
    } catch (e) {
      print('❌ StripeService: Error initializing Stripe: $e');
      _lastErrorMessage = e.toString();
      rethrow;
    }
  }

  /// Create payment intent (server-side - you'll need a backend)
  Future<Map<String, dynamic>?> createPaymentIntent({
    required double amount,
    required String currency,
    required String customerId,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      print(
        '💰 StripeService: Creating payment intent for amount: $amount $currency',
      );

      // In a real app, this should be done on your server
      // For demo purposes, we'll simulate the API call
      final response = await http.post(
        Uri.parse('$_stripeApiUrl/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (amount * 100).round().toString(), // Convert to cents
          'currency': currency.toLowerCase(),
          'customer': customerId,
          if (description != null) 'description': description,
          if (metadata != null) 'metadata': jsonEncode(metadata),
          'automatic_payment_methods[enabled]': 'true',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _lastPaymentIntentId = data['id'];
        print('✅ StripeService: Payment intent created: ${data['id']}');
        return data;
      } else {
        throw Exception(
          'Failed to create payment intent: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ StripeService: Error creating payment intent: $e');
      _lastErrorMessage = e.toString();
      return null;
    }
  }

  /// Launch Stripe Checkout in web browser
  Future<PaymentResult> launchStripeCheckout({
    required String sessionId,
    required String successUrl,
    required String cancelUrl,
  }) async {
    try {
      print('🌐 StripeService: Launching Stripe Checkout...');

      final checkoutUrl = 'https://checkout.stripe.com/pay/$sessionId';

      if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
        final result = await launchUrl(
          Uri.parse(checkoutUrl),
          mode: LaunchMode.externalApplication,
        );

        if (result) {
          print('✅ StripeService: Stripe Checkout launched successfully');
          return PaymentResult.pending(
            message: 'Checkout launched in browser',
            checkoutUrl: checkoutUrl,
          );
        } else {
          print('❌ StripeService: Failed to launch Stripe Checkout');
          return PaymentResult.failure(error: 'Failed to launch checkout');
        }
      } else {
        print('❌ StripeService: Cannot launch Stripe Checkout URL');
        return PaymentResult.failure(error: 'Cannot launch checkout URL');
      }
    } catch (e) {
      print('❌ StripeService: Error launching Stripe Checkout: $e');
      _lastErrorMessage = e.toString();
      return PaymentResult.failure(error: e.toString());
    }
  }

  /// Create Stripe Checkout session (server-side)
  Future<Map<String, dynamic>?> createCheckoutSession({
    required double amount,
    required String currency,
    required String successUrl,
    required String cancelUrl,
    String? customerId,
    String? description,
    List<Map<String, dynamic>>? lineItems,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      print('🛒 StripeService: Creating checkout session...');

      final response = await http.post(
        Uri.parse('$_stripeApiUrl/checkout/sessions'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'payment_method_types[]': 'card',
          'mode': 'payment',
          'success_url': successUrl,
          'cancel_url': cancelUrl,
          if (customerId != null) 'customer': customerId,
          if (description != null) 'description': description,
          if (metadata != null) 'metadata': jsonEncode(metadata),
          if (lineItems != null) 'line_items': jsonEncode(lineItems),
          'amount_total': (amount * 100).round().toString(),
          'currency': currency.toLowerCase(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ StripeService: Checkout session created: ${data['id']}');
        return data;
      } else {
        throw Exception(
          'Failed to create checkout session: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ StripeService: Error creating checkout session: $e');
      _lastErrorMessage = e.toString();
      return null;
    }
  }

  /// Get payment intent status
  Future<Map<String, dynamic>?> getPaymentIntentStatus(
    String paymentIntentId,
  ) async {
    try {
      print(
        '🔍 StripeService: Getting payment intent status: $paymentIntentId',
      );

      final response = await http.get(
        Uri.parse('$_stripeApiUrl/payment_intents/$paymentIntentId'),
        headers: {'Authorization': 'Bearer $_secretKey'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ StripeService: Payment intent status: ${data['status']}');
        return data;
      } else {
        throw Exception(
          'Failed to get payment intent status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ StripeService: Error getting payment intent status: $e');
      _lastErrorMessage = e.toString();
      return null;
    }
  }

  /// Refund payment
  Future<Map<String, dynamic>?> refundPayment({
    required String paymentIntentId,
    double? amount,
    String? reason,
  }) async {
    try {
      print('💰 StripeService: Processing refund for: $paymentIntentId');

      final response = await http.post(
        Uri.parse('$_stripeApiUrl/refunds'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'payment_intent': paymentIntentId,
          if (amount != null) 'amount': (amount * 100).round().toString(),
          if (reason != null) 'reason': reason,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ StripeService: Refund processed successfully: ${data['id']}');
        return data;
      } else {
        throw Exception('Failed to process refund: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ StripeService: Error processing refund: $e');
      _lastErrorMessage = e.toString();
      return null;
    }
  }

  /// Cancel payment intent
  Future<bool> cancelPaymentIntent(String paymentIntentId) async {
    try {
      print('❌ StripeService: Cancelling payment intent: $paymentIntentId');

      final response = await http.post(
        Uri.parse('$_stripeApiUrl/payment_intents/$paymentIntentId/cancel'),
        headers: {'Authorization': 'Bearer $_secretKey'},
      );

      if (response.statusCode == 200) {
        print('✅ StripeService: Payment intent cancelled successfully');
        return true;
      } else {
        throw Exception(
          'Failed to cancel payment intent: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ StripeService: Error cancelling payment intent: $e');
      _lastErrorMessage = e.toString();
      return false;
    }
  }

  /// Get customer payment methods
  Future<List<Map<String, dynamic>>> getCustomerPaymentMethods(
    String customerId,
  ) async {
    try {
      print(
        '💳 StripeService: Getting payment methods for customer: $customerId',
      );

      final response = await http.get(
        Uri.parse('$_stripeApiUrl/customers/$customerId/payment_methods'),
        headers: {'Authorization': 'Bearer $_secretKey'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentMethods = List<Map<String, dynamic>>.from(data['data']);
        print(
          '✅ StripeService: Found ${paymentMethods.length} payment methods',
        );
        return paymentMethods;
      } else {
        throw Exception(
          'Failed to get payment methods: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ StripeService: Error getting payment methods: $e');
      _lastErrorMessage = e.toString();
      return [];
    }
  }

  /// Clear error message
  void clearError() {
    _lastErrorMessage = null;
  }

  /// Dispose resources
  void dispose() {
    _isProcessing = false;
    _lastPaymentIntentId = null;
    _lastErrorMessage = null;
    print('🔄 StripeService: Disposed');
  }
}

/// Payment result class
class PaymentResult {
  final bool isSuccess;
  final bool isPending;
  final String? paymentIntentId;
  final double? amount;
  final String? status;
  final String? error;
  final String? message;
  final String? checkoutUrl;

  PaymentResult._({
    required this.isSuccess,
    required this.isPending,
    this.paymentIntentId,
    this.amount,
    this.status,
    this.error,
    this.message,
    this.checkoutUrl,
  });

  factory PaymentResult.success({
    required String paymentIntentId,
    required double amount,
    required String status,
  }) {
    return PaymentResult._(
      isSuccess: true,
      isPending: false,
      paymentIntentId: paymentIntentId,
      amount: amount,
      status: status,
    );
  }

  factory PaymentResult.failure({required String error}) {
    return PaymentResult._(isSuccess: false, isPending: false, error: error);
  }

  factory PaymentResult.pending({String? message, String? checkoutUrl}) {
    return PaymentResult._(
      isSuccess: false,
      isPending: true,
      message: message,
      checkoutUrl: checkoutUrl,
    );
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'PaymentResult.success(paymentIntentId: $paymentIntentId, amount: $amount, status: $status)';
    } else if (isPending) {
      return 'PaymentResult.pending(message: $message, checkoutUrl: $checkoutUrl)';
    } else {
      return 'PaymentResult.failure(error: $error)';
    }
  }
}
