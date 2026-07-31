import 'package:flutter/material.dart';

import '../ids/booking_ids.dart';
import '../l10n/app_strings.dart';
import '../models/booking_state.dart';
import '../utils/simulated_latency.dart';
import 'calendar_picker.dart';
import 'questions_screen.dart';
import 'timeslot_picker.dart';

class DateTimeScreen extends StatefulWidget {
  final BookingState state;

  const DateTimeScreen({super.key, required this.state});

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  Future<void> _selectDateTime(int productIndex) async {
    final state = widget.state;

    // Only the first product gets a calendar. Confirming its date unlocks
    // the rest, and every other product's date is locked to that same date
    // — only the time is selectable for them, matching the real widget.
    if (productIndex == 0) {
      final date = await showCalendarPickerDialog(
        context,
        initialDate: state.selectedDates[0],
        language: state.language,
      );
      if (date == null) return;
      setState(() => state.confirmDate(productIndex, date));
      return;
    }

    final lockedDate = state.selectedDates[0]!;

    // Some products (e.g. the ferry tour) only need the date confirmed —
    // no time slots to pick, since the date is already locked to the first
    // product's choice.
    if (!kProducts[productIndex].hasTimeSelection) {
      setState(() => state.confirmDate(productIndex, lockedDate));
      return;
    }

    final slots = state.timeslotsFor(lockedDate, productIndex);
    final slot = await showTimeslotPickerDialog(
      context,
      date: lockedDate,
      availableSlots: slots,
      language: state.language,
    );
    if (slot == null) return; // closed or dismissed, nothing confirmed
    setState(() => state.confirmDate(productIndex, lockedDate, timeslot: slot));
  }

  bool get _allRequiredConfirmed {
    final state = widget.state;
    for (var i = 0; i < kProducts.length; i++) {
      if (kProducts[i].required && !state.selectedDates.containsKey(i)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final strings = AppStrings(state.language);
    return Semantics(
      identifier: DateTimeIds.page,
      container: true,
      child: Scaffold(
        appBar: AppBar(title: Text(strings.dateTimePageTitle)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Invisible to real users (1x1, unpainted) but still present
            // with semantics so Maestro can drive TimeSlotMode via id —
            // removing these outright would lose deterministic Scenario A/B
            // testing. Plain GestureDetector + tiny SizedBox rather than
            // TextButton, so no Material minimum-touch-target size gets
            // reserved in the layout.
            Row(
              children: [
                Semantics(
                  identifier: DebugIds.setLiveButton,
                  container: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(
                      () => state.setTimeSlotMode(TimeSlotMode.live),
                    ),
                    child: const SizedBox(width: 12, height: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  identifier: DebugIds.setForceOpenButton,
                  container: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(
                      () => state.setTimeSlotMode(TimeSlotMode.forceOpen),
                    ),
                    child: const SizedBox(width: 12, height: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  identifier: DebugIds.setForceClosedButton,
                  container: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(
                      () => state.setTimeSlotMode(TimeSlotMode.forceClosed),
                    ),
                    child: const SizedBox(width: 12, height: 12),
                  ),
                ),
              ],
            ),
            if (state.confirmedCount > 0)
              Semantics(
                identifier: DateTimeIds.resetSelectionLink,
                container: true,
                child: TextButton(
                  onPressed: () => setState(state.resetSelection),
                  child: Text(strings.resetSelectionLabel),
                ),
              ),
            for (var i = 0; i < kProducts.length; i++)
              _ProductTile(
                index: i,
                product: kProducts[i],
                strings: strings,
                enabled: i == 0
                    ? true
                    // Hop-on Hop-off's time depends on Madame Tussauds'
                    // already-confirmed time (see hopOnTimeslotsFor).
                    : i == 2
                    ? state.firstProductConfirmed &&
                          state.selectedTimeslots.containsKey(1)
                    : state.firstProductConfirmed,
                confirmedDate: state.selectedDates[i],
                confirmedTimeslot: state.selectedTimeslots[i],
                onTap: () => _selectDateTime(i),
              ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Semantics(
            identifier: DateTimeIds.continueButton,
            container: true,
            child: ElevatedButton(
              onPressed: _allRequiredConfirmed
                  ? () => withSimulatedLatency(context, () async {
                      if (!context.mounted) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QuestionsScreen(state: state),
                        ),
                      );
                    })
                  : null,
              child: Text(strings.continueLabel),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final int index;
  final Product product;
  final AppStrings strings;
  final bool enabled;
  final DateTime? confirmedDate;
  final String? confirmedTimeslot;
  final VoidCallback onTap;

  const _ProductTile({
    required this.index,
    required this.product,
    required this.strings,
    required this.enabled,
    required this.confirmedDate,
    required this.confirmedTimeslot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name + (product.required ? '' : strings.optionalSuffix),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(product.description),
            const SizedBox(height: 8),
            if (confirmedDate != null)
              Semantics(
                identifier: DateTimeIds.confirmedDate(index),
                container: true,
                child: Text(
                  '${confirmedDate!.day}. ${confirmedDate!.month}. ${confirmedDate!.year}'
                  '${confirmedTimeslot != null ? ' $confirmedTimeslot' : ''}',
                ),
              ),
            Semantics(
              identifier: DateTimeIds.selectButton(index),
              container: true,
              child: ElevatedButton(
                onPressed: enabled ? onTap : null,
                child: Text(
                  confirmedDate != null
                      ? strings.editLabel
                      : strings.selectDateTimeLabel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
