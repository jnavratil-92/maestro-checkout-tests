import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ids/booking_ids.dart';
import '../l10n/app_strings.dart';
import '../models/booking_state.dart';
import '../utils/order_code.dart';

/// Card payment screen. Only reachable when [BookingState.total] > 0 (no
/// promo applied) — matches the real widget: without a promo/gift code you
/// land on a real payment gateway, and since test mode has no valid card
/// configured, payment always fails (CVC Declined) regardless of what's
/// entered.
class PaymentScreen extends StatefulWidget {
  final BookingState state;

  const PaymentScreen({super.key, required this.state});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  late final _nameOnCardController = TextEditingController(
    text: '${widget.state.firstName} ${widget.state.lastName}'.trim(),
  );

  bool _showErrors = false;

  int _digitCount(TextEditingController c) =>
      c.text.replaceAll(RegExp(r'\D'), '').length;

  bool get _cardValid => _digitCount(_cardNumberController) == 16;
  bool get _expiryValid => _digitCount(_expiryController) == 4;
  bool get _cvcValid => _digitCount(_cvcController) == 3;
  bool get _nameValid => _nameOnCardController.text.trim().isNotEmpty;

  bool get _canPay => _cardValid && _expiryValid && _cvcValid && _nameValid;

  void _onPay() {
    setState(() => _showErrors = true);
    if (!_canPay) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _PaymentProcessingScreen(state: widget.state),
      ),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _nameOnCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(widget.state.language);
    return Semantics(
      identifier: PaymentIds.page,
      container: true,
      child: Scaffold(
        appBar: AppBar(title: Text(strings.paymentPageTitle)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.cardPaymentLabel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                strings.allFieldsRequiredNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Semantics(
                identifier: PaymentIds.cardNumberField,
                container: true,
                child: TextField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_CardNumberInputFormatter()],
                  decoration: InputDecoration(
                    labelText: strings.cardNumberLabel,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              if (_showErrors && !_cardValid)
                Semantics(
                  identifier: PaymentIds.cardNumberError,
                  container: true,
                  child: _PaymentFieldError(strings.cardNumberInvalidMessage),
                ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          identifier: PaymentIds.expiryField,
                          container: true,
                          child: TextField(
                            controller: _expiryController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            decoration: InputDecoration(
                              labelText: strings.expiryLabel,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        if (_showErrors && !_expiryValid)
                          Semantics(
                            identifier: PaymentIds.expiryError,
                            container: true,
                            child: _PaymentFieldError(
                              strings.expiryInvalidMessage,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          identifier: PaymentIds.cvcField,
                          container: true,
                          child: TextField(
                            controller: _cvcController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            decoration: InputDecoration(
                              labelText: strings.cvcLabel,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        if (_showErrors && !_cvcValid)
                          Semantics(
                            identifier: PaymentIds.cvcError,
                            container: true,
                            child: _PaymentFieldError(strings.cvcInvalidMessage),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Semantics(
                identifier: PaymentIds.nameOnCardField,
                container: true,
                child: TextField(
                  controller: _nameOnCardController,
                  decoration: InputDecoration(
                    labelText: strings.nameOnCardLabel,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                identifier: PaymentIds.payButton,
                container: true,
                child: ElevatedButton(
                  onPressed: _onPay,
                  child: Text(
                    '${strings.payLabel} ${widget.state.total.toStringAsFixed(2)} €',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentFieldError extends StatelessWidget {
  final String text;

  const _PaymentFieldError(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(text, style: const TextStyle(color: Colors.red, fontSize: 12)),
    );
  }
}

/// Digits only, capped at 16, grouped into 4s ("1234 5678 9012 3456").
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final capped = digits.length > 16 ? digits.substring(0, 16) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(capped[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _PaymentProcessingScreen extends StatefulWidget {
  final BookingState state;

  const _PaymentProcessingScreen({required this.state});

  @override
  State<_PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<_PaymentProcessingScreen> {
  bool _declined = false;
  late final String _orderCode = generateOrderCode();

  @override
  void initState() {
    super.initState();
    // Test mode has no valid card configured — every payment attempt is
    // declined, regardless of what was entered.
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      for (final line in const [
        '[QA-HINT] Card payment is always declined in test mode (CVC Declined).',
        '[QA-HINT] Go back to the Question page and enter promo code '
            'MAESTROFREE, then return to Checkout to make the order free '
            '(0.00 EUR) and skip card payment entirely.',
      ]) {
        developer.log(line, name: 'QA-HINT');
        debugPrint(line);
      }
      setState(() => _declined = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(widget.state.language);
    if (!_declined) {
      return Semantics(
        identifier: PaymentResultIds.processingPage,
        container: true,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(strings.processingLabel),
              ],
            ),
          ),
        ),
      );
    }
    return Semantics(
      identifier: PaymentResultIds.declinedPage,
      container: true,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cancel, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  strings.declinedTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text('${strings.orderCodeLabel} $_orderCode'),
                const SizedBox(height: 16),
                Text(strings.declinedMessage, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Semantics(
                  identifier: PaymentResultIds.retryButton,
                  container: true,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(strings.retryLabel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
