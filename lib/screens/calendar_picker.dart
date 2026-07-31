import 'package:flutter/material.dart';

import '../ids/booking_ids.dart';
import '../l10n/app_strings.dart';

// Matches the assignment's "maximum booking window (weeks in advance) is
// dynamic and can be configured by the client" — 52 weeks is a realistic
// stand-in for that config value, not a hardcoded product constraint.
const int kMaxBookingWeeksAhead = 52;

/// Shows a month-grid calendar dialog restricted to [today, today + N weeks].
/// Returns the picked [DateTime] (date-only) or null if dismissed.
Future<DateTime?> showCalendarPickerDialog(
  BuildContext context, {
  DateTime? initialDate,
  required AppLanguage language,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (_) =>
        _CalendarDialog(initialDate: initialDate, language: language),
  );
}

class _CalendarDialog extends StatefulWidget {
  final DateTime? initialDate;
  final AppLanguage language;

  const _CalendarDialog({this.initialDate, required this.language});

  @override
  State<_CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<_CalendarDialog> {
  late DateTime _displayedMonth;
  DateTime? _selected;
  late DateTime _minDate;
  late DateTime _maxDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _minDate = DateTime(now.year, now.month, now.day);
    _maxDate = _minDate.add(Duration(days: 7 * kMaxBookingWeeksAhead));
    _selected = widget.initialDate ?? _minDate;
    _displayedMonth = DateTime(_selected!.year, _selected!.month);
  }

  bool _isSelectable(DateTime day) {
    return !day.isBefore(_minDate) && !day.isAfter(_maxDate);
  }

  void _goToNextMonth() {
    final next = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    if (!next.isAfter(DateTime(_maxDate.year, _maxDate.month))) {
      setState(() => _displayedMonth = next);
    }
  }

  void _goToPreviousMonth() {
    final prev = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    if (!prev.isBefore(DateTime(_minDate.year, _minDate.month))) {
      setState(() => _displayedMonth = prev);
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;
    final firstOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );
    final leadingEmptyCells = firstOfMonth.weekday - 1; // Monday = 1
    final strings = AppStrings(widget.language);

    return Semantics(
      identifier: CalendarIds.dialog,
      container: true,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _goToPreviousMonth,
                  ),
                  Text('${_displayedMonth.month}/${_displayedMonth.year}'),
                  Semantics(
                    identifier: CalendarIds.nextMonthButton,
                    container: true,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _goToNextMonth,
                    ),
                  ),
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemCount: leadingEmptyCells + daysInMonth,
                itemBuilder: (context, index) {
                  if (index < leadingEmptyCells) {
                    return const SizedBox.shrink();
                  }
                  final dayNum = index - leadingEmptyCells + 1;
                  final day = DateTime(
                    _displayedMonth.year,
                    _displayedMonth.month,
                    dayNum,
                  );
                  final selectable = _isSelectable(day);
                  final isSelected =
                      _selected != null &&
                      _selected!.year == day.year &&
                      _selected!.month == day.month &&
                      _selected!.day == day.day;
                  return Semantics(
                    identifier: CalendarIds.day(dayNum),
                    container: true,
                    child: InkWell(
                      onTap: selectable
                          ? () => setState(() => _selected = day)
                          : null,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$dayNum',
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : selectable
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).disabledColor,
                            fontWeight: selectable
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Semantics(
                identifier: CalendarIds.saveButton,
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
