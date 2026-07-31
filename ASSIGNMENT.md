# QA Automation Engineer task (Maestro)

<aside>
💡 Welcome to the next stage of the QA Automation Engineer application process!
We're excited to see your creative talents at work. Below you'll find the
details of the task you need to complete to be considered for this position.

</aside>

# Task Introduction

The main goal of this task is to evaluate your flexibility, perception, and
problem-solving skills in situations that occur during real mobile QA
automation work at Ventrata. You'll be given a small native mobile app that
re-implements the purchase flow of a ticket-booking product, and you'll write
a **Maestro** end-to-end test that drives it from product selection through
to a paid order.

Carefully read through the scenario below and work step by step to ensure a
customer can successfully complete a purchase. The app is intentionally small
and self-contained, but it has a few real behaviours baked in — date/time
rules, validation, a discount code, a payment step — that only show up once
you actually explore it.

The estimated time to complete this task is **3 to 8 hours**, depending on
your experience with Maestro and with mobile automation in general. We
personally verified the full flow end-to-end before sending this out, so we
know the scenario is solvable as written and the app itself works correctly.

## Good to Know Before You Start

**The app is fully local and mocked.** There's no backend, no network calls,
and no API keys involved — everything (pricing, availability, validation)
runs inside the app itself. You won't hit any rate limits or need any
credentials; feel free to relaunch the app and explore it as much as you
like before writing any test code.

**Leveraging your tester's intuition.** This task description doesn't cover
every single interaction or validation point in the app. There will be
moments where your own judgment as a tester matters: is a particular state
worth asserting on, would it cause a real problem for a customer, or is it
an interesting edge case worth covering? Identifying and acting on those is
part of what's being assessed here.

**Element identifiers.** Every interactive element and every piece of text
you'd plausibly need to assert on already has a stable identifier (Maestro
`id`, matching a `Semantics(identifier: ...)` in the app). You do not need to
add or change any app code — this is a test-writing task, not a
app-development one. If, while exploring, you genuinely can't find a
`view id` for something you need, treat that as a finding worth mentioning
in your submission rather than a blocker: describe what's missing and how
you worked around it (e.g. matching on visible text instead or setting up
some kind of fix).

## QA Automation Task: Purchase Flow

**Objective:** Implement a Maestro test (or small set of flows) that
validates the purchase flow for the sample "NYC Icons Express" package —
covering the key user interactions and at least one meaningful validation /
negative case — and hands off a paid order to the Success screen.

### Scenario Steps & Expected Behaviour

1. **Navigate & select the package**
    - Launch the app from a clean state.
    - From the Home screen, select the **NYC Icons Express** package. It
      contains **4 individual products** that will need a date (and
      sometimes a time) later in the flow.
2. **Ticket quantity**
    - The maximum number of tickets per purchase is **20** combined.
    - A **child ticket requires at least one accompanying adult** — verify
      this rule is actually enforced before making your real selection.
    - Pick a random number of Adult and Child tickets (random, within
      the limits above) and continue.
3. **Date & time selection**
    - Only the **first** product in the package initially has a date
      picker. Confirming a date for it unlocks the rest of the products.
    - For at least one of the remaining products, pick a date/time via
      whatever picker the app presents, and confirm it.
    - **Expected outcome:** once every mandatory product has a confirmed
      date (optional products can be left unselected), you can continue to
      the next step.
    - Somewhere in this step, use the **"Reset selection"** option and
      confirm that it actually clears the selections you'd made.
4. **Questions page**
    - Try to continue **without** filling in the required fields first.
    - **Expected outcome:** a validation error blocks you from proceeding.
    - Fill in only the required fields and continue.
5. **Checkout page - Finalizing the order**
    - On the checkout/summary screen, note the total price shown.
    - Fill in the required contact fields on checkout and confirm/pay.
    - **Expected outcome:** the app lands on a **Success** screen that shows
      the paid amount and a summary of what was ordered.
6. **Success page**
    - **Expected outcome:** Check that the order was created with the 
    correct information and that nothing is missing.

### Optional Bonus

If you finish the main task and everything is stable, feel free to add a
second short flow covering an additional edge case of your choosing (e.g. a
different validation error, or a different combination of ticket
quantities/products), or a brief note on what you'd automate next if you had
more time.

## Evaluation Criteria

Your solution will be evaluated on:

- **Task completion** — how well you cover the scenario's key steps and
  critical paths.
- **Test stability** — does it reliably pass on repeated runs, on a freshly
  launched app.
- **Code quality** — clarity and readability of your `.yaml` flow(s), and
  how deliberately you avoid brittle selectors/waits.
- **Navigation skills** - assessing terminal/code orientation and ability 
  to make small, accurate changes.

## Expected Output

A public Git repository containing:

- This project with your Maestro flow(s) added under `test/maestro/` 
  (or wherever you prefer, as long as it's easy to find).
- A short `README` section (or a separate file) explaining how to run your
  test, and briefly noting any assumptions, tradeoffs, or known limitations.

The test should be runnable ideally with a single `maestro test ...`
command.

## Task Submission

Share the public repository link via email within **7 days** of receiving
this assignment. Please make sure the repository is set to public before
submitting.

## What You Can Expect from Us

You can expect a thorough review of your task, including a look at your
Maestro code, along with feedback on anything missing or worth improving.
Good luck!
