///////////////////////// OLD_SCREEN /////////////////////////
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../blocs/task_bloc.dart';
// import 'tasks_screen.dart';

// class WelcomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Bem-Vindo"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Continua capturando o TaskBloc antes de usar o Navigator
//             final taskBloc = BlocProvider.of<TaskBloc>(context, listen: false);

//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => BlocProvider.value(
//                   value: taskBloc,
//                   child: TasksScreen(),
//                 ),
//               ),
//             );
//           },
//           child: Text("Ir para Tarefas"),
//         ),
//       ),
//     );
//   }
// }
///////////////////////// OLD_SCREEN ////////////////////////////

import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'signup_screen.dart';
import 'takephoto_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService userService = UserService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      final email = emailController.text;
                      final password = passwordController.text;

                      try {
                        final statusCode =
                            await userService.loginUser(email, password);
                        if (statusCode == 200) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TakePhotoScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Credenciais incorretas')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao fazer login: $e')),
                        );
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => TakePhotoScreen()),
                        // );
                      }
                    },
                    child: const Text('Login'),
                  ),
            TextButton(
              onPressed: () {
                // Navegação para a página de cadastro
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: const Text('Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}
