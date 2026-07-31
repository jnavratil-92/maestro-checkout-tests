import 'package:flutter/material.dart';

import '../ids/booking_ids.dart';
import '../l10n/app_strings.dart';

/// Shows a timeslot dialog for the already-locked [date] (matches the real
/// widget: only the first product gets a calendar, every other product's
/// date is locked to it and only the time is selectable). [availableSlots]
/// empty means closed (Scenario B). Returns the picked slot string, or null
/// if dismissed/closed.
Future<String?> showTimeslotPickerDialog(
  BuildContext context, {
  required DateTime date,
  required List<String> availableSlots,
  required AppLanguage language,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _TimeslotDialog(
      date: date,
      availableSlots: availableSlots,
      language: language,
    ),
  );
}

class _TimeslotDialog extends StatefulWidget {
  final DateTime date;
  final List<String> availableSlots;
  final AppLanguage language;

  const _TimeslotDialog({
    required this.date,
    required this.availableSlots,
    required this.language,
  });

  @override
  State<_TimeslotDialog> createState() => _TimeslotDialogState();
}

class _TimeslotDialogState extends State<_TimeslotDialog> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final closed = widget.availableSlots.isEmpty;
    final strings = AppStrings(widget.language);
    return Semantics(
      identifier: TimeslotIds.dialog,
      container: true,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.selectedDateLabel),
              const SizedBox(height: 4),
              Semantics(
                identifier: TimeslotIds.lockedDateText,
                container: true,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.date.day}. ${widget.date.month}. ${widget.date.year}',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  strings.cannotChangeDateNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 12),
              if (!closed) Text(strings.selectTimeLabel),
              const SizedBox(height: 8),
              if (closed)
                Semantics(
                  identifier: TimeslotIds.closedMessage,
                  container: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(strings.timeslotsClosedMessage),
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.availableSlots.map((slot) {
                    final isSelected = _selected == slot;
                    return Semantics(
                      identifier: TimeslotIds.slot(slot.replaceAll(':', '_')),
                      container: true,
                      child: ChoiceChip(
                        label: Text(slot),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selected = slot),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 16),
              if (closed)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(strings.closeLabel),
                )
              else
                Semantics(
                  identifier: TimeslotIds.saveButton,
                  container: true,
                  child: ElevatedButton(
                    onPressed: _selected != null
                        ? () => Navigator.of(context).pop(_selected)
                        : null,
                    child: Text(strings.saveLabel),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
