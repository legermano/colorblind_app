import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:flutter/material.dart';

class AboutProtanScreen extends StatefulWidget {
  const AboutProtanScreen({super.key});

  @override
  State<AboutProtanScreen> createState() => _AboutProtanScreenState();
}

class _AboutProtanScreenState extends State<AboutProtanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
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
        'Daltonismo tipo Protan',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.black.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "O que é",
                style: TextStyle(
                  color: AppColors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              Text(
                "Daltonismo tipo Protan?",
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Daltonismo (ou discromatopsia) é um distúrbio da percepção visual que afeta a capacidade de um indivíduo em diferenciar certas cores. "
                "Como existem três tipos diferentes de recetores de cor, há também três diferentes formas principais: vermelho (protan), verde (deutan) e azul (tritan). "
                "Além disso, o daltonismo pode ser descrito como total ou parcial, com diferentes graus, sendo o daltonismo total é menos frequente.",
                style: TextStyle(
                  color: AppColors.black.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/colorblind_types.jpg"),
                ),
              ),
              Text(
                "No daltonismo do tipo Protan, a classificação da deficiência do tipo total é chamado de protanopia na qual o indivíduo apresenta incapacidade de perceber a luz vermelha. "
                "Já a pronatomalia é o nome da deficiência parcial nos cones vermelhos, nela as cores quentes podem tender para o marrom e tonalidades de verde podem ficar desbotadas.",
                style: TextStyle(
                  color: AppColors.black.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 22),
              Text(
                "Veja também",
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(
                  "O que é daltonismo tipo Deutan",
                  style: TextStyle(
                    color: AppColors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onPressed: () => Navigator.of(context).pushNamed(Routes.aboutDeutan),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(
                  "O que é daltonismo tipo Tritan",
                  style: TextStyle(
                    color: AppColors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onPressed: () => Navigator.of(context).pushNamed(Routes.aboutTritan),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
