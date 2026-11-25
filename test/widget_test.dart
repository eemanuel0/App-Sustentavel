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

  testWidgets('Valida os campos antes de cadastrar um descarte', (
    tester,
  ) async {
    await tester.pumpWidget(const EcoDescarteApp());

    await tester.tap(find.text('Adicionar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, '0');
    await tester.tap(find.text('Salvar descarte'));
    await tester.pumpAndSettle();

    expect(find.text('Informe o nome do descarte.'), findsOneWidget);
    expect(find.text('Escolha um material.'), findsOneWidget);
    expect(
      find.text('Informe um número inteiro maior que zero.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('0 pendentes'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('Adiciona, conclui, reabre e remove um registro', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 680);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const EcoDescarteApp());

    final filtro = find.byType(DropdownButton<MaterialDescarte>);
    await tester.tap(filtro);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Papel').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Adicionar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Latinhas');
    await tester.enterText(find.byType(TextFormField).last, '6');
    await tester.tap(find.byType(DropdownButtonFormField<MaterialDescarte>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Metal').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar descarte'));
    await tester.pumpAndSettle();

    final nome = find.text('Latinhas');
    expect(nome, findsOneWidget);
    expect(find.textContaining('Metal · 6 un'), findsOneWidget);
    expect(find.text('1 pendente'), findsOneWidget);
    expect(
      tester.widget<DropdownButton<MaterialDescarte>>(filtro).value,
      isNull,
    );

    await tester.tap(find.byTooltip('Marcar como entregue'));
    await tester.pumpAndSettle();
    expect(find.text('0 pendentes'), findsOneWidget);
    expect(
      tester.widget<Text>(nome).style?.decoration,
      TextDecoration.lineThrough,
    );

    await tester.tap(find.byTooltip('Voltar para pendente'));
    await tester.pumpAndSettle();
    expect(find.text('1 pendente'), findsOneWidget);

    await tester.tap(find.byTooltip('Opções do descarte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remover'));
    await tester.pumpAndSettle();
    expect(nome, findsNothing);
    expect(find.text('0 pendentes'), findsOneWidget);
    expect(find.textContaining('Nenhum descarte registrado'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
