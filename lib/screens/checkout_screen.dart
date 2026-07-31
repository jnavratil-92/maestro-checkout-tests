import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../ids/booking_ids.dart';
import '../l10n/app_strings.dart';
import '../models/booking_state.dart';
import '../utils/order_code.dart';
import '../utils/simulated_latency.dart';
import 'payment_screen.dart';
import 'success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final BookingState state;

  const CheckoutScreen({super.key, required this.state});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Re-entering Checkout (e.g. after going back to Questions to apply a
  // promo code and continuing again) pushes a brand new instance of this
  // screen — prefill from already-confirmed state so that trip doesn't
  // wipe out previously entered contact details.
  late final _firstNameController = TextEditingController(
    text: widget.state.firstName,
  );
  late final _lastNameController = TextEditingController(
    text: widget.state.lastName,
  );
  late final _cityController = TextEditingController(text: widget.state.city);
  late final _stateProvinceController = TextEditingController(
    text: widget.state.stateProvince,
  );

  String? _country;
  bool _agreedBooking = false;
  bool _agreedCancellation = false;
  bool _promoButtonDismissed = false;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    final state = widget.state;
    _country = state.country.isEmpty ? null : state.country;
    _agreedBooking = state.agreedToBookingTerms;
    _agreedCancellation = state.agreedToCancellationTerms;
  }

  void _onPromoButtonTap() {
    // developer.log() surfaces in `flutter run`/`flutter logs`/DevTools (it
    // needs an attached VM service client to be visible there); debugPrint()
    // additionally guarantees the same lines show up in a plain `adb
    // logcat`/`idevicesyslog` with no debugger attached — log() alone won't.
    for (final line in const [
      '[QA-HINT] Promo code cannot be entered on this screen.',
      '[QA-HINT] Go back one step to the Question page. A promo code '
          'input is available there.',
      '[QA-HINT] Enter MAESTROFREE, then return to Checkout. The order '
          'will become free (0.00 EUR).',
    ]) {
      developer.log(line, name: 'QA-HINT');
      debugPrint(line);
    }
    widget.state.unlockPromoHint();
    setState(() => _promoButtonDismissed = true);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Error.')));
  }

  void _removePromo() {
    setState(() => widget.state.removePromoCode());
  }

  bool get _contactValid =>
      _firstNameController.text.trim().isNotEmpty &&
      _lastNameController.text.trim().isNotEmpty &&
      _country != null &&
      _stateProvinceController.text.trim().isNotEmpty &&
      _agreedBooking &&
      _agreedCancellation;

  void _onPayOrConfirm() {
    setState(() => _showErrors = true);
    if (!_contactValid) return;

    final state = widget.state;
    state.firstName = _firstNameController.text.trim();
    state.lastName = _lastNameController.text.trim();
    state.city = _cityController.text.trim();
    state.country = _country!;
    state.stateProvince = _stateProvinceController.text.trim();
    state.agreedToBookingTerms = _agreedBooking;
    state.agreedToCancellationTerms = _agreedCancellation;

    if (state.isFree) {
      withSimulatedLatency(context, () async {
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                SuccessScreen(state: state, orderCode: generateOrderCode()),
          ),
        );
      });
      return;
    }

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PaymentScreen(state: state)));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    _stateProvinceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final strings = AppStrings(state.language);
    return Semantics(
      identifier: CheckoutIds.page,
      container: true,
      child: Scaffold(
        appBar: AppBar(title: Text(strings.checkoutPageTitle)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strings.contactDetailsLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '* ${strings.requiredFieldsLegend}',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Semantics(
              identifier: CheckoutIds.firstNameField,
              container: true,
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: '${strings.firstNameLabel} *',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (_showErrors && _firstNameController.text.trim().isEmpty)
              Semantics(
                identifier: CheckoutIds.firstNameError,
                container: true,
                child: _RequiredFieldError(strings.fieldRequiredMessage),
              ),
            const SizedBox(height: 12),
            Semantics(
              identifier: CheckoutIds.lastNameField,
              container: true,
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: '${strings.lastNameLabel} *',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (_showErrors && _lastNameController.text.trim().isEmpty)
              Semantics(
                identifier: CheckoutIds.lastNameError,
                container: true,
                child: _RequiredFieldError(strings.fieldRequiredMessage),
              ),
            const SizedBox(height: 12),
            Semantics(
              identifier: CheckoutIds.cityField,
              container: true,
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: strings.cityLabel),
              ),
            ),
            const SizedBox(height: 12),
            Semantics(
              identifier: CheckoutIds.countryField,
              container: true,
              child: DropdownButtonFormField<String>(
                initialValue: _country,
                hint: Text(strings.countryPlaceholder),
                decoration: InputDecoration(
                  labelText: '${strings.countryLabel} *',
                ),
                items: [
                  DropdownMenuItem(
                    value: kRecommendedCountry.code,
                    child: Semantics(
                      identifier: CheckoutIds.countryOption(
                        kRecommendedCountry.code,
                      ),
                      container: true,
                      child: Text(kRecommendedCountry.displayName),
                    ),
                  ),
                  for (final country in kAllCountries)
                    DropdownMenuItem(
                      value: country.code,
                      child: Semantics(
                        identifier: CheckoutIds.countryOption(country.code),
                        container: true,
                        child: Text(country.displayName),
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _country = v),
              ),
            ),
            if (_showErrors && _country == null)
              Semantics(
                identifier: CheckoutIds.countryError,
                container: true,
                child: _RequiredFieldError(strings.fieldRequiredMessage),
              ),
            const SizedBox(height: 12),
            Semantics(
              identifier: CheckoutIds.stateProvinceField,
              container: true,
              child: TextField(
                controller: _stateProvinceController,
                decoration: InputDecoration(
                  labelText: '${strings.stateProvinceLabel} *',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (_showErrors && _stateProvinceController.text.trim().isEmpty)
              Semantics(
                identifier: CheckoutIds.stateProvinceError,
                container: true,
                child: _RequiredFieldError(strings.fieldRequiredMessage),
              ),
            const SizedBox(height: 16),
            Semantics(
              identifier: CheckoutIds.bookingTermsCheckbox,
              container: true,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(strings.bookingTermsLabel),
                value: _agreedBooking,
                onChanged: (v) => setState(() => _agreedBooking = v ?? false),
              ),
            ),
            if (_showErrors && !_agreedBooking)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  strings.requiredCheckboxError,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            Semantics(
              identifier: CheckoutIds.cancellationTermsCheckbox,
              container: true,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(strings.cancellationTermsLabel),
                value: _agreedCancellation,
                onChanged: (v) =>
                    setState(() => _agreedCancellation = v ?? false),
              ),
            ),
            if (_showErrors && !_agreedCancellation)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  strings.requiredCheckboxError,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const Divider(height: 32),
            Semantics(
              identifier: CheckoutIds.priceTotal,
              container: true,
              child: Text(
                '${strings.amountDueLabel}: ${state.total.toStringAsFixed(2)} €',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 12),
            if (state.promoApplied)
              Semantics(
                identifier: CheckoutIds.promoAppliedChip,
                container: true,
                child: Chip(
                  label: Text(strings.promoAppliedChipLabel),
                  deleteIcon: Semantics(
                    identifier: CheckoutIds.removePromoButton,
                    container: true,
                    child: const Icon(Icons.close, size: 18),
                  ),
                  onDeleted: _removePromo,
                ),
              )
            else if (!_promoButtonDismissed)
              Semantics(
                identifier: CheckoutIds.enterPromoButton,
                container: true,
                child: TextButton(
                  onPressed: _onPromoButtonTap,
                  child: Text(strings.enterPromoLabel),
                ),
              ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Semantics(
            identifier: CheckoutIds.payOrConfirmButton,
            container: true,
            child: ElevatedButton(
              onPressed: _onPayOrConfirm,
              child: Text(
                state.isFree
                    ? strings.confirmOrderLabel
                    : '${strings.payLabel} ${state.total.toStringAsFixed(2)} €',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RequiredFieldError extends StatelessWidget {
  final String text;

  const _RequiredFieldError(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
