import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:follow_pet/pages/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: "AIzaSyA2_J6wgAiZT7AErIhAYG8bPUq5Djj95xo",
          appId: "1:946004064158:web:24cceb7620d61bf1d4088f",
          messagingSenderId: "946004064158",
          projectId: "follow-pet-68b31",
        storageBucket: "follow-pet-68b31.appspot.com",),
    );
  }else{
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Beklenmeyen bir hata oluştu..."),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return GirisEkrani();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class GirisEkrani extends StatefulWidget {
  @override
  _GirisEkraniState createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _kayitOl() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Hata"),
            content: Text("Lütfen şifre alanını doldurun."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Tamam"),
              ),
            ],
          );
        },
      );
    } else {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("Kayıt Başarılı: ${userCredential.user?.email}");

        passwordController.clear();
      } on FirebaseAuthException catch (e) {
        // Kayıt sırasında hata oluştu
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Hata"),
              content: Text(_getErrorMessage(e.code)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Tamam"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _girisYap() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Hata"),
            content: Text("Lütfen şifre alanını doldurun."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Tamam"),
              ),
            ],
          );
        },
      );
    } else {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        print("Giriş Başarılı: ${userCredential.user?.email}");

        passwordController.clear();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Hata"),
              content: Text(_getErrorMessage(e.code)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Tamam"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'user-disabled':
        return 'Bu kullanıcı devre dışı bırakılmış.';
      case 'user-not-found':
        return 'Kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Geçersiz kullanıcı adı veya şifre.';
      default:
        return 'Bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent[200],
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('resim/arkaplan.jpg'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 45),
            const Text(
              "Hello",
              style: TextStyle(
                inherit: true,
                fontSize: 90,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
                fontFamily: 'DancingScript',
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "E-posta",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Şifre",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    minimumSize: Size(120, 50),
                  ),
                  onPressed: _kayitOl,
                  child: const Text(
                    "Kayıt Ol",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    minimumSize: Size(120, 50),
                  ),
                  onPressed: _girisYap,
                  child: const Text(
                    "Giriş Yap",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
