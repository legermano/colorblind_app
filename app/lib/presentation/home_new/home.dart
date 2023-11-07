import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/core/stores/user/user_store.dart';
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/presentation/login/store/login_store.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  final UserStore _userStore = getIt<UserStore>();
  final LoginStore _loginStore = getIt<LoginStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(context),
      bottomSheet: Container(
        color: AppColors.white,
        padding: EdgeInsets.only(bottom: 24),
        height: 80,
        alignment: Alignment.center,
        child: _buildCameraButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      toolbarHeight: 100,
      title: Observer(
        builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 0,
                child: CircleAvatar(
                  child: SvgPicture.asset('assets/svg/user.svg'),
                  radius: 32,
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, ' +
                            (_loginStore.isLoggedIn
                                ? "${_loginStore.user?.displayName} ?? 'Usuário'"
                                : 'Visitante'),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _loginStore.isLoggedIn
                            ? "${_loginStore.user?.email ?? ''}"
                            : "Realize o login",
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: IconButton(
                  icon: Icon(
                    _loginStore.isLoggedIn ? Icons.logout : Icons.login,
                    color: AppColors.white,
                  ),
                  onPressed: () {
                    if (_loginStore.isLoggedIn) {
                      _loginStore.logout();
                    } else {
                      Navigator.of(context).pushReplacementNamed(Routes.login);
                    }
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              _userStore.hasResult
                  ? _buildResultCard()
                  : _buildMakeTestCard(context),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.ishihara),
                      child: _buildIshiharaCard(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.aboutProtan),
                      child: _buildInformationsCard(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMakeTestCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Realize o teste de daltonismo",
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Realize o teste de Ishihara para poder diagnosticar se possui ou não daltonismo. "
                "O teste de Ishihara é um teste de cores para detectar e classificar o tipo de daltonismo que o paciente possui. "
                "Ele consiste na exibição de uma série de cartões coloridos, cada um contendo vários círculos feitos de cores ligeiramente diferentes das cores daqueles situados nas proximidades.",
                style: TextStyle(color: AppColors.black.withOpacity(0.8)),
              ),
              const SizedBox(height: 24),
              Center(
                child: OutlinedButton(
                  child: const Text(
                    'Realize o teste de Ishihara',
                    style: TextStyle(color: AppColors.black),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    side: BorderSide(color: AppColors.black, width: 2),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.ishihara);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Segundo seu teste, você tem',
              style: TextStyle(color: AppColors.black.withOpacity(0.8)),
            ),
            Text(
              _userStore.hasColorblind
                  ? "Daltonismo tipo ${_userStore.result}"
                  : "Visão normal",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "O daltonismo é uma deficiência visual que interfere na percepção das cores, a maior parte desse grupo tem dificuldade na distinção entre o vermelho e verde, com menos frequência o azul e o amarelo, e a menor frequência é das pessoas que só enxergam tons brancos, cinzas e pretos. "
              "Estima-se que no Brasil cerca de 10% dos homens e 1% das mulheres possuam essa condição.",
              style: TextStyle(color: AppColors.black.withOpacity(0.8)),
            ),
            const SizedBox(height: 24),
            Center(
              child: OutlinedButton(
                child: const Text(
                  'Saiba mais',
                  style: TextStyle(color: AppColors.black),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  side: BorderSide(color: AppColors.black, width: 2),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.results);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIshiharaCard() {
    return Card(
      margin: EdgeInsets.only(right: 8, top: 8),
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/ishihara.svg'),
            SizedBox(height: 16),
            Text(
              'Teste de Ishihara',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInformationsCard() {
    return Card(
      margin: EdgeInsets.only(left: 8, top: 8),
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 64,
              child: SvgPicture.asset('assets/svg/informations.svg'),
            ),
            SizedBox(height: 16),
            Text(
              'Mais informações',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraButton() {
    return OutlinedButton(
      child: SvgPicture.asset('assets/icons/camera.svg'),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 48,
        ),
      ),
      onPressed: () => Navigator.of(context).pushNamed(Routes.camera),
      // onPressed: () async {
      //   FirebaseFirestore db = FirebaseFirestore.instance;

      //   await db.collection("plates").get().then((event) {
      //     for (var doc in event.docs) {
      //       print("${doc.id} => ${doc.data()}");
      //     }
      //   });
      // },
    );
  }
}
