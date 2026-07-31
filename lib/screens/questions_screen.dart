import 'package:flutter/material.dart';

import '../ids/booking_ids.dart';
import '../l10n/app_strings.dart';
import '../models/booking_state.dart';
import '../utils/simulated_latency.dart';
import 'checkout_screen.dart';

class QuestionsScreen extends StatefulWidget {
  final BookingState state;

  const QuestionsScreen({super.key, required this.state});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final _promoCodeController = TextEditingController();
  final _textAreaController = TextEditingController();
  bool _checkboxValue = false;
  String? _selectValue;
  String? _selectOptionalValue;
  String? _radioValue;
  late List<bool> _perTicketChecked;
  late List<String?> _perTicketRadioValues;
  bool _showErrors = false;

  bool get _textAreaValid => _textAreaController.text.trim().isNotEmpty;
  bool get _selectValid => _selectValue != null;
  bool get _perTicketValid => _perTicketChecked.every((checked) => checked);

  /// One label per ticket unit (adults first, then children), e.g. with 2
  /// adults and 1 child: "Adult 1", "Adult 2", "Child 1" — each gets its own
  /// per-ticket question block below.
  List<String> get _ticketUnitLabels {
    final strings = AppStrings(widget.state.language);
    return [
      for (var i = 0; i < widget.state.adultQty; i++)
        '${strings.adultLabel} ${i + 1}',
      for (var i = 0; i < widget.state.childQty; i++)
        '${strings.childLabel} ${i + 1}',
    ];
  }

  @override
  void initState() {
    super.initState();
    final ticketTotal = widget.state.ticketTotal;
    _perTicketChecked = List<bool>.filled(ticketTotal, false);
    _perTicketRadioValues = List<String?>.filled(ticketTotal, null);
  }

