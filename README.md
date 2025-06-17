🚀 Visão Geral
O App OS é uma solução mobile para controle de ordens de serviço, com funcionalidades pensadas para facilitar a rotina de pequenas e médias empresas. Com ele, é possível:

Cadastrar e gerenciar clientes

Criar e acompanhar orçamentos

Atualizar status de produção e entrega

Acompanhar serviços atrasados

Gerar relatórios para controle interno

🛠️ Tecnologias Utilizadas
Flutter – Desenvolvimento mobile multiplataforma

Dart – Linguagem principal do app

Parse Server (Back4App) – Backend com banco de dados na nuvem

Node.js – Funções em nuvem personalizadas

SQLite – Armazenamento local offline

Dio – Requisições HTTP

GetX / Signals – Gerenciamento de estado e rotas

📲 Funcionalidades Principais
📋 Cadastro de ordens de serviço com descrição, data e status

👤 Gerenciamento de clientes

💸 Criação de orçamentos com produtos e serviços

⏳ Controle de serviços em produção e atrasados

🖨️ Geração de relatórios e PDFs

📦 Histórico de preços e movimentações

🔔 Notificações push (Firebase)

📍 Integração com Google Maps para localização dos clientes

📦 Estrutura do Projeto
bash
Copiar
Editar
lib/
├── controllers/       # Lógica de controle (GetX ou Signals)
├── models/            # Modelos de dados (Product, Cliente, OS)
├── screens/           # Telas da aplicação
├── services/          # Serviços de API e banco de dados
├── widgets/           # Componentes reutilizáveis
├── main.dart          # Ponto de entrada do app
✅ Requisitos
Flutter 3.0 ou superior

Dart SDK

Conta no Back4App (Parse Server)

Firebase configurado para notificações

🔧 Como Rodar o Projeto
Clone o repositório:

bash
Copiar
Editar
git clone https://github.com/seuusuario/app_os.git
cd app_os
Instale as dependências:

bash
Copiar
Editar
flutter pub get
Configure o .env com suas chaves do Parse Server.

Execute:

bash
Copiar
Editar
flutter run
📚 Recursos Úteis
Documentação oficial Flutter

Parse Server Flutter SDK

Firebase para Flutter

