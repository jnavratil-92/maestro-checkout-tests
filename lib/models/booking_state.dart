import 'package:flutter/foundation.dart';

import '../l10n/app_strings.dart';

class Product {
  final String name;
  final String description;
  final bool required;
  final bool hasTimeSelection;

  const Product({
    required this.name,
    required this.description,
    required this.required,
    this.hasTimeSelection = true,
  });
}

const List<Product> kProducts = [
  Product(
    name: 'Empire State Building – Observatory Admission',
    description:
        'Skip the lines and head straight to the top of one of the '
        "world's most famous skyscrapers.",
    required: true,
  ),
  Product(
    name: 'Madame Tussauds New York',
    description: 'Skip the line and explore the world of wax celebrities.',
    required: true,
  ),
  Product(
    name: 'Hop-on Hop-off - 24 hours',
    description: 'Explore the city at your own pace.',
    required: false,
  ),
  Product(
    name: 'Statue of Liberty & Ellis Island Ferry Tour',
    description: 'Cruise from Battery Park to the Statue of Liberty.',
    required: true,
    // No time slots for this product — only the date (locked to the first
    // product's choice) needs confirming.
    hasTimeSelection: false,
  ),
];

const double kAdultPrice = 30;
const double kChildPrice = 15;
const double kBookingFeePercent = 10;
const int kMaxTickets = 20;

/// Madame Tussauds' fixed hourly timeslots. Matches the assignment's
/// Scenario A/B: available until 15:00 local time, closed for the rest of
/// the day after that (that cutoff is independent of this list — see
/// [BookingState.timeslotsFor]).
const List<String> kMadameTimeslots = [
  '10:00',
  '11:00',
  '12:00',
  '13:00',
  '14:00',
  '15:00',
  '16:00',
];

/// Hop-on Hop-off can only be boarded at least 2 hours after Madame
/// Tussauds' confirmed time (you can't be in two places at once), up to an
/// 18:00 last departure — e.g. Madame at 10:00 leaves the full 12:00-18:00
/// window open, Madame at 16:00 (its own last slot) leaves only 18:00.
List<String> hopOnTimeslotsFor(String madameTime) {
  final madameHour = int.parse(madameTime.split(':')[0]);
  final firstHopOnHour = madameHour + 2;
  return [
    for (var hour = firstHopOnHour; hour <= 18; hour++)
      '${hour.toString().padLeft(2, '0')}:00',
  ];
}

const List<String> kValidPromoCodes = ['CYPRESSFREE', 'MAESTROFREE'];

enum DiscountType { full }

/// A discount applied to the booking via promo code. Only full (100%)
/// discounts exist today, but keeping the amount/type explicit here (rather
/// than a hardcoded zero at render time) leaves room for partial discounts
/// without touching call sites.
class AppliedDiscount {
  final String code;
  final DiscountType type;
  final double amount;

  const AppliedDiscount({
    required this.code,
    required this.type,
    required this.amount,
  });
}

class Country {
  final String code;
  final String displayName;

  const Country(this.code, this.displayName);
}

// "Doporučené" (recommended) country shown first, then the rest
// alphabetically — a trimmed stand-in for the real widget's full country
// list. `code` is an ASCII-safe key for semantic ids; `displayName` is what
// the user sees.
const kRecommendedCountry = Country('cz', 'Česká republika');
const List<Country> kAllCountries = [
  Country('af', 'Afghánistán'),
  Country('al', 'Albánie'),
  Country('dz', 'Alžírsko'),
  Country('fr', 'Francie'),
  Country('de', 'Německo'),
  Country('at', 'Rakousko'),
  Country('sk', 'Slovensko'),
  Country('us', 'Spojené státy'),
];

/// Lets a test force Scenario A/B deterministically instead of depending on
/// the real wall-clock time, which would otherwise make the "closed" branch
/// untestable outside a narrow window of the day.
enum TimeSlotMode { live, forceOpen, forceClosed }

class BookingState extends ChangeNotifier {
  int adultQty = 0;
  int childQty = 0;
  TimeSlotMode timeSlotMode = TimeSlotMode.live;
  AppLanguage language = AppLanguage.cs;

  void setLanguage(AppLanguage lang) {
    language = lang;
    notifyListeners();
  }

  final Map<int, DateTime> selectedDates = {};
  final Map<int, String> selectedTimeslots = {};

  AppliedDiscount? appliedDiscount;

  bool get promoApplied => appliedDiscount != null;
  String? get appliedPromoCode => appliedDiscount?.code;

  // Set once the Checkout page's promo button has been tapped — unlocks the
  // promo code field on the Questions page (hidden until then).
  bool promoHintUnlocked = false;

  void unlockPromoHint() {
    promoHintUnlocked = true;
    notifyListeners();
  }

  // Questions page — a generic showcase of booking-level and per-ticket
  // question types, matching the real Ventrata Checkout widget's demo
  // config (not real per-tour content).
  String bookingQuestionTextArea = '';
  bool bookingQuestionCheckbox = false;
  String? bookingQuestionSelect;
  String? bookingQuestionSelectOptional;
  String? bookingQuestionRadio;
  // One entry per ticket unit (adults then children) — sized to ticketTotal.
  List<bool> perTicketCheckbox = [];
  List<String?> perTicketRadio = [];

