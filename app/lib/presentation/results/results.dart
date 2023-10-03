import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/core/stores/user/user_store.dart';
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/domain/entity/ishihara/answer.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  //stores:---------------------------------------------------------------------
  final UserStore _userStore = getIt<UserStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      centerTitle: true,
      title: Text(
        'Resultados',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildInformationText(),
        Expanded(child: _buildResultDataTable())
      ],
    );
  }

  Widget _buildInformationText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Text(
          "(\$PORCENTAGEM) das suas respostas foram iguais as respostas esperadas para uma pessoa com daltonismo do tipo (\$TIPO)",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildResultDataTable() {
    return DataTable2(
      columnSpacing: 12,
      bottomMargin: 8,
      headingTextStyle: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      columns: const <DataColumn>[
        DataColumn(label: SizedBox()),
        DataColumn2(
          label: Text('Resposta'),
          numeric: true,
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text('Normal'),
          numeric: true,
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text('Protan'),
          numeric: true,
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text('Deutan'),
          numeric: true,
          size: ColumnSize.L,
        ),
      ],
      rows: List<DataRow>.generate(
        _userStore.answers.length,
        (index) => _buildDataRow(index),
      ),
    );
  }

  DataRow _buildDataRow(int index) {
    Answer answer = _userStore.answers[index];

    return DataRow(cells: <DataCell>[
      DataCell(Image.asset(
        "assets/images/ishihara/plate-${answer.plate.order}.png",
        height: 44,
        fit: BoxFit.contain,
      )),
      _buildDataCell(answer.answer, answer.answer, icon: false),
      _buildDataCell(answer.answer, answer.plate.normal),
      _buildDataCell(answer.answer, answer.plate.protanopia),
      _buildDataCell(answer.answer, answer.plate.deuteranopia),
    ]);
  }

  DataCell _buildDataCell(int? answer, int? value, {bool icon = true}) {
    return DataCell(
      RichText(
        text: TextSpan(
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16,
          ),
          children: [
            TextSpan(text: "${value ?? '-'}"),
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: icon
                    ? (answer == value)
                        ? Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green,
                          size: 16,
                        )
                        : CircleAvatar(
                          radius: 7,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.close_rounded,
                            size: 12,
                            color: AppColors.white,
                          ),
                        )
                    : SizedBox(height: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
