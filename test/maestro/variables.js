// Central registry of Maestro element ids and fallback texts, mirroring
// lib/ids/booking_ids.dart 1:1. Loaded once per flow via `runScript:
// variables.js`, then referenced as e.g. ${output.ids.tickets.adultPlus}
// or ${output.ids.dateTime.productSelectButton(0)}.

output.ids = {
  home: {
    page: "Home_Page",
    packageButton: "Home_PackageButton",
    languageToggleButton: "Home_LanguageToggleButton",
  },

  tickets: {
    page: "Tickets_Page",
    adultMinus: "Tickets_AdultDecrementButton",
    adultPlus: "Tickets_AdultIncrementButton",
    adultCount: "Tickets_AdultCount",
    childMinus: "Tickets_ChildDecrementButton",
    childPlus: "Tickets_ChildIncrementButton",
    childCount: "Tickets_ChildCount",
    childRequiresAdultError: "Tickets_ChildRequiresAdultError",
    continueButton: "Tickets_ContinueButton",
  },

  dateTime: {
    page: "DateTime_Page",
    resetSelectionLink: "DateTime_ResetSelectionLink",
    continueButton: "DateTime_ContinueButton",
    productSelectButton: (i) => `DateTime_Product${i}_SelectButton`,
    productConfirmedDate: (i) => `DateTime_Product${i}_ConfirmedDate`,
  },

  calendar: {
    dialog: "Calendar_Dialog",
    nextMonthButton: "Calendar_NextMonthButton",
    saveButton: "Calendar_SaveButton",
    day: (dayOfMonth) => `Calendar_Day${dayOfMonth}`,
  },

  timeslot: {
    dialog: "Timeslot_Dialog",
    lockedDateText: "Timeslot_LockedDateText",
    closedMessage: "Timeslot_ClosedMessage",
    saveButton: "Timeslot_SaveButton",
    slot: (time) => `Timeslot_Slot_${time.replace(":", "_")}`,
  },

  questions: {
    page: "Questions_Page",
    promoCodeField: "Questions_PromoCodeField",
    bookingTextArea: "Questions_BookingTextArea",
    bookingCheckbox: "Questions_BookingCheckbox",
    bookingSelect: "Questions_BookingSelect",
    bookingSelectOptional: "Questions_BookingSelectOptional",
    bookingRadio: (option) => `Questions_BookingRadio_${option}`,
    perTicketConfirmCheckbox: (i) => `Questions_PerTicketCheckbox_${i}`,
    perTicketRadio: (i, option) => `Questions_PerTicketRadio_${i}_${option}`,
    validationError: "Questions_ValidationError",
    continueButton: "Questions_ContinueButton",
  },

  checkout: {
    page: "Checkout_Page",
    priceTotal: "Checkout_PriceTotal",
    enterPromoButton: "Checkout_EnterPromoButton",
    promoAppliedChip: "Checkout_PromoAppliedChip",
    removePromoButton: "Checkout_RemovePromoButton",
    firstNameField: "Checkout_FirstNameField",
    firstNameError: "Checkout_FirstNameError",
    lastNameField: "Checkout_LastNameField",
    lastNameError: "Checkout_LastNameError",
    cityField: "Checkout_CityField",
    countryField: "Checkout_CountryField",
    countryError: "Checkout_CountryError",
    countryOption: (country) => `Checkout_CountryOption_${country}`,
    stateProvinceField: "Checkout_StateProvinceField",
    stateProvinceError: "Checkout_StateProvinceError",
    bookingTermsCheckbox: "Checkout_BookingTermsCheckbox",
    cancellationTermsCheckbox: "Checkout_CancellationTermsCheckbox",
    payOrConfirmButton: "Checkout_PayOrConfirmButton",
  },

  payment: {
    page: "Payment_Page",
    cardNumberField: "Payment_CardNumberField",
    cardNumberError: "Payment_CardNumberError",
    expiryField: "Payment_ExpiryField",
    expiryError: "Payment_ExpiryError",
    cvcField: "Payment_CvcField",
    cvcError: "Payment_CvcError",
    nameOnCardField: "Payment_NameOnCardField",
    payButton: "Payment_PayButton",
  },

  paymentResult: {
    processingPage: "PaymentResult_ProcessingPage",
    declinedPage: "PaymentResult_DeclinedPage",
    retryButton: "PaymentResult_RetryButton",
  },

  success: {
    page: "Success_Page",
    ticketCard: "Success_TicketCard",
    freeBadge: "Success_FreeBadge",
    unitTypeRow: (unitType) => `Success_UnitTypeRow_${unitType}`,
    productSummary: (i) => `Success_ProductSummary_${i}`,
    dateField: (i) => `Success_Product${i}_DateField`,
    timeField: (i) => `Success_Product${i}_TimeField`,
    unitPriceRow: (unitType) => `Success_UnitPriceRow_${unitType}`,
    bookingFeeRow: "Success_BookingFeeRow",
    originalPriceRow: "Success_OriginalPriceRow",
    discountRow: "Success_DiscountRow",
    finalTotal: "Success_FinalTotal",
    primaryActionButton: "Success_PrimaryActionButton",
  },

  loading: {
    overlay: "Loading_Overlay",
  },

  debug: {
    setLiveButton: "Debug_SetLiveButton",
    setForceOpenButton: "Debug_SetForceOpenButton",
    setForceClosedButton: "Debug_SetForceClosedButton",
  },
};

// Fallback selector for the handful of elements with no Maestro id in this
// build at all — see FINDINGS.md, "no dedicated id".
output.texts = {
  friendOrFamilyOption: "Friend or family",
  closeButton: "Close",
};

// Expected price totals, as regexes tolerant of both "." and "," decimal
// separators.
output.prices = {
  twoAdultsOneChild: ".*82[.,]50.*",
  oneAdult: ".*33[.,]00.*",
  free: ".*0[.,]00.*",
};

// Shared wait timeouts (ms).
output.timeouts = {
  screenTransition: 15000,
  paymentDecline: 8000,
};
