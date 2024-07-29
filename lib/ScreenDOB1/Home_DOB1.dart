import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeDOB1 extends StatefulWidget {
  const HomeDOB1({super.key});

  @override
  _HomeDOB1State createState() => _HomeDOB1State();
}

class _HomeDOB1State extends State<HomeDOB1> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
  backgroundColor: const Color(0xFF1C74B3), // Warna biru
  bottom: TabBar(
    labelColor: Colors.white, // Warna tulisan tab
    unselectedLabelColor: Colors.white54, // Warna tulisan tab yang tidak terpilih
    tabs: const [
      Tab(text: 'Dewasa'),
      Tab(text: 'Anak-anak'),
    ],
  ),
  title: const Text('Formulir Pasien'),
),

        body: const TabBarView(
          children: [
            DewasaForm(),
            AnakAnakForm(),
          ],
        ),
      ),
    );
  }
}

class DewasaForm extends StatefulWidget {
  const DewasaForm({super.key});

  @override
  _DewasaFormState createState() => _DewasaFormState();
}

class _DewasaFormState extends State<DewasaForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _umurController = TextEditingController();
  final TextEditingController _beratBadanController = TextEditingController();
  final TextEditingController _luasLukaBakarController = TextEditingController();
  String _jenisKelamin = 'Pria';

  double? _hasilPerhitungan;

  Future<void> _saveDataToFirestore() async {
    if (_formKey.currentState!.validate()) {
      final double umur = double.tryParse(_umurController.text) ?? 0;

      // Validasi umur
      if (umur < 12) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Umur harus 12 tahun atau lebih untuk tab Dewasa.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      final double beratBadan = double.tryParse(_beratBadanController.text) ?? 0;
      final double luasLukaBakar = double.tryParse(_luasLukaBakarController.text) ?? 0;

      // Menggunakan rumus yang disesuaikan
      final double hasil = 4 * beratBadan * luasLukaBakar;

      await FirebaseFirestore.instance.collection('pasien').add({
        'nama': _namaController.text,
        'umur': _umurController.text,
        'jenis_kelamin': _jenisKelamin,
        'berat_badan': beratBadan,
        'luas_luka_bakar': luasLukaBakar,
        'hasil_perhitungan': hasil,
        'timestamp': Timestamp.now(),
      });

      setState(() {
        _hasilPerhitungan = hasil;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hasil Perhitungan',
                    style: TextStyle(
                      color: Color(0xFF1C74B3), // Warna biru
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Nama Pasien: ${_namaController.text}', style: const TextStyle(color: Colors.black, fontSize: 16)),
                  Text('Umur: ${_umurController.text} tahun', style: const TextStyle(color: Colors.black, fontSize: 16)),
                  Text('Jenis Kelamin: $_jenisKelamin', style: const TextStyle(color: Colors.black, fontSize: 16)),
                  const Divider(color: Color(0xFF1C74B3)), // Warna biru
                  Text('Berat Badan: ${_beratBadanController.text} kg', style: const TextStyle(color: Colors.black, fontSize: 16)),
                  Text('Luas Luka Bakar: ${_luasLukaBakarController.text} %', style: const TextStyle(color: Colors.black, fontSize: 16)),
                  const Divider(color: Color(0xFF1C74B3)), // Warna biru
                  Text('Hasil Perhitungan: ${_hasilPerhitungan?.toStringAsFixed(2)} ml', style: const TextStyle(color: Colors.black, fontSize: 16)),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK', style: TextStyle(color: Color(0xFF1C74B3), fontSize: 16)), // Warna biru
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF1C74B3)), // Warna biru
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
              ],
            ),
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama Pasien',
                labelStyle: const TextStyle(color: Color(0xFF1C74B3)), // Warna biru
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap masukkan nama pasien';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _umurController,
              decoration: InputDecoration(
                labelText: 'Umur (tahun)',
                labelStyle: const TextStyle(color: Color(0xFF1C74B3)), // Warna biru
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap masukkan umur pasien';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _jenisKelamin,
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                labelText: 'Jenis Kelamin',
                labelStyle: const TextStyle(color: Color(0xFF1C74B3)), // Warna biru
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Pria',
                  child: Text('Pria', style: TextStyle(color: Colors.black)),
                ),
                DropdownMenuItem(
                  value: 'Wanita',
                  child: Text('Wanita', style: TextStyle(color: Colors.black)),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _jenisKelamin = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap pilih jenis kelamin';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'lib/assets/adult_image.png', // Gambar berbeda untuk dewasa
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _beratBadanController,
              decoration: InputDecoration(
                labelText: 'Berat Badan (kg)',
                labelStyle: const TextStyle(color: Color(0xFF1C74B3)), // Warna biru
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap masukkan berat badan pasien';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _luasLukaBakarController,
              decoration: InputDecoration(
                labelText: 'Luas Luka Bakar (%)',
                labelStyle: const TextStyle(color: Color(0xFF1C74B3)), // Warna biru
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap masukkan luas luka bakar pasien';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDataToFirestore,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF1C74B3), // Warna biru
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }
}


class AnakAnakForm extends StatefulWidget {
  const AnakAnakForm({super.key});

  @override
  _AnakAnakFormState createState() => _AnakAnakFormState();
}

class _AnakAnakFormState extends State<AnakAnakForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _umurController = TextEditingController();
  final TextEditingController _beratBadanController = TextEditingController();
  final TextEditingController _luasLukaBakarController = TextEditingController();
  String _jenisKelamin = 'Pria';

  double? _hasilPerhitungan;

  Future<void> _saveDataToFirestore() async {
    if (_formKey.currentState!.validate()) {
      final double umur = double.tryParse(_umurController.text) ?? 0;

      // Validasi umur
      if (umur < 0 || umur > 12) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Umur harus antara 0-12 tahun untuk tab Anak-anak.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      final double beratBadan = double.tryParse(_beratBadanController.text) ?? 0;
      final double luasLukaBakar = double.tryParse(_luasLukaBakarController.text) ?? 0;

      // Menggunakan rumus yang disesuaikan
      final double hasil = 4 * beratBadan * luasLukaBakar;

      await FirebaseFirestore.instance.collection('pasien').add({
        'nama': _namaController.text,
        'umur': _umurController.text,
        'jenis_kelamin': _jenisKelamin,
        'berat_badan': beratBadan,
        'luas_luka_bakar': luasLukaBakar,
        'hasil_perhitungan': hasil,
        'timestamp': Timestamp.now(),
      });

      setState(() {
        _hasilPerhitungan = hasil;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hasil Perhitungan',
                    style: TextStyle(
                      color: Color(0xFF1C74B3), // Warna biru
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Nama Pasien: ${_namaController.text}', style: const TextStyle(color: Colors.black, fontSize: 16)),
                  Text('Umur: ${_umurController.text} tahun', style: const TextStyle(color: Colors.black, fontSize: 16)),
                  Text('Jenis Kelamin: $_jenisKelamin', style: const TextStyle(color: Colors.black, fontSize: 16)),
                  const Divider(color: Color(0xFF1C74B3)), // Warna biru
                  Text('Berat Badan: ${_beratBadanController.text} kg', style: const TextStyle(color: Colors.black, fontSize: 16)),
                  Text('Luas Luka Bakar: ${_luasLukaBakarController.text} %', style: const TextStyle(color: Colors.black, fontSize: 16)),
                  const Divider(color: Color(0xFF1C74B3)), // Warna biru
                  Text('Hasil Perhitungan: ${_hasilPerhitungan?.toStringAsFixed(2)} ml', style: const TextStyle(color: Colors.black, fontSize: 16)),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK', style: TextStyle(color: Color(0xFF1C74B3), fontSize: 16)), // Warna biru
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF1C74B3)), // Warna biru
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
              ],
            ),
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama Pasien',
                labelStyle: const TextStyle(color: Color(0xFF1C74B3)), // Warna biru
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap masukkan nama pasien';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _umurController,
              decoration: InputDecoration(
                labelText: 'Umur (tahun)',
                labelStyle: const TextStyle(color: Color(0xFF1C74B3)), // Warna biru
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap masukkan umur pasien';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _jenisKelamin,
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                labelText: 'Jenis Kelamin',
                labelStyle: const TextStyle(color: Color(0xFF1C74B3)), // Warna biru
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Pria',
                  child: Text('Pria', style: TextStyle(color: Colors.black)),
                ),
                DropdownMenuItem(
                  value: 'Wanita',
                  child: Text('Wanita', style: TextStyle(color: Colors.black)),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _jenisKelamin = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap pilih jenis kelamin';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'lib/assets/kids_image.png', // Gambar berbeda untuk anak-anak
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _beratBadanController,
              decoration: InputDecoration(
                labelText: 'Berat Badan (kg)',
                labelStyle: const TextStyle(color: Color(0xFF1C74B3)), // Warna biru
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap masukkan berat badan pasien';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _luasLukaBakarController,
              decoration: InputDecoration(
                labelText: 'Luas Luka Bakar (%)',
                labelStyle: const TextStyle(color: Color(0xFF1C74B3)), // Warna biru
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1C74B3)), // Warna biru
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap masukkan luas luka bakar pasien';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDataToFirestore,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF1C74B3), // Warna biru
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }
}
