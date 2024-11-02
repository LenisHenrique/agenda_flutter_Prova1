import 'package:flutter/material.dart';
import 'package:novo_projeto/controle/loginController.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var usuarioController = TextEditingController();
    var senhaController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(hintText: "Entre com o login"),
            controller: usuarioController,
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(hintText: "Entre com a senha"),
            controller: senhaController,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton.icon(
              onPressed: () async {
                Logincontroller u = Logincontroller();
                try {
                  bool success = await u.login(
                      usuarioController.text, senhaController.text);
                  if (success) {
                    Navigator.pushNamed(context, "/listagem");
                  } else {
                    _showDialog(context, "Login ou senha inválidos.", "Erro");
                  }
                } catch (e) {
                  _showDialog(context, "Erro ao realizar login: $e", "Erro");
                }
              },
              icon: Icon(Icons.login),
              label: Text('Entrar'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Logincontroller u = Logincontroller();
                try {
                  await u.salvar(usuarioController.text, senhaController.text);
                  _showDialog(
                      context, "Cadastro realizado com sucesso!", "Correto");
                } catch (e) {
                  _showDialog(context, "Erro ao cadastrar: $e", "Erro");
                }
              },
              icon: Icon(Icons.add_circle_outline_sharp),
              label: Text('Cadastrar'),
            )
          ])
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String message, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}