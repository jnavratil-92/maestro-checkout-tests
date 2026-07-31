import 'package:flutter/material.dart';

import '../ids/booking_ids.dart';
import '../l10n/app_strings.dart';
import '../models/booking_state.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';

/// Terminal screen for a completed (free/promo) order. Back navigation is
/// blocked entirely — the only way forward is the Home button, which starts
/// a brand new flow with a fresh [BookingState] rather than allowing the
/// user back into the now-completed order.
class SuccessScreen extends StatelessWidget {
  final BookingState state;
  final String orderCode;

  const SuccessScreen({
    super.key,
    required this.state,
    required this.orderCode,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(state.language);
    final theme = Theme.of(context);
    final successColor =
        theme.extension<AppColors>()?.success ?? theme.colorScheme.primary;

    return PopScope(
      canPop: false,
      child: Semantics(
        identifier: SuccessIds.page,
        container: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text(strings.successPageTitle),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.check_circle, color: successColor, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    strings.thankYouMessage,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  Semantics(
                    identifier: SuccessIds.ticketCard,
                    container: true,
                    child: _TicketCard(
                      state: state,
                      orderCode: orderCode,
                      strings: strings,
                      successColor: successColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Semantics(
                    identifier: SuccessIds.primaryActionButton,
                    container: true,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => HomeScreen(state: BookingState()),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(strings.newBookingButtonLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UnitLine {
  final String key;
  final String label;
  final int qty;
  final double unitPrice;

  const _UnitLine({
    required this.key,
    required this.label,
    required this.qty,
    required this.unitPrice,
  });

  double get lineTotal => qty * unitPrice;
}

List<_UnitLine> _unitLines(BookingState state, AppStrings strings) => [
  if (state.adultQty > 0)
    _UnitLine(
      key: 'adult',
      label: strings.adultLabel,
      qty: state.adultQty,
      unitPrice: kAdultPrice,
    ),
  if (state.childQty > 0)
    _UnitLine(
      key: 'child',
      label: strings.childLabel,
      qty: state.childQty,
      unitPrice: kChildPrice,
    ),
];

/// The ticket itself: a body listing what was booked, a perforated tear
/// line, then a price stub with the breakdown down to the final 0.00 total.
class _TicketCard extends StatelessWidget {
  final BookingState state;
  final String orderCode;
  final AppStrings strings;
  final Color successColor;

  const _TicketCard({
    required this.state,
    required this.orderCode,
    required this.strings,
    required this.successColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unitLines = _unitLines(state, strings);

    return Card(
      clipBehavior: Clip.none,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  child: Semantics(
                    identifier: SuccessIds.freeBadge,
                    container: true,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: successColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        strings.freeBadgeLabel,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: successColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${strings.orderCodeLabel}: $orderCode',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Text(
                  strings.orderSummaryLabel,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                for (final line in unitLines)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Semantics(
                      identifier: SuccessIds.unitTypeRow(line.key),
                      container: true,
                      child: Text('${line.qty} × ${line.label}'),
                    ),
                  ),
                const SizedBox(height: 8),
                for (var i = 0; i < kProducts.length; i++)
                  if (state.selectedDates[i] case final date?)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Semantics(
                        identifier: SuccessIds.productSummary(i),
                        container: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kProducts[i].name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Wrap(
                              spacing: 12,
                              runSpacing: 2,
                              children: [
                                Semantics(
                                  identifier: SuccessIds.dateField(i),
                                  container: true,
                                  child: Text(
                                    '${date.day}. ${date.month}. ${date.year}',
                                  ),
                                ),
                                if (state.selectedTimeslots[i]
                                    case final time?)
                                  Semantics(
                                    identifier: SuccessIds.timeField(i),
                                    container: true,
                                    child: Text(time),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
          const _TicketDivider(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final line in unitLines)
                  Semantics(
                    identifier: SuccessIds.unitPriceRow(line.key),
                    container: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '${line.label} '
                              '(${line.qty} × ${line.unitPrice.toStringAsFixed(2)} €)',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${line.lineTotal.toStringAsFixed(2)} €'),
                        ],
                      ),
                    ),
                  ),
                Semantics(
                  identifier: SuccessIds.bookingFeeRow,
                  container: true,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${strings.bookingFeeLabel} '
                          '(${kBookingFeePercent.toStringAsFixed(0)}%)',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${state.bookingFee.toStringAsFixed(2)} €'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Semantics(
                  identifier: SuccessIds.originalPriceRow,
                  container: true,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(strings.originalPriceLabel)),
                      const SizedBox(width: 8),
                      Text(
                        '${state.preDiscountTotal.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.appliedDiscount case final discount?)
                  Semantics(
                    identifier: SuccessIds.discountRow,
                    container: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              strings.discountLabel,
                              style: TextStyle(
                                color: successColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '-${discount.amount.toStringAsFixed(2)} €',
                            style: TextStyle(
                              color: successColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Semantics(
                  identifier: SuccessIds.finalTotal,
                  container: true,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          strings.finalTotalLabel,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${state.total.toStringAsFixed(2)} €',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: successColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The perforated tear line between the ticket body and its price stub —
/// a dashed rule with a semicircular notch cut into both edges.
class _TicketDivider extends StatelessWidget {
  const _TicketDivider();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 24,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: LayoutBuilder(
              builder: (context, constraints) => CustomPaint(
                size: Size(constraints.maxWidth, 1),
                painter: _DashedLinePainter(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
          ),
          Positioned(
            left: -12,
            child: _Notch(color: theme.scaffoldBackgroundColor),
          ),
          Positioned(
            right: -12,
            child: _Notch(color: theme.scaffoldBackgroundColor),
          ),
        ],
      ),
    );
  }
}

class _Notch extends StatelessWidget {
  final Color color;

  const _Notch({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    var startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
