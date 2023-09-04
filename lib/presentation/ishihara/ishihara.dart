import 'dart:async';

import 'package:boilerplate/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IshiharaScreen extends StatefulWidget {
  const IshiharaScreen({super.key});

  @override
  State<IshiharaScreen> createState() => _IshiharaScreenState();
}

class _IshiharaScreenState extends State<IshiharaScreen> {
  int seconds = 60;
  Timer? timer;
  TextEditingController _textEditingController = TextEditingController();
  bool isChecked = false;

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          seconds = 60;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildNextButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      toolbarHeight: 60,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: 32),
        onPressed: () {
          //TODO: Ask if really want do go back without fishing the questions
          Navigator.of(context).pop();
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildTimer(),
        )
      ],
      centerTitle: true,
      flexibleSpace: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          '7/12',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          "$seconds",
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 46,
          height: 46,
          child: CircularProgressIndicator(
            value: seconds / 60,
            valueColor: const AlwaysStoppedAnimation(AppColors.black),
            backgroundColor: Color(0xFFF0F0F0),
          ),
        )
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 58, vertical: 12),
            child: Text(
              'Qual o númerto no centro do círculo?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          _buildPlate(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: _buildAnswerCard(),
          ),
          _buildCheckbox()
        ],
      ),
    );
  }

  Widget _buildPlate() {
    return Image.asset(
      'assets/images/ishihara/plate_01.png',
      height: MediaQuery.of(context).size.height * 0.35,
      fit: BoxFit.contain,
    );
  }

  Widget _buildAnswerCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Escreva sua resposta',
              style: TextStyle(color: AppColors.black),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Digite aqui...',
                hintStyle: TextStyle(
                  color: AppColors.black.withOpacity(0.20),
                ),
                fillColor: AppColors.black.withOpacity(0.05),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: isChecked,
            activeColor: AppColors.black,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
              });
            },
            fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return AppColors.black;
            }),
          ),
          Text('Não vejo nenhum número'),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: OutlinedButton(
        child: Text(
          'Próximo',
          style: TextStyle(color: AppColors.white),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          minimumSize: Size.fromHeight(56),
        ),
        onPressed: () {},
      ),
    );
  }
}
