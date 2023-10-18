import 'package:boilerplate/constants/colorblind_type.dart';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/core/stores/user/user_store.dart';
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  //stores:---------------------------------------------------------------------
  final UserStore _userStore = getIt<UserStore>();

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: _buildBotttomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: 32),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        'Resultados',
        style: TextStyle(
          color: AppColors.black.withOpacity(0.8),
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final bool hasColorblind = _userStore.result != ColorblindTypes.normal;

    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hasColorblind ? "Daltonismo tipo" : "Você não possui daltonismo",
            style: TextStyle(
              color: AppColors.black.withOpacity(0.8),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          if (hasColorblind)
            Text(
              _userStore.result.toUpperCase(),
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          _buildArcPercentageIndicator(),
          Padding(
            padding: const EdgeInsets.only(
              left: 46,
              right: 46,
              bottom: 50,
            ),
            child: Text(
              hasColorblind
                  ? "das suas respostas se encaixam em um quadro de visão normal"
                  : "das suas respostas se encaixam em um quadro de daltonismo do tipo ${_userStore.result}.",
              style: TextStyle(
                color: AppColors.black.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (hasColorblind)
            TextButton(
              child: Text(
                "O que é ${_userStore.result}?",
                style: TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
              onPressed: () {
                String? route;

                switch (_userStore.result) {
                  case ColorblindTypes.protan:
                    route = Routes.aboutProtan;
                    break;
                  case ColorblindTypes.deutan:
                    route = Routes.aboutDeutan;
                    break;
                }

                if(route != null) {
                  Navigator.of(context).pushNamed(route);
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildArcPercentageIndicator() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 78,
        top: 80,
        right: 78,
        bottom: 24,
      ),
      child: DashedCircularProgressBar.aspectRatio(
        aspectRatio: 2,
        valueNotifier: _valueNotifier,
        progress: _userStore.percentage,
        startAngle: 270,
        sweepAngle: 180,
        foregroundColor: AppColors.blue,
        backgroundColor: Color(0xFFF0F0F0),
        foregroundStrokeWidth: 15,
        backgroundStrokeWidth: 15,
        animation: true,
        circleCenterAlignment: Alignment.bottomCenter,
        child: Container(
          alignment: Alignment.bottomCenter,
          child: ValueListenableBuilder(
            valueListenable: _valueNotifier,
            builder: (_, double value, __) => RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${value.toInt()}",
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 46,
                    ),
                  ),
                  TextSpan(
                    text: "%",
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
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

  Widget _buildBotttomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton(
            child: Text(
              "Ver resultado detalhado",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(Routes.detailedResults),
          ),
          TextButton(
            child: Text(
              "Voltar ao início",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.home,
              (Route<dynamic> route) => false,
            ),
          )
        ],
      ),
    );
  }
}
