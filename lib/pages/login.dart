import 'package:flutter/material.dart';
import 'pages/product_selection_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Simulação de login bem-sucedido.
                // Navegar para a página da loja após o login
                Navigator.pushReplacementNamed(context, '/loja');
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
