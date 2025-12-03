# ESIG Social Feed

Aplicativo mobile desenvolvido em Flutter para simular o feed de uma rede social, demonstrando habilidades em desenvolvimento mobile, organização de código, gerenciamento de estado e integração com recursos nativos.

##  Funcionalidades

-  **Tela de Login**: Autenticação com validação local
-  **Tela de Registro**: Criação de novas contas
-  **Visualização do Feed**: Lista de posts em formato de cards
-  **Criação de Posts**: Adicionar novos posts com título, conteúdo e imagem
-  **Edição de Posts**: Modificar posts existentes
-  **Exclusão de Posts**: Deletar posts existentes
-  **Detalhes do Post**: Tela dedicada para visualizar e editar posts
-  **Recursos Nativos**: Integração com câmera para captura de fotos

##  Arquitetura

O projeto segue os princípios da **Clean Architecture**, organizando o código em camadas:

```
lib/
├── core/
│   ├── constants/      # Constantes da aplicação (API, App)
│   ├── di/             # Dependency Injection (Service Locator)
│   ├── services/       # Serviços compartilhados
│   └── utils/          # Utilitários (AuthValidator, ImagePicker)
├── data/
│   ├── datasources/    # Fontes de dados (Remote e Local)
│   ├── models/         # Modelos de dados
│   └── repositories/   # Implementações dos repositórios
├── domain/
│   ├── entities/       # Entidades de domínio
│   └── repositories/   # Interfaces dos repositórios
└── presentation/
    ├── pages/          # Telas da aplicação
    ├── stores/         # Stores MobX (gerenciamento de estado)
    └── widgets/        # Widgets reutilizáveis
```

##  Tecnologias Utilizadas

- **Flutter**: Framework mobile multiplataforma
- **MobX**: Gerenciamento de estado reativo
- **DIO**: Cliente HTTP para consumo de APIs
- **Image Picker**: Integração com câmera e galeria
- **SharedPreferences**: Armazenamento local de dados
- **Cached Network Image**: Cache de imagens de rede
- **Intl**: Internacionalização e formatação

##  Pré-requisitos

- Flutter SDK 3.6.2 ou superior
- Dart SDK 3.6.2 ou superior
- Android Studio ou VS Code com extensões Flutter
- Android SDK (para desenvolvimento Android)
- Dispositivo Android ou emulador

##  Instalação e Execução

### 1. Clone o repositório

```bash
git clone <https://github.com/Vitu26/esig>
cd esig_app
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Gere o código do MobX

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Ou, se preferir usar o comando atualizado:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Execute o aplicativo

#### Android

```bash
flutter run
```

Ou especifique um dispositivo:

```bash
flutter devices
flutter run -d <device-id>
```

#### Web

```bash
flutter run -d chrome
```

##  Credenciais de Login

- **Usuário**: `admin`
- **Senha**: `admin`

Você também pode criar uma nova conta através da tela de registro.

##  Estrutura de Dados

### Post Entity

```dart
{
  objectId: String?      // ID único do post
  title: String          // Título do post
  content: String        // Conteúdo do post
  imageUrl: String?      // URL ou caminho da imagem
  userId: String?        // ID do usuário criador
  username: String?      // Nome do usuário criador
  createdAt: DateTime    // Data de criação
  updatedAt: DateTime    // Data de atualização
}
```

##  Fluxo de Dados

1. **Apresentação** → Stores (MobX) → Repositories
2. **Repositories** → Datasources (Local)
3. **Datasources Local** → SharedPreferences
4. Todos os dados são armazenados localmente no dispositivo

##  Plataformas Suportadas

-  Android (API 21+)
-  Web
-  iOS (configuração disponível)

##  Testes

```bash
flutter test
```

##  Comandos Úteis

### Limpar build

```bash
flutter clean
flutter pub get
```

### Regenerar código MobX

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Verificar problemas

```bash
flutter doctor
flutter analyze
```

### Compilar APK para Android

```bash
flutter build apk
```

### Compilar APK dividido por ABI (menor tamanho)

```bash
flutter build apk --split-per-abi
```

##  Recursos Nativos

### Câmera
- Captura de fotos para os posts
- Seleção de imagens da galeria
- Suporte para Android e Web

### Armazenamento Local
- Persistência de posts e dados de autenticação
- Armazenamento via SharedPreferences

##  Configuração do Android

O aplicativo já está configurado com as permissões necessárias:

- Câmera
- Internet
- Armazenamento (compatível com Android 13+)
- Leitura de mídia

Todas as configurações estão em `android/app/src/main/AndroidManifest.xml`.

##  Link de apresentação no youtube:



