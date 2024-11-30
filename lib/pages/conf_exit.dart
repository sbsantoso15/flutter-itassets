import 'package:flutter/material.dart';

class ExitConfirmationScreen extends StatelessWidget {
  const ExitConfirmationScreen({super.key});

  // Fungsi untuk menangani aksi saat tombol back ditekan
  Future<bool> _onWillPop(BuildContext context) async {
    // Menampilkan dialog konfirmasi dan mengembalikan Future<bool>
    bool? exit = await showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // Menghindari penutupan dialog dengan mengetuk di luar dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Keluar"),
          content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Menutup dialog dan tidak keluar
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Menutup dialog dan keluar aplikasi
              },
              child: const Text("Keluar"),
            ),
          ],
        );
      },
    );
    // Pastikan kita mengembalikan nilai boolean dari dialog
    return exit ?? false; // Jika exit null, kembalikan false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context), // Menangani aksi back
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Konfirmasi Keluar"),
        ),
      ),
    );
  }
}
