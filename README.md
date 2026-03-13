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
