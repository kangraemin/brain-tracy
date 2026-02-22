import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_tracy/features/goal_input/presentation/goal_input_screen.dart';
import 'package:brain_tracy/features/onboarding/application/onboarding_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  static const routePath = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _fadeController.reset();
    _fadeController.forward();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final completeOnboarding = ref.read(completeOnboardingProvider);
    await completeOnboarding();
    if (mounted) context.go(GoalInputScreen.routePath);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Progress dots
            _buildProgressDots(colorScheme),
            // PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildPage1(colorScheme),
                  _buildPage2(colorScheme),
                  _buildPage3(colorScheme),
                  _buildPage4(colorScheme),
                ],
              ),
            ),
            // CTA Button
            _buildCTAButton(colorScheme),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressDots(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          final isActive = index == _currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 32 : 6,
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.primary.withValues(alpha: 0.3),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCTAButton(ColorScheme colorScheme) {
    final isLastPage = _currentPage == 3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton(
          onPressed: isLastPage ? _completeOnboarding : _nextPage,
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor: colorScheme.primary.withValues(alpha: 0.25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLastPage ? '시작하기' : '다음',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              if (isLastPage) ...[
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ─── Page 1: 성취는 명확한 목표에서 시작됩니다 ───

  Widget _buildPage1(ColorScheme colorScheme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMountainIllustration(colorScheme),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFAB00).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flag,
                  color: Color(0xFFE69B00),
                  size: 20,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    height: 1.3,
                  ),
                  children: [
                    const TextSpan(text: '성취는 명확한\n'),
                    TextSpan(
                      text: '목표에서',
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    const TextSpan(text: ' 시작됩니다'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '"Brian Tracy\'s methodology helps you\nachieve your goals faster than you ever\nthought possible."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Page 2: 7단계로 목표를 현실로 ───

  Widget _buildPage2(ColorScheme colorScheme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMountainIllustration(colorScheme),
              const SizedBox(height: 32),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(
                      text: '7단계',
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    const TextSpan(text: '를 실행하세요'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '적고, 기한을 정하고, 할 일을 만들고,\n매일 실행하세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              _buildChecklistCard(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistCard(ColorScheme colorScheme) {
    final items = [
      '목표 구체화하기',
      '마감 기한 설정',
      '리스트 작성',
    ];

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Opacity(
              opacity: 0.6,
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '+4',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '행동 계획 수립 외 3개',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Page 3: 핵심 목표에 집중하세요 ───

  Widget _buildPage3(ColorScheme colorScheme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconIllustration(
                colorScheme,
                icon: Icons.track_changes,
                size: 80,
              ),
              const SizedBox(height: 40),
              Text(
                '24시간 안에\n하나만 이룰 수 있다면?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '가장 중요한 목표에 집중하면\n나머지도 따라옵니다',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Page 4: 지금 바로 시작하세요 ───

  Widget _buildPage4(ColorScheme colorScheme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconIllustration(
                colorScheme,
                icon: Icons.rocket_launch,
                size: 80,
              ),
              const SizedBox(height: 40),
              Text(
                '지금 바로\n시작하세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '완벽한 때는 없습니다.\n오늘이 가장 좋은 날입니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Shared Illustrations ───

  Widget _buildMountainIllustration(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFF8F00).withValues(alpha: 0.9),
            const Color(0xFFFFB300).withValues(alpha: 0.7),
            colorScheme.primary.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sun/moon glow
          Positioned(
            top: 30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          // Mountains
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _MountainPainter(colorScheme),
            ),
          ),
          // Person silhouette on peak
          Positioned(
            bottom: 90,
            child: Icon(
              Icons.person,
              size: 40,
              color: colorScheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
          // Flag on top
          Positioned(
            bottom: 120,
            left: 0,
            right: -10,
            child: Icon(
              Icons.flag,
              size: 18,
              color: const Color(0xFFFFAB00),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconIllustration(
    ColorScheme colorScheme, {
    required IconData icon,
    required double size,
  }) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.08),
            colorScheme.primaryContainer.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary.withValues(alpha: 0.15),
                colorScheme.primaryContainer.withValues(alpha: 0.6),
              ],
            ),
          ),
          child: Icon(
            icon,
            size: size,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

// ─── Mountain CustomPainter ───

class _MountainPainter extends CustomPainter {
  final ColorScheme colorScheme;

  _MountainPainter(this.colorScheme);

  @override
  void paint(Canvas canvas, Size size) {
    // Back mountain (left)
    final backPaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.4);
    final backPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.15, size.height * 0.3)
      ..lineTo(size.width * 0.45, size.height)
      ..close();
    canvas.drawPath(backPath, backPaint);

    // Back mountain (right)
    final backRightPaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.35);
    final backRightPath = Path()
      ..moveTo(size.width * 0.55, size.height)
      ..lineTo(size.width * 0.85, size.height * 0.35)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(backRightPath, backRightPaint);

    // Main mountain (center)
    final mainPaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.6);
    final mainPath = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.5, 0)
      ..lineTo(size.width * 0.8, size.height)
      ..close();
    canvas.drawPath(mainPath, mainPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
