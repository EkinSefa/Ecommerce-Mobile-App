import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopa/screens/Home/home_screen.dart';

class UserAuthPage extends StatefulWidget {
  const UserAuthPage({super.key});

  @override
  State<UserAuthPage> createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoginMode = true;

  Future<void> registerUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setString('address', addressController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kayıt başarılı!'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      isLoginMode = true;
    });
  }

  Future<void> loginUser() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    final storedPassword = prefs.getString('password');

    if (usernameController.text == storedUsername &&
        passwordController.text == storedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kullanıcı adı veya şifre hatalı!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isLoginMode ? 'Giriş Yap' : 'Kayıt Ol',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade200,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.blueGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLoginMode ? 'Hoş Geldiniz!' : 'Hesap Oluşturun',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Kullanıcı Adı',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    if (!isLoginMode) ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: 'Ev Adresi',
                          prefixIcon: const Icon(Icons.home),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        if (isLoginMode) {
                          loginUser();
                        } else {
                          registerUser();
                        }
                      },
                      child: Text(
                        isLoginMode ? 'Giriş Yap' : 'Kayıt Ol',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginMode = !isLoginMode;
                        });
                      },
                      child: Text(
                        isLoginMode
                            ? 'Hesabınız yok mu? Kayıt olun'
                            : 'Zaten bir hesabınız var mı? Giriş yapın',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
