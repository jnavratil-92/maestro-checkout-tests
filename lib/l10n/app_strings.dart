enum AppLanguage { cs, en }

/// Minimal hand-rolled string table — this is a demo app, not a candidate
/// for full Flutter intl/.arb codegen.
class AppStrings {
  final AppLanguage language;

  const AppStrings(this.language);

  bool get _isCs => language == AppLanguage.cs;

  String get ticketsPageTitle => _isCs ? 'Vstupenky' : 'Tickets';
  String get adultLabel => _isCs ? 'Dospělý' : 'Adult';
  String get childLabel => _isCs ? 'Dítě' : 'Child';
  String get fromPricePrefix => _isCs ? 'Od' : 'From';
  String get continueLabel => _isCs ? 'Pokračovat' : 'Continue';
  String get childRequiresAdultMessage => _isCs
      ? 'Dítě musí být v doprovodu alespoň jednoho dospělého.'
      : 'A child ticket requires at least one adult.';

  String get dateTimePageTitle => _isCs ? 'Datum A Čas' : 'Date & Time';
  String get resetSelectionLabel =>
      _isCs ? 'Resetovat výběr' : 'Reset selection';
  String get selectDateTimeLabel =>
      _isCs ? 'Vyberte datum a čas' : 'Select date and time';
  String get editLabel => _isCs ? 'Upravit' : 'Edit';
  String get optionalSuffix => _isCs ? ' (volitelný)' : ' (optional)';

  String get saveLabel => _isCs ? 'Uložit' : 'Save';
  String get selectedDateLabel => _isCs ? 'Vybrané datum' : 'Selected date';
  String get cannotChangeDateNote => _isCs
      ? 'Nelze změnit, je to založeno na vaší návštěvě.'
      : "Can't be changed, it's based on your visit.";
  String get selectTimeLabel => _isCs ? 'Vyberte čas' : 'Select time';

  String get timeslotsClosedMessage => _isCs
      ? 'Všechny časy jsou pro dnešek uzavřeny.'
      : 'All times are closed for today.';
  String get closeLabel => _isCs ? 'Zavřít' : 'Close';

  // Questions page.
  String get questionsPageTitle =>
      _isCs ? 'Doplňující Informace' : 'Additional Information';
  String get pleaseCompleteAdditionalInfo => _isCs
      ? 'Prosím, doplňte další údaje'
      : 'Please complete additional details';
  String get requiredFieldsLegend => _isCs ? 'Povinná pole' : 'Required fields';
  String get fieldRequiredMessage =>
      _isCs ? 'Toto pole je povinné.' : 'This field is required.';
  String get selectPlaceholder =>
      _isCs ? 'Prosím, zvolte variantu' : 'Please choose an option';
  String get radioNoneOption => _isCs ? 'Žádný' : 'None';

  // Booking-level questions.
  String get bookingQuestionTextAreaLabel =>
      _isCs ? 'Jak se dostavíte na místo srazu?' : 'How will you be arriving?';
  String get bookingQuestionTextAreaHint => _isCs
      ? 'např. metrem, taxíkem nebo pěšky'
      : 'e.g. by subway, taxi, or on foot';
  String get bookingQuestionCheckboxLabel =>
      _isCs ? 'Potřeby týkající se přístupnosti' : 'Accessibility needs';
  String get bookingQuestionCheckboxOption => _isCs
      ? 'Vyžaduji bezbariérový přístup'
      : 'Wheelchair access required';
  String get bookingQuestionSelectLabel =>
      _isCs ? 'Odkud jste se o nás dozvěděli?' : 'How did you hear about us?';
  String get bookingQuestionSelectHint =>
      _isCs ? 'Prosím, zvolte variantu' : 'Please select an option';
  List<String> get bookingQuestionSelectOptions => _isCs
      ? [
          'Od přátel nebo rodiny',
          'Sociální sítě',
          'Cestovatelský web',
          'Concierge hotelu',
        ]
      : ['Friend or family', 'Social media', 'Travel website', 'Hotel concierge'];
  String get bookingQuestionSelectOptionalLabel =>
      _isCs ? 'Preferovaný jazyk průvodce' : 'Preferred tour guide language';
  List<String> get bookingQuestionSelectOptionalOptions => _isCs
      ? ['Angličtina', 'Španělština', 'Francouzština', 'Němčina']
      : ['English', 'Spanish', 'French', 'German'];
  String get bookingQuestionRadioLabel => _isCs
      ? 'Budete potřebovat úschovnu zavazadel během prohlídky?'
      : 'Will you need luggage storage during the tour?';
  List<String> get bookingQuestionRadioOptions =>
      _isCs ? ['Ano', 'Ne'] : ['Yes', 'No'];

  // Per-ticket questions.
  String get perTicketCheckboxLabel =>
      _isCs ? 'Potvrzení držitele vstupenky' : 'Ticket holder confirmation';
  String get perTicketCheckboxHint => _isCs
      ? 'Zaškrtnutím potvrzujete, že tento držitel vstupenky splňuje '
          'věkový požadavek pro tento typ vstupenky.'
      : 'By checking this box, you confirm this ticket holder meets the '
          'age requirement for this ticket type.';
  String get perTicketCheckboxOption => _isCs ? 'Potvrzuji' : 'I confirm';
  String get perTicketRadioLabel => _isCs
      ? 'Velikost trička (dárek k této vstupence)'
      : 'Souvenir T-shirt size (included with this ticket)';
  List<String> get perTicketRadioOptions => const ['S', 'M', 'L'];

  // Checkout / summary page.
  String get checkoutPageTitle => _isCs ? 'Shrnutí' : 'Summary';
  String get contactDetailsLabel =>
      _isCs ? 'Kontaktní údaje' : 'Contact details';
  String get firstNameLabel => _isCs ? 'Jméno' : 'First name';
  String get lastNameLabel => _isCs ? 'Příjmení' : 'Last name';
  String get cityLabel => _isCs ? 'Město' : 'City';
  String get countryLabel => _isCs ? 'Země' : 'Country';
  String get countryPlaceholder => _isCs ? 'Vyberte zemi' : 'Select country';
  String get stateProvinceLabel => _isCs ? 'Stát/Provincie' : 'State/Province';
  String get bookingTermsLabel => _isCs
      ? 'Souhlasím s podmínkami rezervace.'
      : 'I agree to the booking terms.';
  String get cancellationTermsLabel => _isCs
      ? 'Souhlasím se storno podmínkami v případě, že budu žádat o vrácení peněz.'
      : 'I agree to the cancellation terms in case I request a refund.';
  String get requiredCheckboxError => _isCs ? 'Vyžadováno' : 'Required';
  String get totalLabel => _isCs ? 'Celkem' : 'Total';
  String get amountDueLabel =>
      _isCs ? 'K úhradě s DPH' : 'Amount due incl. VAT';
  String get promoCodeLabel => _isCs ? 'Promo kód' : 'Promo code';
  String get enterPromoLabel => _isCs
      ? 'Vložte promo kód / dárkový poukaz'
      : 'Enter promo code / gift voucher';
  String get promoAppliedChipLabel =>
      _isCs ? 'Promo akce (FREE)' : 'Promo (FREE)';
  String get payLabel => _isCs ? 'Zaplatit' : 'Pay';
  String get confirmOrderLabel =>
      _isCs ? 'Potvrdit objednávku' : 'Confirm order';

  // Payment page.
  String get paymentPageTitle => _isCs ? 'Platba' : 'Payment';
  String get cardPaymentLabel => _isCs ? 'Platba kartou' : 'Card payment';
  String get allFieldsRequiredNote => _isCs
      ? 'Všechna pole jsou povinná, pokud není uvedeno jinak.'
      : 'All fields are required unless stated otherwise.';
  String get cardNumberLabel => _isCs ? 'Číslo karty' : 'Card number';
  String get expiryLabel => _isCs ? 'Konec platnosti' : 'Expiry date';
  String get cvcLabel => _isCs ? 'Bezpečnostní kód' : 'Security code';
  String get nameOnCardLabel => _isCs ? 'Jméno na kartě' : 'Name on card';
  String get cardNumberInvalidMessage => _isCs
      ? 'Číslo karty musí mít 16 číslic.'
      : 'Card number must be 16 digits.';
  String get expiryInvalidMessage => _isCs
      ? 'Konec platnosti musí být ve formátu MMRR (4 číslice).'
      : 'Expiry must be in MMYY format (4 digits).';
  String get cvcInvalidMessage => _isCs
      ? 'Bezpečnostní kód musí mít 3 číslice.'
      : 'Security code must be 3 digits.';

  // Payment result.
  String get processingLabel => _isCs
      ? 'Vaše platba se zpracovává...'
      : 'Your payment is being processed...';
  String get declinedTitle => _isCs ? 'Platba zamítnuta' : 'Payment declined';
  String get declinedMessage => _isCs
      ? 'Došlo k problému při zpracování vaší platby. Zkontrolujte prosím své platební údaje nebo zkuste jinou metodu.'
      : 'There was a problem processing your payment. Please check your payment details or try another method.';
  String get orderCodeLabel => _isCs ? 'Kód objednávky' : 'Order code';
  String get retryLabel => _isCs ? 'Zkusit znovu' : 'Try again';
  String get cvcDeclinedBanner => 'CVC Declined';

  // Success page.
  String get successPageTitle => _isCs ? 'Úspěch' : 'Success';
  String get thankYouMessage =>
      _isCs ? 'Děkujeme Vám za nákup!' : 'Thank you for your purchase!';
  String get freeBadgeLabel => _isCs ? 'Objednávka zdarma' : 'Order is free';
  String get orderSummaryLabel =>
      _isCs ? 'Shrnutí objednávky' : 'Order summary';
  String get bookingFeeLabel => _isCs ? 'Poplatek za rezervaci' : 'Booking fee';
  String get originalPriceLabel => _isCs ? 'Původní cena' : 'Original price';
  String get discountLabel =>
      _isCs ? 'Sleva (promo kód)' : 'Discount (promo code)';
  String get finalTotalLabel => _isCs ? 'K úhradě' : 'Total due';
  String get newBookingButtonLabel => _isCs ? 'Domů' : 'Home';
}
