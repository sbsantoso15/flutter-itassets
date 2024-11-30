import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_page.dart';
import '../nondomain/pc_nondomain.dart';
import '../logout.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../models/cabang.dart';
import 'package:http/http.dart' as http;

class PcDomain extends StatefulWidget {
  const PcDomain({super.key});

  @override
  State<PcDomain> createState() => _PcNonDomainState();
}

class _PcNonDomainState extends State<PcDomain> {
  late int _selectedIndex;
  String? kdCabang;
  late Future<List<CabangModel>> futureItems;

  @override
  void initState() {
    _selectedIndex = 1;
    futureItems = fetchItems();
    super.initState();
  }

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

  var url = Uri.parse("${dotenv.env['API']}/listCabang");
  Future<List<CabangModel>> fetchItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data = json.decode(response.body);
      return data.map((item) => CabangModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Pc Domain",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.red[900],
        ),
        body: body(),
        bottomNavigationBar: bottomNavigator(),
      ),
    );
  }

  Center body() {
    return Center(
      child: FutureBuilder<List<CabangModel>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No data available');
          } else {
            return DropdownSearch<CabangModel>(
              mode: Mode.custom,
              itemAsString: (CabangModel item) => item.namacab,
              onChanged: (CabangModel? selectedItem) {
                if (selectedItem != null) {
                  print('Selected Item: ${selectedItem.namacab}');
                }
              },
            );
          }
        },
      ),
    );
  }

  BottomNavigationBar bottomNavigator() {
    return BottomNavigationBar(
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

// class Item {
//   final int kodecab;
//   final String namacab;

//   Item({required this.kodecab, required this.namacab});

//   factory Item.fromJson(Map<String, dynamic> json) {
//     return Item(
//       kodecab: json['kodecab'],
//       namacab: json['namacab'],
//     );
//   }
// }
