import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
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
      title: Row(
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
                    'Olá, Laura',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'laurinha2009@gmail.com',
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
              icon: SvgPicture.asset('assets/icons/edit.svg'),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.only(bottom: 80),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            _buildResultCard(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(Routes.ishihara),
                    child: _buildIshiharaCard(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _buildInformationsCard(),
                ),
              ],
            ),
          ],
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
              'Daltonismo tipo X',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
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
            )
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
      onPressed: () {},
    );
  }
}
