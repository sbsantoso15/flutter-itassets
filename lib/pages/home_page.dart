import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:itassets/pages/login_page.dart';
import 'logout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/jumlahpc.dart';
import './nondomain/pc_nondomain.dart';
import './domain/pc_domain.dart';

// import 'conf_exit.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PcDomain()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PcNonDomain()),
        );
        break;
    }
  }

  List<JmlPcModel> jumlahPc = [];

  var url = Uri.parse("${dotenv.env['API']}/jumlahPc");

  Future getJumlahPc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    try {
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            (json.decode(response.body) as Map<String, dynamic>)["data"];
        jumlahPc.add(JmlPcModel.fromJson(data));
        print(jumlahPc.length);
      }
    } catch (e) {
      Center(
        child: Text("Error $e"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.red[900],
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       logout();
          //       Navigator.pushReplacement(context,
          //           MaterialPageRoute(builder: (context) => const LoginPage()));
          //     },
          //     icon: const Icon(Icons.logout),
          //     color: Colors.white,
          //   ),
          // ],
        ),
        body: ListView(
          children: [
            FutureBuilder(
              future: getJumlahPc(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text("Loading ..."),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          "PC Domain",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PcDomain()));
                          },
                          child: Container(
                            height: 120,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.blue[900],
                            ),
                            child: Center(
                              child: Text(
                                jumlahPc[0].domain.toString(),
                                style: const TextStyle(
                                    fontSize: 60, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "PC Non Domain",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PcNonDomain()));
                          },
                          child: Container(
                            height: 120,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.blue[900],
                            ),
                            child: Center(
                              child: Text(
                                jumlahPc[0].nondomain.toString(),
                                style: const TextStyle(
                                    fontSize: 60, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Total PC",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 120,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.red[900],
                          ),
                          child: Center(
                            child: Text(
                              jumlahPc[0].total.toString(),
                              style: const TextStyle(
                                  fontSize: 60, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red[900],
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.computer),
              label: "Pc Domain",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.computer_outlined),
              label: "Non Domain",
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool? exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit app?"),
          content: const Text("Do you want close the app?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                logout();
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
    return exitApp ?? false;
  }
}
