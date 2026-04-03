# product_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Atividade 2 - Questionário de Reflexão
Este documento contém as respostas para a atividade de implementação de cache e análise arquitetural do projeto product_app.

Respostas do Questionário
1. Em qual camada foi implementado o mecanismo de cache? Explique por que essa decisão é adequada dentro da arquitetura proposta.
O mecanismo de cache foi implementado na camada de Dados (Data Layer), através do ProductCacheDatasource.

Justificativa: Esta decisão é adequada porque a gestão de persistência e origem de dados (seja via API remota ou cache local) é uma responsabilidade de infraestrutura. Ao manter o cache na camada de dados, as camadas de Domínio e Apresentação permanecem "agnósticas" à origem da informação, respeitando o princípio de separação de responsabilidades.

2. Por que o ViewModel não deve realizar chamadas HTTP diretamente?
O ViewModel pertence à camada de Apresentação. Ele não deve realizar chamadas HTTP pelos seguintes motivos:

Acoplamento: Se o ViewModel fizesse chamadas HTTP, ele estaria fortemente acoplado a bibliotecas específicas (como http ou dio) e a URLs específicas.

Testabilidade: Dificultaria a criação de testes unitários, pois seria necessário simular um servidor real em vez de apenas "mockar" um repositório.

Reutilização: A lógica de acesso a dados deve ser centralizada para que diferentes ViewModels ou funcionalidades possam utilizar os mesmos dados sem duplicar código de rede.

3. O que poderia acontecer se a interface acessasse diretamente o DataSource?
Acessar o DataSource diretamente a partir da interface (UI) causaria vários problemas:

Dependência de Modelos de Dados: A interface teria que lidar com ProductModel (JSON/Data Transfer Objects) em vez de Entities de negócio, tornando-a frágil a mudanças no contrato da API.

Ausência de Tratamento de Erros: O Repositório serve como um filtro que converte exceções técnicas (como erro 404 ou falha de conexão) em falhas de domínio compreensíveis pela aplicação. Sem ele, a UI ficaria exposta a erros brutos de infraestrutura.

Complexidade na UI: A lógica de decidir se deve buscar dados do cache ou da rede ficaria dentro dos Widgets, o que fere o princípio de que a interface deve ser apenas uma representação visual do estado.

4. Como essa arquitetura facilitaria a substituição da API por um banco de dados local?
A arquitetura facilita essa transição através do uso de Interfaces (Contratos).

O ViewModel depende da interface abstrata IProductRepository, e não da implementação concreta.

Se for necessário substituir a API por um banco de dados local (como SQLite, Hive ou Floor), bastaria criar uma nova implementação dessa interface (ex: ProductLocalRepositoryImpl) e injetá-la no ViewModel.

Não seria necessário alterar uma única linha de código na UI ou no ViewModel, pois o contrato de dados permaneceria o mesmo.

Atividade 06 - Questionário sobre Estado

1. O que significa gerenciamento de estado em uma aplicação Flutter?
O gerenciamento de estado é o processo de controlar como os dados que fluem pela aplicação (o "estado") são armazenados, alterados e refletidos na interface do usuário (UI). No Flutter, o estado é qualquer dado que pode mudar durante a vida útil do app — como o conteúdo de um carrinho de compras ou o status de um login. Gerenciar o estado significa garantir que, sempre que esses dados mudarem, a interface seja reconstruída de forma eficiente e síncrona.

2. Por que manter o estado diretamente dentro dos widgets pode gerar problemas em aplicações maiores?
Centralizar a lógica de estado apenas dentro de widgets (StatefulWidgets) em projetos grandes costuma causar:

Acoplamento excessivo: A lógica de negócio fica misturada com a estrutura da interface, dificultando a manutenção.

Dificuldade de compartilhamento: Passar dados entre widgets distantes na árvore (o chamado prop drilling) torna o código confuso.

Inconsistência de dados: Fica difícil garantir que dois widgets diferentes exibam a mesma informação atualizada se o estado estiver disperso.

Baixa testabilidade: É muito mais complexo testar regras de negócio que estão presas a elementos visuais.

3. Qual é o papel do método notifyListeners() na abordagem Provider?
O notifyListeners() funciona como um sistema de "broadcast" (transmissão). Quando uma propriedade dentro de um ChangeNotifier é alterada, esse método é chamado para avisar a todos os widgets que estão consumindo aquele Provider que houve uma mudança. Isso dispara automaticamente a reconstrução apenas dos componentes dependentes, garantindo que a UI esteja sempre atualizada.

4. Qual é a principal diferença conceitual entre Provider e Riverpod?
Embora criados pelo mesmo autor, a principal diferença é o desacoplamento da árvore de widgets:

Provider: Depende fortemente do BuildContext para localizar os dados. Se você tentar acessar um Provider fora da árvore de widgets ou antes dela ser montada, o app pode quebrar.

Riverpod: Não depende do BuildContext. Ele utiliza um objeto Ref para acessar os provedores, o que permite que o estado seja acessado de qualquer lugar, facilita testes unitários e elimina erros em tempo de execução comuns no Provider (como o ProviderNotFoundException).

5. No padrão BLoC, por que a interface não altera diretamente o estado da aplicação?
No padrão BLoC (Business Logic Component), a interface é tratada como "burra" (meramente visual). Ela não conhece as regras de negócio; ela apenas dispara eventos. Essa separação garante que o estado só mude após passar por uma lógica centralizada, o que torna o comportamento do aplicativo previsível e evita que ações acidentais da UI corrompam os dados do sistema.

6. Considere o fluxo do padrão BLoC: Evento → Bloc → Novo estado → Interface
Qual é a vantagem de organizar o fluxo dessa forma?
A principal vantagem é o fluxo unidirecional de dados. Isso proporciona:

Previsibilidade: Você sempre sabe que um estado "B" foi gerado por um evento "A".

Facilidade de Debug: É simples rastrear qual ação do usuário causou um erro específico.

Modularidade: O BLoC pode ser testado isoladamente da interface, simulando eventos e verificando se os estados de saída estão corretos.

7. Qual estratégia de gerenciamento de estado foi utilizada em sua implementação?
Para este projeto, foi utilizada a biblioteca Provider, implementando a classe ChangeNotifier para a lógica de negócio e o método notifyListeners() para a reatividade da interface.

8. Durante a implementação, quais foram as principais dificuldades encontradas?
As maiores dificuldades envolveram a transição da mentalidade de "estado local" para "estado global":

Refatoração da Lógica: Converter um exemplo simples de contador para uma estrutura robusta de lista de produtos e sistema de favoritos.

Sincronização da UI: Garantir que a ação de "favoritar" em uma tela fosse refletida instantaneamente em outras partes do app, o que exigiu atenção ao escopo do Provider.

Organização de Arquivos: Estruturar corretamente as pastas entre Mod