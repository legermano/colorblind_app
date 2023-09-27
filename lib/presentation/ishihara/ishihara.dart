import 'dart:async';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/core/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/presentation/ishihara/store/ishihara_store.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class IshiharaScreen extends StatefulWidget {
  const IshiharaScreen({super.key});

  @override
  State<IshiharaScreen> createState() => _IshiharaScreenState();
}

class _IshiharaScreenState extends State<IshiharaScreen> {
  //stores:---------------------------------------------------------------------
  final IshiharaStore _ishiharaStore = getIt<IshiharaStore>();

  //const:----------------------------------------------------------------------
  static const int ANSWER_SECONDS = 60;

  //variables: -----------------------------------------------------------------
  int seconds = ANSWER_SECONDS;
  Timer? timer;
  TextEditingController _textEditingController = TextEditingController();
  bool isChecked = false;

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          onSetAnswer();
        }
      });
    });
  }

  onSetAnswer() {
    _ishiharaStore.setAnswer(_textEditingController.value.text, isChecked);

    if (_ishiharaStore.currentPlate >= _ishiharaStore.platesQuantity) {
      _ishiharaStore.concludeTest();
      Navigator.of(context).pushReplacementNamed(Routes.results);
    } else {
      seconds = ANSWER_SECONDS;
      _ishiharaStore.nextPlate();
      _textEditingController.text = '';
      isChecked = false;
    }
  }

  @override
  void initState() {
    super.initState();

    // check to see if already called api
    if (!_ishiharaStore.platesLoading) {
      _ishiharaStore.getPlates();
    }
    _ishiharaStore.resetTest();

    startTimer();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return _ishiharaStore.platesLoading
          ? CustomProgressIndicatorWidget()
          : Scaffold(
              appBar: _buildAppBar(),
              body: Stack(
                children: <Widget>[
                  _handleErrorMessage(),
                  _buildBody(),
                ],
              ),
              bottomNavigationBar: _buildNextButton(),
            );
    });
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
        child: Observer(
          builder: (_) => Text(
            '${_ishiharaStore.currentPlate}/${_ishiharaStore.platesQuantity}',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
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
      "assets/images/ishihara/plate-${_ishiharaStore.currentPlate}.png",
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
          GestureDetector(
            child: Text('Não vejo nenhum número'),
            onTap: () {
              setState(() {
                isChecked = !isChecked;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: OutlinedButton(
        child: Observer(
          builder: (_) => Text(
            _ishiharaStore.currentPlate >= _ishiharaStore.platesQuantity
                ? 'Concluir'
                : 'Próximo',
            style: TextStyle(color: AppColors.white),
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          minimumSize: Size.fromHeight(56),
        ),
        onPressed: () => onSetAnswer(),
      ),
    );
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_ishiharaStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_ishiharaStore.errorStore.errorMessage);
        }

        return SizedBox.shrink();
      },
    );
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: 'Erro',
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }
}