  bool get questionsValid =>
      bookingQuestionTextArea.trim().isNotEmpty &&
      bookingQuestionSelect != null &&
      perTicketCheckbox.length == ticketTotal &&
      perTicketCheckbox.every((checked) => checked);

  // Contact/summary page.
  String firstName = '';
  String lastName = '';
  String city = '';
  String country = '';
  String stateProvince = '';
  bool agreedToBookingTerms = false;
  bool agreedToCancellationTerms = false;

  bool get contactValid =>
      firstName.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      country.trim().isNotEmpty &&
      stateProvince.trim().isNotEmpty &&
      agreedToBookingTerms &&
      agreedToCancellationTerms;

  int get ticketTotal => adultQty + childQty;

  bool get canIncrementTickets => ticketTotal < kMaxTickets;

  /// A child ticket must be accompanied by at least one adult.
  bool get childRequiresAdult => childQty > 0 && adultQty == 0;

  bool get canProceedFromTickets => ticketTotal > 0 && !childRequiresAdult;

  void incrementAdult() {
    if (canIncrementTickets) {
      adultQty++;
      notifyListeners();
    }
  }

  void decrementAdult() {
    if (adultQty > 0) {
      adultQty--;
      notifyListeners();
    }
  }

  void incrementChild() {
    if (canIncrementTickets) {
      childQty++;
      notifyListeners();
    }
  }

  void decrementChild() {
    if (childQty > 0) {
      childQty--;
      notifyListeners();
    }
  }

  /// Returns available timeslots for [date] for [productIndex]. Empty list
  /// means "closed" (Scenario B). By default mirrors real slot availability
  /// using the actual system clock (no backend/mock server involved) —
  /// [timeSlotMode] lets a test override that deterministically.
  List<String> timeslotsFor(DateTime date, int productIndex) {
    switch (timeSlotMode) {
      case TimeSlotMode.forceOpen:
        return _baseTimeslotsFor(productIndex);
      case TimeSlotMode.forceClosed:
        return const [];
      case TimeSlotMode.live:
        final now = DateTime.now();
        final isToday =
            date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
        if (isToday && now.hour >= 15) {
          return const [];
        }
        return _baseTimeslotsFor(productIndex);
    }
  }

  /// Hop-on Hop-off (index 2) depends on Madame Tussauds' (index 1) already
  /// confirmed time — see [hopOnTimeslotsFor]. Its select button stays
  /// disabled until that's set, so this should never be reached with a null
  /// Madame time in practice.
  List<String> _baseTimeslotsFor(int productIndex) {
    if (productIndex == 2) {
      final madameTime = selectedTimeslots[1];
      return madameTime == null ? const [] : hopOnTimeslotsFor(madameTime);
    }
    return kMadameTimeslots;
  }

  void setTimeSlotMode(TimeSlotMode mode) {
    timeSlotMode = mode;
    notifyListeners();
  }

  void confirmDate(int productIndex, DateTime date, {String? timeslot}) {
    if (productIndex == 0) {
      // Every other product's date is locked to this one — changing it
      // invalidates whatever was already confirmed for them, since it no
      // longer matches the new date.
      selectedDates.removeWhere((key, _) => key != 0);
      selectedTimeslots.removeWhere((key, _) => key != 0);
    } else if (productIndex == 1) {
      // Hop-on Hop-off's available times depend on Madame Tussauds' time —
      // re-confirming it invalidates whatever Hop-on time was already
      // confirmed, since it may no longer be at least 2 hours later.
      selectedDates.remove(2);
      selectedTimeslots.remove(2);
    }
    selectedDates[productIndex] = date;
    if (timeslot != null) {
      selectedTimeslots[productIndex] = timeslot;
    } else {
      selectedTimeslots.remove(productIndex);
    }
    notifyListeners();
  }

  bool get firstProductConfirmed => selectedDates.containsKey(0);

  int get confirmedCount => selectedDates.length;

  void resetSelection() {
    selectedDates.clear();
    selectedTimeslots.clear();
    appliedDiscount = null;
    promoHintUnlocked = false;
    notifyListeners();
  }

  double get subtotal => adultQty * kAdultPrice + childQty * kChildPrice;

  double get bookingFee => subtotal * kBookingFeePercent / 100;

  /// Total before any discount is applied — preserved separately so the
  /// success page can show both this and the discount that zeroed it out.
  double get preDiscountTotal => subtotal + bookingFee;

  double get total {
    final discount = appliedDiscount;
    if (discount == null) return preDiscountTotal;
    return (preDiscountTotal - discount.amount).clamp(0, double.infinity);
  }

  bool get isFree => total == 0;

  bool applyPromoCode(String code) {
    final normalized = code.trim().toUpperCase();
    if (kValidPromoCodes.contains(normalized)) {
      appliedDiscount = AppliedDiscount(
        code: normalized,
        type: DiscountType.full,
        amount: preDiscountTotal,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    appliedDiscount = null;
    notifyListeners();
  }
}
