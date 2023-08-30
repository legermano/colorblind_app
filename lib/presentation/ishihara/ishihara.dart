import 'package:boilerplate/constants/colors.dart';
import 'package:flutter/material.dart';

class IshiharaScreen extends StatefulWidget {
  const IshiharaScreen({super.key});

  @override
  State<IshiharaScreen> createState() => _IshiharaScreenState();
}

class _IshiharaScreenState extends State<IshiharaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomSheet: _buildBottomSheet(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        backgroundColor: AppColors.white,
        toolbarHeight: 60,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 32,
          ),
          onPressed: () {},
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
          '60',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 46,
          height: 46,
          child: CircularProgressIndicator(
            value: 40/60,
            valueColor: const AlwaysStoppedAnimation(AppColors.black),
            backgroundColor: AppColors.blue,
          ),
        )
      ],
    );
  }

  Widget _buildBody () {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 58),
            child: Text(
              'Qual o númerto no centro do círculo?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet () {
    return Container(
      height: 92,
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 32,
        left: 16,
        right: 16,
      ),
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
