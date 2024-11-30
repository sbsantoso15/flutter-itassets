import 'package:flutter/material.dart';
import '../home_page.dart';
import '../domain/pc_domain.dart';
import '../logout.dart';

import '../../models/cabang.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';

// import 'package:dropdown_search/dropdown_search.dart';

class PcNonDomain extends StatefulWidget {
  const PcNonDomain({super.key});

  @override
  State<PcNonDomain> createState() => _PcNonDomainState();
}

class _PcNonDomainState extends State<PcNonDomain> {
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = 2;
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
  List<CabangModel> listCabang = [];
  Future getCabangtApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    try {
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        // Map<String, dynamic> data =
        //     (json.decode(response.body) as Map<String, dynamic>)["data"];
        var data = json.decode(response.body);
        listCabang.add(CabangModel.fromJson(data));
        debugPrint(data['namacab']);
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
            "Pc Non Domain",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.red[900],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: FutureBuilder(
            future: getCabangtApi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("Loading ..."),
                );
              }
              return const Center(child: Text('data'));
              // return DropdownSearch<CabangModel>(
              //   key: dropDownKey,
              //   items: listCabang.first,
              //   itemAsString: (item) => item.namacab,
              //   decoratorProps: const DropDownDecoratorProps(
              //     decoration: InputDecoration(
              //       labelText: 'Cabang:',
              //       border: OutlineInputBorder(),
              //     ),
              //   ),
              // );
            },
          ),
          // child: DropdownSearch<String> (
          //   key: dropDownKey,
          //   selectedItem: "Menu",
          //   items: listCabang,
          //   decoratorProps: const DropDownDecoratorProps(
          //     decoration: InputDecoration(
          //       labelText: 'Cabang ',
          //       border: OutlineInputBorder(),
          //     ),
          //   ),
          //   popupProps: const PopupProps.menu(
          //     fit: FlexFit.loose,
          //     constraints: BoxConstraints(),
          //     showSearchBox: true,
          //   ),
          // ),
        ),
        bottomNavigationBar: bottomNavigator(),
      ),
    );
  }

  final dropDownKey = GlobalKey<DropdownSearchState>();
  Center body() {
    return Center(
      child: DropdownSearch<String>(
        key: dropDownKey,
        selectedItem: "Menu",
        items: (filter, infiniteScrollProps) =>
            ["Menu", "Dialog", "Modal", "BottomSheet"],
        decoratorProps: const DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: 'Examples for: ',
            border: OutlineInputBorder(),
          ),
        ),
        popupProps: const PopupProps.menu(
          fit: FlexFit.loose,
          constraints: BoxConstraints(),
        ),
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
                Navigator.of(context).pop(true);
                logout();
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
