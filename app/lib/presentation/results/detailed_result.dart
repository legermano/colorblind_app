import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/core/stores/user/user_store.dart';
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/domain/entity/ishihara/answer.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:flutter/material.dart';

class DetailedResultsScreen extends StatefulWidget {
  const DetailedResultsScreen({super.key});

  @override
  State<DetailedResultsScreen> createState() => _DetailedResultsScreenState();
}

class _DetailedResultsScreenState extends State<DetailedResultsScreen> {
  //stores:---------------------------------------------------------------------
  final UserStore _userStore = getIt<UserStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: 32),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      centerTitle: true,
      title: Text(
        'Resultados detalhados',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.black.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildInformationText(),
        _buildResultList(),
      ],
    );
  }

  Widget _buildInformationText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        child: Text(
          "Resultados por questão",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.black,
          ),
          // textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _buildResultList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: List<ListTile>.generate(
            _userStore.answers.length,
            (index) => _buildResultTitle(index),
          ),
        ),
      ),
    );
  }

  ListTile _buildResultTitle(int index) {
    Answer answer = _userStore.answers[index];

    return ListTile(
      shape: (index < _userStore.answers.length - 1)
          ? Border(
              bottom: BorderSide(color: AppColors.black.withOpacity(0.1)),
            )
          : null,
      leading: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${answer.plate.order}",
              style: TextStyle(
                color: AppColors.black.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            Image.asset(
              "assets/images/ishihara/plate-${answer.plate.order}.png",
              height: 76,
              width: 76,
            ),
          ],
        ),
      ),
      title: RichText(
        text: TextSpan(
          style: TextStyle(
            color: AppColors.black.withOpacity(0.8),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          children: [
            TextSpan(text: "Sua resposta"),
            WidgetSpan(child: Padding(padding: EdgeInsets.only(left: 6))),
            TextSpan(
              text: "${answer.answer ?? '-'}",
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          style: TextStyle(
            color: AppColors.black.withOpacity(0.8),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          children: [
            TextSpan(text: "Visão típica"),
            WidgetSpan(child: Padding(padding: EdgeInsets.only(left: 15))),
            TextSpan(
              text: "${answer.plate.normal ?? '-'}",
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: OutlinedButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "Concluir",
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            )),
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.home,
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }
}
