import 'package:ecodescarte/main.dart';
import 'package:ecodescarte/models/descarte.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Abre o Início com a lista vazia', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const EcoDescarteApp());
    await tester.pumpAndSettle();

    expect(find.text('EcoDescarte · ODS 12'), findsOneWidget);
    expect(find.text('0 pendentes'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Adicionar'), findsOneWidget);
    final mensagem = find.textContaining('Nenhum descarte registrado');
    await tester.scrollUntilVisible(mensagem, 120);
    expect(mensagem, findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Permite escolher um material e voltar a todos', (tester) async {
    await tester.pumpWidget(const EcoDescarteApp());
    await tester.pumpAndSettle();
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
    await tester.pumpAndSettle();

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

  testWidgets('Mantém as alterações da lista ao reabrir o app', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 680);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const EcoDescarteApp());
    await tester.pumpAndSettle();

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

    Future<void> reabrirApp() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(const EcoDescarteApp());
      await tester.pumpAndSettle();
    }

    Future<void> tocarAcao(String rotulo) async {
      final acao = find.byTooltip(rotulo).hitTestable();
      await tester.scrollUntilVisible(acao, 120);
      await tester.pumpAndSettle();
      await tester.tap(acao);
      await tester.pumpAndSettle();
    }

    await reabrirApp();
    expect(nome, findsOneWidget);
    expect(find.textContaining('Metal · 6 un'), findsOneWidget);
    expect(find.text('1 pendente'), findsOneWidget);

    await tocarAcao('Marcar como entregue');
    await reabrirApp();
    expect(find.text('0 pendentes'), findsOneWidget);
    expect(
      tester.widget<Text>(nome).style?.decoration,
      TextDecoration.lineThrough,
    );

    await tocarAcao('Voltar para pendente');
    await reabrirApp();
    expect(find.text('1 pendente'), findsOneWidget);

    await tocarAcao('Opções do descarte');
    await tester.tap(find.text('Remover'));
    await tester.pumpAndSettle();
    await reabrirApp();
    expect(nome, findsNothing);
    expect(find.text('0 pendentes'), findsOneWidget);
    final mensagem = find.textContaining('Nenhum descarte registrado');
    await tester.scrollUntilVisible(mensagem, 120);
    expect(mensagem, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Protege a lista quando a leitura falha e permite tentar de novo',
    (tester) async {
      SharedPreferences.setMockInitialValues({'descartes': 'JSON inválido'});
      await tester.pumpWidget(const EcoDescarteApp());
      await tester.pumpAndSettle();

      expect(
        find.text('Não foi possível carregar seus descartes.'),
        findsOneWidget,
      );
      final adicionar = find.widgetWithText(FilledButton, 'Adicionar');
      expect(tester.widget<FilledButton>(adicionar).onPressed, isNull);

      final preferencias = await SharedPreferences.getInstance();
      await preferencias.setString('descartes', '[]');
      await tester.tap(find.text('Tentar novamente'));
      await tester.pumpAndSettle();
      expect(find.text('0 pendentes'), findsOneWidget);
      expect(tester.widget<FilledButton>(adicionar).onPressed, isNotNull);
    },
  );

  testWidgets('Navega para Pontos e filtra os locais por material', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const EcoDescarteApp());
    await tester.pumpAndSettle();

    final filtroInicio = find.byType(DropdownButton<MaterialDescarte>);
    await tester.tap(filtroInicio);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pilhas').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pontos'));
    await tester.pumpAndSettle();
    expect(find.text('Pontos de coleta'), findsOneWidget);
    expect(find.text('Vitória da Conquista · BA'), findsOneWidget);
    expect(find.text('3 pontos de coleta'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Óleo'));
    await tester.pumpAndSettle();
    expect(find.text('1 ponto de coleta'), findsOneWidget);
    expect(find.text('Ecoponto Vila América'), findsOneWidget);
    expect(find.text('Ecoponto Boulevard Shopping'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Todos'));
    await tester.pumpAndSettle();
    expect(find.text('3 pontos de coleta'), findsOneWidget);

    final shopping = find.text('Ecoponto Boulevard Shopping');
    await tester.scrollUntilVisible(shopping, 200);
    expect(shopping, findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Minha lista'), findsOneWidget);
    expect(
      tester.widget<DropdownButton<MaterialDescarte>>(filtroInicio).value,
      MaterialDescarte.pilhas,
    );
    expect(tester.takeException(), isNull);
  });
}
