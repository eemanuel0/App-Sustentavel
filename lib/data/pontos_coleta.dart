import '../models/descarte.dart';
import '../models/ponto_coleta.dart';

// A lista fica no app para a consulta funcionar mesmo sem internet.
const pontosColeta = [
  // O endereço e os materiais vêm do anúncio da Prefeitura em 2022.
  // https://www.pmvc.ba.gov.br/prefeitura-instala-no-bairro-vila-america-primeiro-ecoponto-para-descarte-de-lixo-reciclavel-da-cidade/
  PontoColeta(
    nome: 'Ecoponto Vila América',
    endereco: 'Av. Gilenilda Alves · Vila América',
    referencia: 'Praça Moisés Caetité',
    horario: 'Dados de 2022. Confirme o funcionamento antes de ir.',
    materiais: {
      MaterialDescarte.papel: 'Papel e papelão',
      MaterialDescarte.plastico: 'Garrafas PET e tampas',
      MaterialDescarte.vidro: 'Vidro',
      MaterialDescarte.metal: 'Alumínio',
      MaterialDescarte.pilhas: 'Pilhas e baterias',
      MaterialDescarte.oleo: 'Óleo de cozinha usado',
      MaterialDescarte.eletronicos: 'Eletrônicos',
      MaterialDescarte.outros: 'Embalagens longa vida',
    },
  ),
  // O shopping publica os materiais aceitos e o horário da praça.
  // https://www.boulevardconquista.com.br/informacoes-gerais/sustentabilidade/
  // https://boulevardconquista.com.br/horario-de-funcionamento/
  PontoColeta(
    nome: 'Ecoponto Boulevard Shopping',
    endereco: 'Av. Olívia Flores, 2500 · Universidade',
    referencia: 'Praça de alimentação, ao lado da Cacau Show',
    horario: 'Praça de alimentação · seg. a sáb. 10h–22h · dom. 12h–22h',
    materiais: {
      MaterialDescarte.papel: 'Papel e papelão',
      MaterialDescarte.plastico: 'Plásticos',
      MaterialDescarte.metal: 'Latas de alumínio',
      MaterialDescarte.pilhas: 'Pilhas e baterias',
      MaterialDescarte.eletronicos: 'Eletrônicos',
      MaterialDescarte.outros: 'Lâmpadas',
    },
  ),
  // A Prefeitura publicou o endereço e a Torre informou o horário do ecoponto.
  // https://www.pmvc.ba.gov.br/primeiro-centro-de-triagem-de-materiais-reciclaveis-de-vitoria-da-conquista-sera-inaugurado-nesta-quarta-feira-5/
  // https://pt.linkedin.com/posts/torre-empreendimentos_torre-gest%C3%A3oderes%C3%ADduos-limpezaurbana-activity-7519453536988848128-TroK
  PontoColeta(
    nome: 'Centro de Triagem ACRES',
    endereco: 'Av. Vladimir Herzog, 850 · Boa Vista',
    horario: 'Ecoponto 24h, segundo a Torre.',
    materiais: {},
  ),
];
