import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/core/stores/form/form_store.dart';
import 'package:boilerplate/core/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/core/widgets/rounded_button_widget.dart';
import 'package:boilerplate/core/widgets/textfield_widget.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/presentation/login/store/login_store.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di/service_locator.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  //stores:---------------------------------------------------------------------
  final FormStore _formStore = getIt<FormStore>();
  final LoginStore _loginStore = getIt<LoginStore>();

  //focus node:-----------------------------------------------------------------
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmPasswordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: _buildAppBar(),
      body: _buildBody(),
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
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Material(
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
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Criar uma conta",
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          SizedBox(height: 24.0),
          _buildUserNameLabel(),
          _buildUserNameField(),
          _buildUserEmailLabel(),
          _buildUserEmailField(),
          _buildPasswordLabel(),
          _buildPasswordField(),
          _buildConfirmPasswordLabel(),
          _buildConfirmPasswordField(),
          _buildCreateAccountButton(),
          _buildCancelButton(),
        ],
      ),
    );
  }

  Widget _buildUserNameLabel() {
    return Text(
      "Nome",
      style: TextStyle(color: AppColors.black),
    );
  }

  Widget _buildUserNameField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: 'nome',
          inputType: TextInputType.emailAddress,
          textController: _userNameController,
          inputAction: TextInputAction.next,
          autoFocus: false,
          padding: EdgeInsets.only(bottom: 16, top: 4),
          onChanged: (value) {
            _formStore.setUserName(_userNameController.text);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_emailFocusNode);
          },
          errorText: _formStore.formErrorStore.userName,
        );
      },
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
          focusNode: _emailFocusNode,
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
          padding: EdgeInsets.only(bottom: 16, top: 4),
          textController: _passwordController,
          focusNode: _passwordFocusNode,
          errorText: _formStore.formErrorStore.password,
          onChanged: (value) {
            _formStore.setPassword(_passwordController.text);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
          },
        );
      },
    );
  }

  Widget _buildConfirmPasswordLabel() {
    return Text(
      "Confirmar senha",
      style: TextStyle(color: AppColors.black),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: 'digite sua senha',
          isObscure: true,
          padding: EdgeInsets.only(top: 4),
          textController: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          errorText: _formStore.formErrorStore.confirmPassword,
          onChanged: (value) {
            _formStore.setConfirmPassword(_confirmPasswordController.text);
          },
        );
      },
    );
  }

  Widget _buildCreateAccountButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: RoundedButtonWidget(
        buttonText: 'Criar conta',
        buttonColor: AppColors.blue,
        textColor: Colors.white,
        buttonTextSize: 16,
        height: 56,
        onPressed: () async {
          if (_formStore.canRegister) {
            DeviceUtils.hideKeyboard(context);
            _loginStore.register(
              _userNameController.text,
              _userEmailController.text,
              _passwordController.text,
            );
          } else {
            _showErrorMessage('Por favor preencha todos os campos');
          }
        },
      ),
    );
  }

  Widget _buildCancelButton() {
    return RoundedButtonWidget(
      buttonText: 'Cancelar',
      buttonColor: AppColors.white,
      textColor: AppColors.black,
      buttonTextSize: 16,
      height: 56,
      borderColor: AppColors.black,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget navigate(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(Preferences.is_logged_in, true);
    });

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
    _userNameController.dispose();
    _userEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }
}
