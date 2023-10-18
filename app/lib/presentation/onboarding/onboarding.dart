import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/presentation/onboarding/store/onboarding_store.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingStore _onboardingStore = getIt<OnboardingStore>();

  PageController _pageController = PageController();
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(bottom: 160),
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _isLastPage = index == 2),
            children: [
              buildPage(
                  svgPath: 'assets/svg/onboarding-page1.svg',
                  title: 'Entenda o que é o daltonismo',
                  subtitle:
                      'Encontre informações para compreender sobre os diferentes tipos e graus de daltonismo'),
              buildPage(
                  svgPath: 'assets/svg/onboarding-page2.svg',
                  title: 'Descubra se você é daltônico',
                  subtitle:
                      'Realize o teste de Ishihara para descobrir em poucos minutos se você tem algum grau de daltonismo'),
              buildPage(
                  svgPath: 'assets/svg/onboarding-page1.svg',
                  title: 'Veja o mundo com outras cores',
                  subtitle:
                      'Use sua câmera para ver o mundo pelo olhar dos diferentes tipos de daltonismo, além de descobrir a cor real dos objetos a sua volta'),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 160,
        color: AppColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.blue,
                    dotColor: AppColors.blue.withOpacity(0.2),
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _isLastPage
                  ? OutlinedButton(
                      child: Text(
                        'Começar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await _onboardingStore.complete();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.home,
                          (Route<dynamic> route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(0),
                        padding: EdgeInsets.symmetric(
                          horizontal: 44,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        backgroundColor: AppColors.blue,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: const Text(
                            'Pular',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 44,
                              vertical: 20,
                            ),
                          ),
                          onPressed: () => _pageController.jumpToPage(2),
                        ),
                        OutlinedButton(
                          child: Text(
                            'Próximo',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 44,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            backgroundColor: AppColors.blue,
                          ),
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPage({
    required String svgPath,
    required String title,
    required String subtitle,
  }) =>
      Container(
        color: AppColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svgPath),
            const SizedBox(height: 64),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 68),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 68),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.black.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      );
}
