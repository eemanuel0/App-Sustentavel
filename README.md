# EcoDescarte

Aplicativo Flutter para registrar descartes, consultar pontos de coleta em Vitória da Conquista e acompanhar uma meta semanal de entregas. O projeto se relaciona ao ODS 12, Consumo e Produção Responsáveis.

## Executar e testar

Use o Flutter 3.50.1 com o SDK Android configurado. Na raiz do projeto, rode:

```bash
flutter pub get
flutter test
flutter build apk
```

O APK ARM64 disponibilizado foi gerado com `flutter build apk --target-platform android-arm64 --split-per-abi` e é destinado a aparelhos Android 7 ou superiores com processador ARM64. [Baixar EcoDescarte.apk](https://github.com/eemanuel0/App-Sustentavel/blob/ecodescarte/apk-android/EcoDescarte.apk)

## Onde fica cada parte

| Arquivo ou pasta | Responsabilidade |
| --- | --- |
| [lib/main.dart](lib/main.dart) | Inicialização do app e tema Material 3. |
| [lib/screens/](lib/screens/) | Início, formulário, Pontos e Impacto. `tela_principal.dart` controla as abas e compartilha a lista entre Início e Impacto. |
| [lib/models/](lib/models/) | Dados dos descartes e pontos de coleta, além do cálculo da meta semanal. |
| [lib/services/armazenamento.dart](lib/services/armazenamento.dart) | Leitura e gravação local da lista com `shared_preferences`. |
| [lib/data/pontos_coleta.dart](lib/data/pontos_coleta.dart) | Lista fixa dos locais de coleta, com as fontes junto aos dados. |
| [test/](test/) | Testes das telas, das ações da lista, da persistência e da meta semanal. |

## Conferir o fluxo no Android

1. Instale e abra o APK. Em **Início**, adicione um descarte e confira a quantidade na lista.
2. Marque o descarte como entregue. Abra **Impacto** e confira a contagem da semana.
3. Feche e reabra o app. O mesmo registro deve aparecer com o status de entregue.
4. Abra **Pontos** pela barra inferior e selecione um material para conferir o filtro.
5. Volte ao **Início**, remova o descarte pelo menu de três pontos e reabra o app para confirmar a remoção.

As capturas foram feitas na prévia web do app e incluem o cadastro, a reabertura e a remoção de um descarte. [Ver capturas das telas](https://github.com/eemanuel0/App-Sustentavel/tree/ecodescarte/apk-android/prints)
