import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/core/stores/form/form_store.dart';
import 'package:boilerplate/core/widgets/empty_app_bar_widget.dart';
import 'package:boilerplate/core/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/core/widgets/rounded_button_widget.dart';
import 'package:boilerplate/core/widgets/textfield_widget.dart';
import 'package:boilerplate/presentation/login/store/login_store.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../di/service_locator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //stores:---------------------------------------------------------------------
  final FormStore _formStore = getIt<FormStore>();
  final LoginStore _loginStore = getIt<LoginStore>();

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBottom(),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBottom() {
    return Material(
      child: Stack(
        children: <Widget>[
          _buildForm(),
          Observer(
            builder: (context) {
              return _loginStore.success
                  ? navigate(context)
                  : _showErrorMessage(_formStore.errorStore.errorMessage);
            },
          ),
          Observer(
            builder: (context) {
              return Visibility(
                visible: _loginStore.isLoading,
                child: CustomProgressIndicatorWidget(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                SizedBox(height: 24.0),
                _buildUserEmailLabel(),
                _buildUserEmailField(),
                _buildPasswordLabel(),
                _buildPasswordField(),
                _buildForgotPasswordButton(),
                _buildSignInButton(),
                _buildOrDivider(),
                _buildGoogleSignInButton(),
                _buildOrDivider(),
                _buildAnonymouslySignInButton(),
                _buildDontHaveAccount(),
              ],
            ),
          ),
    );
  }

  Widget _buildUserEmailLabel() {
    return Text(
      "E-mail",
      style: TextStyle(color: AppColors.black),
    );
  }

  Widget _buildUserEmailField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: 'exemplo@gmail.com',
          inputType: TextInputType.emailAddress,
          textController: _userEmailController,
          inputAction: TextInputAction.next,
          autoFocus: false,
          padding: EdgeInsets.only(bottom: 16, top: 4),
          onChanged: (value) {
            _formStore.setUserEmail(_userEmailController.text);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          errorText: _formStore.formErrorStore.userEmail,
        );
      },
    );
  }

  Widget _buildPasswordLabel() {
    return Text(
      "Senha",
      style: TextStyle(color: AppColors.black),
    );
  }

  Widget _buildPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: 'digite sua senha',
          isObscure: true,
          padding: EdgeInsets.only(top: 4),
          textController: _passwordController,
          focusNode: _passwordFocusNode,
          errorText: _formStore.formErrorStore.password,
          onChanged: (value) {
            _formStore.setPassword(_passwordController.text);
          },
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: FractionalOffset.centerRight,
      child: MaterialButton(
        padding: EdgeInsets.all(0.0),
        child: Text('Esqueceu sua senha?',
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w200,
              decoration: TextDecoration.underline,
            )),
        onPressed: () {},
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.black.withOpacity(0.25),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Text(
            "ou",
            style: TextStyle(
              color: AppColors.black.withOpacity(0.5),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.black.withOpacity(0.25),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return RoundedButtonWidget(
      buttonText: 'Continuar',
      buttonColor: AppColors.blue,
      textColor: Colors.white,
      buttonTextSize: 16,
      height: 56,
      onPressed: () async {
        if (_formStore.canLogin) {
          DeviceUtils.hideKeyboard(context);
          _loginStore.login(
              _userEmailController.text, _passwordController.text);
        } else {
          _showErrorMessage('Por favor preencha todos os campos');
        }
      },
    );
  }

  Widget _buildGoogleSignInButton() {
    return RoundedButtonWidget(
      buttonText: 'Continuar com o Google',
      buttonColor: AppColors.white,
      textColor: AppColors.black.withOpacity(0.8),
      buttonTextSize: 16,
      height: 56,
      borderColor: AppColors.black,
      imagePath: 'assets/icons/ic_google.png',
      onPressed: () async {
        DeviceUtils.hideKeyboard(context);
        _loginStore.loginGoogle();
      },
    );
  }

  Widget _buildAnonymouslySignInButton() {
    return RoundedButtonWidget(
      buttonText: 'Continuar de forma anônima',
      buttonColor: AppColors.white,
      textColor: AppColors.black.withOpacity(0.8),
      buttonTextSize: 16,
      height: 56,
      borderColor: AppColors.black,
      onPressed: () async {
        DeviceUtils.hideKeyboard(context);
        _loginStore.loginAnonymously();
      },
    );
  }

  Widget _buildDontHaveAccount() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            "Ainda não tem uma conta?",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          MaterialButton(
            padding: EdgeInsets.all(0.0),
            child: Text(
              'Criar uma conta',
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.createAccout);
            },
          ),
        ],
      ),
    );
  }

  Widget navigate(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home, (Route<dynamic> route) => false);
    });

    return Container();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          FlushbarHelper.createError(
            message: message,
            title: 'Erro',
            duration: Duration(seconds: 3),
          )..show(context);
        }
      });
    }

    return SizedBox.shrink();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _userEmailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
