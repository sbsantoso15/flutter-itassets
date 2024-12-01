import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import '../home_page.dart';
import '../domain/pc_domain.dart';
import '../logout.dart';

import '../../models/cabang.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dropdown_search/dropdown_search.dart';

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

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    try {
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      //print(response.body);
      if (response.statusCode == 200) {
        // List data =
        //     (json.decode(response.body) as Map<String, dynamic>)["data"];
        // // listCabang.add(CabangModel.fromJson(data.first));
        listCabang = ((json.decode(response.body)
                as Map<String, dynamic>)["data"] as List)
            .map((data) => CabangModel.fromJson(data))
            .toList();
      }
      //print(listCabang);
    } catch (e) {
      return Center(
        child: Text("Error: $e"),
      );
    }
    // try {
    //   var response = await http.get(url, headers: {
    //     'Authorization': 'Bearer $token',
    //     'Content-Type': 'application/json',
    //   });
    //   // if (response.statusCode == 200) {
    //   Map<String, dynamic> data =
    //       (json.decode(response.body) as Map<String, dynamic>)["data"];
    //   listCabang.add(CabangModel.fromJson(data));
    //   print(response.body);
    //   // }
    // } catch (e) {
    //   Center(
    //     child: Text("Error $e"),
    //   );
    // }
  }

  CabangModel? selectedCabang;

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
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("Loading ..."),
                );
              }
              // return const Center(child: Text('data'));
              return DropdownSearch<CabangModel>(
                items: listCabang,
                onChanged: (CabangModel? selectedBranch) {
                  setState(() {
                    selectedCabang = selectedBranch;
                    if (selectedBranch != null) {
                      print("Selected branch name: ${selectedBranch.kodecab}");
                      print("Selected branch id: ${selectedBranch.namacab}");
                    }
                  });
                },
                itemAsString: (CabangModel branch) => branch.namacab,
                popupProps: const PopupProps.menu(
                  //fit: FlexFit.loose,
                  constraints: BoxConstraints(),
                  showSearchBox: true,
                ),
                dropdownButtonProps: const DropdownButtonProps(
                  icon: Icon(Icons.arrow_drop_down),
                ),
                selectedItem: selectedCabang, // Display the selected branch
              );
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