  void _onContinue() {
    final valid = _textAreaValid && _selectValid && _perTicketValid;
    setState(() => _showErrors = true);
    if (!valid) return;

    final state = widget.state;
    state.bookingQuestionTextArea = _textAreaController.text;
    state.bookingQuestionCheckbox = _checkboxValue;
    state.bookingQuestionSelect = _selectValue;
    state.bookingQuestionSelectOptional = _selectOptionalValue;
    state.bookingQuestionRadio = _radioValue;
    state.perTicketCheckbox = List<bool>.from(_perTicketChecked);
    state.perTicketRadio = List<String?>.from(_perTicketRadioValues);
    if (_promoCodeController.text.trim().isNotEmpty) {
      state.applyPromoCode(_promoCodeController.text);
    }

    withSimulatedLatency(context, () async {
      if (!context.mounted) return;
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => CheckoutScreen(state: state)));
    });
  }

  @override
  void dispose() {
    _promoCodeController.dispose();
    _textAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(widget.state.language);
    return Semantics(
      identifier: QuestionsIds.page,
      container: true,
      child: Scaffold(
        appBar: AppBar(title: Text(strings.questionsPageTitle)),
        // The promo field's visibility depends on [BookingState.promoHintUnlocked],
        // which can flip to true on the Checkout page after this screen was
        // already built — an AnimatedBuilder re-evaluates it on return here.
        body: AnimatedBuilder(
          animation: widget.state,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      strings.pleaseCompleteAdditionalInfo,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '* ${strings.requiredFieldsLegend}',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
              const Divider(height: 32),

              // Booking-level question: required text area.
              _FieldLabel('${strings.bookingQuestionTextAreaLabel} *'),
              Text(
                strings.bookingQuestionTextAreaHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Semantics(
                identifier: QuestionsIds.bookingTextArea,
                container: true,
                child: TextField(
                  controller: _textAreaController,
                  maxLines: 3,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              if (_showErrors && !_textAreaValid)
                Semantics(
                  identifier: QuestionsIds.validationError,
                  container: true,
                  child: _ErrorText(strings.fieldRequiredMessage),
                ),
              const SizedBox(height: 20),

              // Booking-level question: optional checkbox.
              _FieldLabel(strings.bookingQuestionCheckboxLabel),
              Semantics(
                identifier: QuestionsIds.bookingCheckbox,
                container: true,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(strings.bookingQuestionCheckboxOption),
                  value: _checkboxValue,
                  onChanged: (v) => setState(() => _checkboxValue = v ?? false),
                ),
              ),
              const SizedBox(height: 12),

              // Booking-level question: required select.
              _FieldLabel('${strings.bookingQuestionSelectLabel} *'),
              Text(
                strings.bookingQuestionSelectHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Semantics(
                identifier: QuestionsIds.bookingSelect,
                container: true,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectValue,
                  hint: Text(strings.selectPlaceholder),
                  items: strings.bookingQuestionSelectOptions
                      .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectValue = v),
                ),
              ),
              if (_showErrors && !_selectValid)
                _ErrorText(strings.fieldRequiredMessage),
              const SizedBox(height: 20),

              // Booking-level question: optional select.
              _FieldLabel(strings.bookingQuestionSelectOptionalLabel),
              const SizedBox(height: 4),
              Semantics(
                identifier: QuestionsIds.bookingSelectOptional,
                container: true,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectOptionalValue,
                  hint: Text(strings.selectPlaceholder),
                  items: strings.bookingQuestionSelectOptionalOptions
                      .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectOptionalValue = v),
                ),
              ),
              const SizedBox(height: 20),

              // Booking-level question: optional radio group.
              _FieldLabel(strings.bookingQuestionRadioLabel),
              _RadioGroup(
                value: _radioValue,
                options: strings.bookingQuestionRadioOptions,
                noneLabel: strings.radioNoneOption,
                idFor: QuestionsIds.bookingRadio,
                onChanged: (v) => setState(() => _radioValue = v),
              ),
              // Per-ticket questions: one full block per selected ticket unit
              // (adults then children), so e.g. 5 adults get 5 independent
              // answers instead of a single shared one.
              for (var i = 0; i < _ticketUnitLabels.length; i++) ...[
                const Divider(height: 32),

                Text(
                  _ticketUnitLabels[i],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),

                // Per-ticket question: required checkbox.
                _FieldLabel('${strings.perTicketCheckboxLabel} *'),
                Text(
                  strings.perTicketCheckboxHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Semantics(
                  identifier: QuestionsIds.perTicketCheckbox(i),
                  container: true,
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(strings.perTicketCheckboxOption),
                    value: _perTicketChecked[i],
                    onChanged: (v) =>
                        setState(() => _perTicketChecked[i] = v ?? false),
                  ),
                ),
                if (_showErrors && !_perTicketChecked[i])
                  _ErrorText(strings.fieldRequiredMessage),
                const SizedBox(height: 12),

                // Per-ticket question: optional radio group.
                _FieldLabel(strings.perTicketRadioLabel),
                _RadioGroup(
                  value: _perTicketRadioValues[i],
                  options: strings.perTicketRadioOptions,
                  noneLabel: strings.radioNoneOption,
                  idFor: (option) => QuestionsIds.perTicketRadio(i, option),
                  onChanged: (v) =>
                      setState(() => _perTicketRadioValues[i] = v),
                ),
              ],
              if (widget.state.promoHintUnlocked) ...[
                const Divider(height: 32),
                Semantics(
                  identifier: QuestionsIds.promoCodeField,
                  container: true,
                  child: TextField(
                    controller: _promoCodeController,
                    decoration: InputDecoration(
                      labelText: strings.promoCodeLabel,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Semantics(
            identifier: QuestionsIds.continueButton,
            container: true,
            child: ElevatedButton(
              onPressed: _onContinue,
              child: Text(strings.continueLabel),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleSmall);
  }
}

class _ErrorText extends StatelessWidget {
  final String text;

  const _ErrorText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.red, fontSize: 12));
  }
}

class _RadioGroup extends StatelessWidget {
  final String? value;
  final List<String> options;
  final String noneLabel;
  final String Function(String option) idFor;
  final ValueChanged<String?> onChanged;

  const _RadioGroup({
    required this.value,
    required this.options,
    required this.noneLabel,
    required this.idFor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          identifier: idFor('none'),
          container: true,
          child: RadioListTile<String?>(
            contentPadding: EdgeInsets.zero,
            title: Text(noneLabel),
            value: null,
            groupValue: value,
            onChanged: onChanged,
          ),
        ),
        for (final option in options)
          Semantics(
            identifier: idFor(option),
            container: true,
            child: RadioListTile<String?>(
              contentPadding: EdgeInsets.zero,
              title: Text(option),
              value: option,
              groupValue: value,
              onChanged: onChanged,
            ),
          ),
      ],
    );
  }
}
