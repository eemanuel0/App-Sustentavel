import 'package:ecodescarte/main.dart';
import 'package:ecodescarte/models/descarte.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Abre o Início com a lista vazia', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const EcoDescarteApp());

    expect(find.text('EcoDescarte · ODS 12'), findsOneWidget);
    expect(find.text('0 pendentes'), findsOneWidget);
    expect(find.textContaining('Nenhum descarte registrado'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Adicionar'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Permite escolher um material e voltar a todos', (tester) async {
    await tester.pumpWidget(const EcoDescarteApp());
    final filtro = find.byType(DropdownButton<MaterialDescarte>);

    await tester.tap(filtro);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pilhas').last);
    await tester.pumpAndSettle();
    expect(
      tester.widget<DropdownButton<MaterialDescarte>>(filtro).value,
      MaterialDescarte.pilhas,
    );

    await tester.tap(filtro);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Todos os materiais').last);
    await tester.pumpAndSettle();
    expect(
      tester.widget<DropdownButton<MaterialDescarte>>(filtro).value,
      isNull,
    );
  });
}
