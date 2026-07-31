import 'package:flutter/material.dart';

import '../ids/booking_ids.dart';
import '../l10n/app_strings.dart';
import '../models/booking_state.dart';
import '../utils/simulated_latency.dart';
import 'datetime_screen.dart';

class TicketsScreen extends StatefulWidget {
  final BookingState state;

  const TicketsScreen({super.key, required this.state});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final strings = AppStrings(state.language);
    return Semantics(
      identifier: TicketsIds.page,
      container: true,
      child: Scaffold(
        appBar: AppBar(title: Text(strings.ticketsPageTitle)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TicketRow(
                label: strings.adultLabel,
                priceLabel:
                    '${strings.fromPricePrefix} ${kAdultPrice.toStringAsFixed(0)} €',
                count: state.adultQty,
                decrementId: TicketsIds.adultDecrement,
                incrementId: TicketsIds.adultIncrement,
                countId: TicketsIds.adultCount,
                onDecrement: () => setState(state.decrementAdult),
                onIncrement: () => setState(state.incrementAdult),
              ),
              const SizedBox(height: 24),
              _TicketRow(
                label: strings.childLabel,
                priceLabel:
                    '${strings.fromPricePrefix} ${kChildPrice.toStringAsFixed(0)} €',
                count: state.childQty,
                decrementId: TicketsIds.childDecrement,
                incrementId: TicketsIds.childIncrement,
                countId: TicketsIds.childCount,
                onDecrement: () => setState(state.decrementChild),
                onIncrement: () => setState(state.incrementChild),
              ),
              if (state.childRequiresAdult)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Semantics(
                    identifier: TicketsIds.childRequiresAdultError,
                    container: true,
                    child: Text(
                      strings.childRequiresAdultMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Semantics(
            identifier: TicketsIds.continueButton,
            container: true,
            child: ElevatedButton(
              onPressed: state.canProceedFromTickets
                  ? () => withSimulatedLatency(context, () async {
                      if (!context.mounted) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DateTimeScreen(state: state),
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

class _TicketRow extends StatelessWidget {
  final String label;
  final String priceLabel;
  final int count;
  final String decrementId;
  final String incrementId;
  final String countId;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _TicketRow({
    required this.label,
    required this.priceLabel,
    required this.count,
    required this.decrementId,
    required this.incrementId,
    required this.countId,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            Text(priceLabel, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        Row(
          children: [
            Semantics(
              identifier: decrementId,
              container: true,
              child: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: onDecrement,
              ),
            ),
            Semantics(
              identifier: countId,
              container: true,
              child: SizedBox(
                width: 32,
                child: Text('$count', textAlign: TextAlign.center),
              ),
            ),
            Semantics(
              identifier: incrementId,
              container: true,
              child: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: onIncrement,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
