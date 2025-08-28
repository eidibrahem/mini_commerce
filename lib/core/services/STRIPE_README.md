# Stripe Payment Service

This service integrates Stripe payment gateway with your Flutter app, providing web-based checkout and payment processing capabilities.

## 🚀 Features

- **Stripe Checkout**: Launch web-based payment forms
- **Payment Intents**: Create and manage payment intents
- **Checkout Sessions**: Create checkout sessions for products
- **Refunds**: Process payment refunds
- **Payment Status**: Check payment status and history
- **URL Launcher**: Seamlessly open Stripe Checkout in browser

## 📱 Setup

### 1. Dependencies
Make sure you have these in your `pubspec.yaml`:
```yaml
dependencies:
  flutter_stripe: ^10.0.0
  url_launcher: ^6.2.5
  http: ^1.2.1
```

### 2. Stripe Configuration
1. Get your Stripe API keys from [Stripe Dashboard](https://dashboard.stripe.com/apikeys)
2. Update the keys in `stripe_services_simple.dart`:
```dart
static const String _publishableKey = 'pk_test_your_key_here';
static const String _secretKey = 'sk_test_your_key_here';
```

### 3. Initialize in main.dart
```dart
import 'core/services/stripe_example.dart';

void main() async {
  // ... other initialization
  
  // Initialize Stripe
  await StripeExample.initializeStripe();
  
  runApp(MyApp());
}
```

## 🔧 Usage

### Basic Payment Flow

```dart
import 'package:mini_commerce/core/services/stripe_example.dart';

// Process a payment
await StripeExample.processPayment(
  amount: 99.99,
  currency: 'USD',
  customerId: 'cus_123456789',
  description: 'Premium subscription',
);
```

### Create Checkout Session

```dart
final stripeService = StripeService();

final session = await stripeService.createCheckoutSession(
  amount: 99.99,
  currency: 'USD',
  successUrl: 'https://your-app.com/success',
  cancelUrl: 'https://your-app.com/cancel',
  customerId: 'cus_123456789',
  description: 'Premium subscription',
);

if (session != null) {
  print('Checkout session created: ${session['id']}');
}
```

### Launch Stripe Checkout

```dart
final result = await stripeService.launchStripeCheckout(
  sessionId: 'cs_test_123456789',
  successUrl: 'https://your-app.com/success',
  cancelUrl: 'https://your-app.com/cancel',
);

if (result.isPending) {
  print('Checkout launched: ${result.checkoutUrl}');
} else if (result.isSuccess) {
  print('Payment successful: ${result.paymentIntentId}');
} else {
  print('Payment failed: ${result.error}');
}
```

### Check Payment Status

```dart
final status = await stripeService.getPaymentIntentStatus('pi_123456789');

if (status != null) {
  print('Status: ${status['status']}');
  print('Amount: ${status['amount']}');
  print('Created: ${status['created']}');
}
```

### Process Refund

```dart
final refund = await stripeService.refundPayment(
  paymentIntentId: 'pi_123456789',
  amount: 99.99, // Optional: partial refund
  reason: 'Customer request',
);

if (refund != null) {
  print('Refund processed: ${refund['id']}');
}
```

### Cancel Payment

```dart
final cancelled = await stripeService.cancelPaymentIntent('pi_123456789');

if (cancelled) {
  print('Payment cancelled successfully');
}
```

### Get Customer Payment Methods

```dart
final paymentMethods = await stripeService.getCustomerPaymentMethods('cus_123456789');

for (final method in paymentMethods) {
  print('Type: ${method['type']}');
  print('ID: ${method['id']}');
  print('Last 4: ${method['card']?['last4']}');
  print('Brand: ${method['card']?['brand']}');
}
```

## 🌐 Stripe Checkout Flow

1. **Create Session**: Generate checkout session on your server
2. **Launch Checkout**: Open Stripe Checkout in browser using `url_launcher`
3. **User Payment**: Customer completes payment on Stripe's secure page
4. **Success/Cancel**: User returns to your app via success/cancel URLs
5. **Verify Payment**: Check payment status using payment intent ID

## 💳 Payment Methods Supported

- **Credit/Debit Cards**: Visa, Mastercard, American Express, etc.
- **Digital Wallets**: Apple Pay, Google Pay (future implementation)
- **Local Payment Methods**: Based on customer location
- **Bank Transfers**: ACH, SEPA, etc.

## 🔒 Security

- **Publishable Key**: Safe to use in client-side code
- **Secret Key**: Keep secure, use only on your server
- **HTTPS Required**: All production payments require HTTPS
- **Webhook Verification**: Verify webhook signatures for production

## 📊 Testing

### Test Cards
Use these test card numbers for development:
- **Success**: 4242 4242 4242 4242
- **Declined**: 4000 0000 0000 0002
- **Insufficient Funds**: 4000 0000 0000 9995

### Test Mode
- Use `pk_test_` and `sk_test_` keys for development
- Switch to `pk_live_` and `sk_live_` for production
- Test webhooks using Stripe CLI

## 🎯 Common Use Cases

### E-commerce Checkout
```dart
// Create checkout for shopping cart
final session = await stripeService.createCheckoutSession(
  amount: cartTotal,
  currency: 'USD',
  successUrl: 'https://your-app.com/order-success',
  cancelUrl: 'https://your-app.com/cart',
  lineItems: cartItems.map((item) => {
    'price_data': {
      'currency': 'usd',
      'product_data': {'name': item.name},
      'unit_amount': (item.price * 100).round(),
    },
    'quantity': item.quantity,
  }).toList(),
);
```

### Subscription Payments
```dart
// Create subscription checkout
final session = await stripeService.createCheckoutSession(
  amount: monthlyPrice,
  currency: 'USD',
  successUrl: 'https://your-app.com/subscription-success',
  cancelUrl: 'https://your-app.com/pricing',
  metadata: {'subscription_type': 'premium_monthly'},
);
```

### One-time Services
```dart
// Process service payment
final session = await stripeService.createCheckoutSession(
  amount: servicePrice,
  currency: 'USD',
  successUrl: 'https://your-app.com/service-confirmed',
  cancelUrl: 'https://your-app.com/services',
  description: 'Professional consultation service',
);
```

## ⚠️ Important Notes

1. **Server-Side Operations**: Payment intents and checkout sessions should be created on your server
2. **Error Handling**: Always handle payment failures gracefully
3. **Webhook Integration**: Set up webhooks for production payment verification
4. **Compliance**: Ensure PCI compliance for handling card data
5. **Testing**: Thoroughly test all payment flows before going live

## 🐛 Troubleshooting

### Common Issues

1. **Invalid API Key**: Check your publishable and secret keys
2. **Network Errors**: Verify internet connection and API endpoints
3. **Permission Denied**: Ensure proper Stripe account permissions
4. **Currency Mismatch**: Verify currency codes match your Stripe account

### Debug Mode
Enable debug logging by checking console output:
```
🚀 StripeService: Initializing Stripe...
✅ StripeService: Stripe initialized successfully
💰 StripeService: Creating checkout session...
✅ StripeService: Checkout session created: cs_test_...
🌐 StripeService: Launching Stripe Checkout...
✅ StripeService: Stripe Checkout launched successfully
```

## 📚 Additional Resources

- [Stripe Documentation](https://stripe.com/docs)
- [Flutter Stripe Plugin](https://pub.dev/packages/flutter_stripe)
- [URL Launcher](https://pub.dev/packages/url_launcher)
- [HTTP Package](https://pub.dev/packages/http)
- [Stripe Checkout](https://stripe.com/docs/checkout)
- [Payment Intents API](https://stripe.com/docs/api/payment_intents)

## 🔄 Future Enhancements

- **Apple Pay Integration**: Native iOS payment processing
- **Google Pay Integration**: Native Android payment processing
- **Saved Payment Methods**: Store and reuse customer cards
- **Subscription Management**: Handle recurring payments
- **Multi-currency Support**: Dynamic currency conversion
- **Advanced Fraud Detection**: Enhanced security features
