class HomeIds {
  static const page = 'Home_Page';
  static const packageButton = 'Home_PackageButton';
  static const languageToggleButton = 'Home_LanguageToggleButton';
}

class TicketsIds {
  static const page = 'Tickets_Page';
  static const adultDecrement = 'Tickets_AdultDecrementButton';
  static const adultIncrement = 'Tickets_AdultIncrementButton';
  static const adultCount = 'Tickets_AdultCount';
  static const childDecrement = 'Tickets_ChildDecrementButton';
  static const childIncrement = 'Tickets_ChildIncrementButton';
  static const childCount = 'Tickets_ChildCount';
  static const childRequiresAdultError = 'Tickets_ChildRequiresAdultError';
  static const continueButton = 'Tickets_ContinueButton';
}

class DateTimeIds {
  static const page = 'DateTime_Page';
  static const resetSelectionLink = 'DateTime_ResetSelectionLink';
  static const continueButton = 'DateTime_ContinueButton';
  static String selectButton(int productIndex) =>
      'DateTime_Product${productIndex}_SelectButton';
  static String confirmedDate(int productIndex) =>
      'DateTime_Product${productIndex}_ConfirmedDate';
}

class CalendarIds {
  static const dialog = 'Calendar_Dialog';
  static const nextMonthButton = 'Calendar_NextMonthButton';
  static const saveButton = 'Calendar_SaveButton';
  static String day(int dayOfMonth) => 'Calendar_Day$dayOfMonth';
}

class TimeslotIds {
  static const dialog = 'Timeslot_Dialog';
  static const lockedDateText = 'Timeslot_LockedDateText';
  static const closedMessage = 'Timeslot_ClosedMessage';
  static const saveButton = 'Timeslot_SaveButton';
  static String slot(String time) => 'Timeslot_Slot_$time';
}

class QuestionsIds {
  static const page = 'Questions_Page';
  static const promoCodeField = 'Questions_PromoCodeField';
  static const bookingTextArea = 'Questions_BookingTextArea';
  static const bookingCheckbox = 'Questions_BookingCheckbox';
  static const bookingSelect = 'Questions_BookingSelect';
  static const bookingSelectOptional = 'Questions_BookingSelectOptional';
  static String bookingRadio(String option) => 'Questions_BookingRadio_$option';
  static String perTicketCheckbox(int index) =>
      'Questions_PerTicketCheckbox_$index';
  static String perTicketRadio(int index, String option) =>
      'Questions_PerTicketRadio_${index}_$option';
  static const validationError = 'Questions_ValidationError';
  static const continueButton = 'Questions_ContinueButton';
}

class CheckoutIds {
  static const page = 'Checkout_Page';
  static const priceTotal = 'Checkout_PriceTotal';
  static const enterPromoButton = 'Checkout_EnterPromoButton';
  static const promoAppliedChip = 'Checkout_PromoAppliedChip';
  static const removePromoButton = 'Checkout_RemovePromoButton';
  static const firstNameField = 'Checkout_FirstNameField';
  static const firstNameError = 'Checkout_FirstNameError';
  static const lastNameField = 'Checkout_LastNameField';
  static const lastNameError = 'Checkout_LastNameError';
  static const cityField = 'Checkout_CityField';
  static const countryField = 'Checkout_CountryField';
  static const countryError = 'Checkout_CountryError';
  static String countryOption(String country) =>
      'Checkout_CountryOption_$country';
  static const stateProvinceField = 'Checkout_StateProvinceField';
  static const stateProvinceError = 'Checkout_StateProvinceError';
  static const bookingTermsCheckbox = 'Checkout_BookingTermsCheckbox';
  static const cancellationTermsCheckbox = 'Checkout_CancellationTermsCheckbox';
  static const payOrConfirmButton = 'Checkout_PayOrConfirmButton';
}

class PaymentIds {
  static const page = 'Payment_Page';
  static const cardNumberField = 'Payment_CardNumberField';
  static const cardNumberError = 'Payment_CardNumberError';
  static const expiryField = 'Payment_ExpiryField';
  static const expiryError = 'Payment_ExpiryError';
  static const cvcField = 'Payment_CvcField';
  static const cvcError = 'Payment_CvcError';
  static const nameOnCardField = 'Payment_NameOnCardField';
  static const payButton = 'Payment_PayButton';
}

class PaymentResultIds {
  static const processingPage = 'PaymentResult_ProcessingPage';
  static const declinedPage = 'PaymentResult_DeclinedPage';
  static const retryButton = 'PaymentResult_RetryButton';
}

class SuccessIds {
  static const page = 'Success_Page';
  static const ticketCard = 'Success_TicketCard';
  static const freeBadge = 'Success_FreeBadge';
  static String unitTypeRow(String unitType) =>
      'Success_UnitTypeRow_$unitType';
  static String productSummary(int productIndex) =>
      'Success_ProductSummary_$productIndex';
  static String dateField(int productIndex) =>
      'Success_Product${productIndex}_DateField';
  static String timeField(int productIndex) =>
      'Success_Product${productIndex}_TimeField';
  static String unitPriceRow(String unitType) =>
      'Success_UnitPriceRow_$unitType';
  static const bookingFeeRow = 'Success_BookingFeeRow';
  static const originalPriceRow = 'Success_OriginalPriceRow';
  static const discountRow = 'Success_DiscountRow';
  static const finalTotal = 'Success_FinalTotal';
  static const primaryActionButton = 'Success_PrimaryActionButton';
}

class LoadingIds {
  static const overlay = 'Loading_Overlay';
}

/// Test-only hooks with no equivalent in a real production app — they exist
/// so Maestro can force Scenario A/B deterministically instead of depending
/// on the real wall-clock time.
class DebugIds {
  static const setLiveButton = 'Debug_SetLiveButton';
  static const setForceOpenButton = 'Debug_SetForceOpenButton';
  static const setForceClosedButton = 'Debug_SetForceClosedButton';
}
