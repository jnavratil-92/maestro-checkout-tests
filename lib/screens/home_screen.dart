import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../ids/booking_ids.dart';
import '../l10n/app_strings.dart';
import '../models/booking_state.dart';
import '../widgets/skyline_hero.dart';
import 'tickets_screen.dart';

const Color _kLogoInk = Color(0xFF191E29);

class HomeScreen extends StatefulWidget {
  final BookingState state;

  const HomeScreen({super.key, required this.state});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isCs = state.language == AppLanguage.cs;
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      identifier: HomeIds.page,
      container: true,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: _kLogoInk,
          title: SvgPicture.asset('assets/logo.svg', height: 22),
          actions: [
            Semantics(
              identifier: HomeIds.languageToggleButton,
              container: true,
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: _kLogoInk),
                onPressed: () => setState(
                  () =>
                      state.setLanguage(isCs ? AppLanguage.en : AppLanguage.cs),
                ),
                child: Text(isCs ? 'EN' : 'CS'),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SkylineHero(height: 280),
              Transform.translate(
                offset: const Offset(0, -28),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NYC Icons Express',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _InfoChip(
                                icon: Icons.star_rounded,
                                label: '4.8',
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              _InfoChip(
                                icon: Icons.schedule_rounded,
                                label: isCs ? '1 den' : '1 day',
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            isCs
                                ? 'Skip-the-line vstup na tri vyhliadkové miesta a nočná plavba so výhľadom na mesto.'
                                : 'Skip-the-line access to three panoramic viewpoints, plus a sunset skyline cruise.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isCs ? 'Od 30 €' : 'From €30',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 16),
                          Semantics(
                            identifier: HomeIds.packageButton,
                            container: true,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TicketsScreen(state: state),
                                  ),
                                );
                              },
                              child: Text(
                                isCs ? 'Vybrať tento zájazd' : 'Select this adventure',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
