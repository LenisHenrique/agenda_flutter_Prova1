import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// Criando instância de FlutterSecureStorage
final storage = FlutterSecureStorage();


// Função para salvar o token de autenticação
Future<void> salvarToken(String token) async {
  await storage.write(key: 'auth_token', value: token);
}


// Função para carregar o token de autenticação
Future<String?> carregarToken() async {
  return await storage.read(key: 'auth_token');
}


// Função para verificar se o usuário está logado
Future<bool> estaLogado() async {
  final token = await carregarToken();
  return token != null;
}

// Função para remover o token de autenticação (logout)
Future<void> removerToken() async {
  await storage.delete(key: 'auth_token');
}


// Função para limpar todos os dados armazenados
Future<void> limparTudo() async {
  await storage.deleteAll();
}


// Uso das funções em um fluxo de login/logout
void login(String token) async {
  await salvarToken(token);  // Salva o token no login
}


void logout() async {
  await removerToken();  // Remove o token no logout
}
