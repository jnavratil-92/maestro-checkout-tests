# Maestro Booking Demo

A Flutter demo app for a booking/checkout flow (tickets → date/time → questions → payment → success).

## Running the app

```bash
flutter pub get
flutter devices        # confirm an emulator/device is available
flutter run
```

Needs the Android SDK plus a running emulator or a physical device with USB debugging enabled — Maestro drives the app through Android/iOS, not the web build. `flutter doctor` will tell you what's missing.

## Unit tests

```bash
flutter test
```

## Maestro E2E tests

```
test/maestro/
├── variables.js                              # shared ids, texts, prices, timeouts
├── subflows/                                 # reusable steps
├── 01_purchase_flow.yaml                     # required scenario
├── 02_payment_declined_bonus.yaml            # the assignment's "Optional Bonus"
├── 03_ticket_quantity_limit_extra.yaml       # extra: 20-ticket combined cap
├── 04_promo_code_variations_extra.yaml       # extra: promo code edge cases
└── 05_product_date_dependencies_extra.yaml   # extra: date/time dependencies between products
```

- **`01_purchase_flow.yaml`** covers the assignment's 6 scenario steps end to end (package → tickets → date/time → questions → checkout → success) plus its called-out negative cases (child-without-adult, empty Questions, product 1 locked until product 0 is confirmed).
- **`02_payment_declined_bonus.yaml`** is the assignment's own "Optional Bonus": the real card Payment screen — validation and the always-declined outcome — which `01_purchase_flow.yaml` skips by paying via promo code.
- **`03_ticket_quantity_limit_extra.yaml`–`05_product_date_dependencies_extra.yaml`** are additional coverage beyond the assignment.

`test/maestro/FINDINGS.md` has the app bugs, accessibility gaps, and UX notes found while writing these flows.

Prerequisites:

- Flutter SDK + deps (`flutter pub get` from the repo root) and the app built/installed (`flutter build apk --debug && flutter install`).
- [Maestro CLI](https://docs.maestro.dev/getting-started/installing-maestro): `brew install --formula mobile-dev-inc/tap/maestro` (use `--formula`, not the cask — same name, unrelated app).
- JDK 17+, with `JAVA_HOME` pointed at it (`export JAVA_HOME=$(/usr/libexec/java_home -v 17)` if Maestro fails outright).
- A connected device or running emulator, visible in `adb devices`.

Run:

```bash
maestro test test/maestro/                                    # everything
maestro test test/maestro/01_purchase_flow.yaml                # one file
maestro test test/maestro/ --include-tags=payment              # by tag
```

## Assumptions & known limitations

- **Ticket quantities are fixed (2 adults + 1 child)**, not random as suggested — this Maestro version can't reliably drive a dynamic tap count (`repeat: times`/`while` either loops forever or never runs, and this Maestro version rejects YAML anchors/aliases so a loop couldn't be shortened that way either), so a fixed, documented quantity was more stable.
- **Language pinned to English** so the few selectors with no Maestro id (matched by visible text) don't depend on device locale.
- **No fixed sleeps** — screens show a random 3–8s loading overlay; flows wait on the destination screen's id instead.
- **Timeslots forced open** via a debug-only button, otherwise Madame Tussauds' slots empty out after 15:00 and tests would fail every evening for reasons unrelated to the app.
- **Success only via a free order** — real card payment always declines by design (`payment_screen.dart:11-15`), so `01_purchase_flow.yaml` pays with `MAESTROFREE`; `02_payment_declined_bonus.yaml` covers the real Payment screen and the decline itself.
- **The promo field doesn't exist until you unlock it.** It's not just missing from Checkout — it isn't in the Questions page's widget tree at all until you tap "Enter promo" on Checkout (which itself just shows a fake `Error.` and goes nowhere) and go back a step. See `test/maestro/FINDINGS.md` for the exact mechanism.
- **Replacing text in a field that already has a value long-presses it first, then clears generously** — different keyboards select differently on long-press, so we clear more than the field could ever hold rather than relying on exactly what got selected.

## Local emulator vs physical device

All 5 flows pass on both a physical Android device (Samsung, Android 13) and a local emulator (Pixel 9, API 35). Target one specifically with `maestro test --device <id-or-serial>`; if one won't connect, try the other. A device that's fallen asleep trips up the first step of a run — wake it first with `adb shell input keyevent KEYCODE_WAKEUP`.

## Next scenarios to cover

- Payment-screen overflow as a visual-regression check.
- A locale-switch check for the language mix.
- App kill/relaunch mid-flow, to check state survives a process death.
- The calendar's 52-week booking window boundary.
- General same-day timeslot ordering across all products, not just the one pair `05_product_date_dependencies_extra.yaml` currently checks.
- An explicit assert on the Reset link's own appearance (absent initially, shows up after an edit).
