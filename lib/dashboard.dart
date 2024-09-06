import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Website Gallery SMKN 4 Bogor'),
          backgroundColor: Color(0xFFC63C51),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'Beranda'),
              Tab(icon: Icon(Icons.info), text: 'Informasi'),
              Tab(icon: Icon(Icons.photo_library), text: 'Galeri'),
              Tab(icon: Icon(Icons.event), text: 'Agenda'),
            ],
            labelColor: Color.fromARGB(255, 231, 208, 211),
            unselectedLabelColor: const Color.fromARGB(255, 252, 252, 252),
            indicatorColor: Color.fromARGB(255, 248, 248, 248),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
        ),
        body: TabBarView(
          children: [
            BerandaTab(),
            InfoTab(),
            GalleryTab(),
            AgendaTab(),
          ],
        ),
      ),
    );
  }
}

class BerandaTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang di SMK Negeri 4 Bogor!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Tempat di mana mimpi dan pendidikan bergabung untuk masa depan yang lebih baik.',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTab extends StatefulWidget {
  @override
  _InfoTabState createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  late Future<List<Info>> _futureInfo;

  @override
  void initState() {
    super.initState();
    _futureInfo = fetchInfo();
  }

  Future<List<Info>> fetchInfo() async {
    final response = await http.get(Uri.parse(
        'https://praktikum-cpanel-unbin.com/api_asih_kamila_hani_siti/informasi.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((info) => Info.fromJson(info)).toList();
    } else {
      throw Exception('Gagal memuat informasi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Info>>(
      future: _futureInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final infoList = snapshot.data!;
          return ListView.builder(
            itemCount: infoList.length,
            itemBuilder: (context, index) {
              final info = infoList[index];
              return ListTile(
                title: Text(info.judul),
                subtitle: Text(info.tanggal),
                onTap: () {
                  _showInfoDetail(context, info);
                },
              );
            },
          );
        } else {
          return Center(child: Text('Tidak ada data tersedia'));
        }
      },
    );
  }

  void _showInfoDetail(BuildContext context, Info info) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(info.judul),
          content: Text(info.isi),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}

class GalleryTab extends StatefulWidget {
  @override
  _GalleryTabState createState() => _GalleryTabState();
}

class _GalleryTabState extends State<GalleryTab> {
  late Future<List<Gallery>> _futureGallery;

  @override
  void initState() {
    super.initState();
    _futureGallery = fetchGallery();
  }

  Future<List<Gallery>> fetchGallery() async {
    final response = await http.get(Uri.parse(
        'https://praktikum-cpanel-unbin.com/api_asih_kamila_hani_siti/galery.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((gallery) => Gallery.fromJson(gallery)).toList();
    } else {
      throw Exception('Gagal memuat galeri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Gallery>>(
      future: _futureGallery,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final galleryList = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: galleryList.length,
            itemBuilder: (context, index) {
              final gallery = galleryList[index];
              return Card(
                child: Column(
                  children: [
                    Image.network(gallery.imgUrl),
                    SizedBox(height: 10),
                    Text(gallery.judul),
                  ],
                ),
              );
            },
          );
        } else {
          return Center(child: Text('Tidak ada data tersedia'));
        }
      },
    );
  }
}

class AgendaTab extends StatefulWidget {
  @override
  _AgendaTabState createState() => _AgendaTabState();
}

class _AgendaTabState extends State<AgendaTab> {
  late Future<List<Agenda>> _futureAgenda;

  @override
  void initState() {
    super.initState();
    _futureAgenda = fetchAgenda();
  }

  Future<List<Agenda>> fetchAgenda() async {
    final response = await http.get(Uri.parse(
        'https://praktikum-cpanel-unbin.com/api_asih_kamila_hani_siti/agenda.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((agenda) => Agenda.fromJson(agenda)).toList();
    } else {
      throw Exception('Gagal memuat agenda');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Agenda>>(
      future: _futureAgenda,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final agendaList = snapshot.data!;
          return ListView.builder(
            itemCount: agendaList.length,
            itemBuilder: (context, index) {
              final agenda = agendaList[index];
              return ListTile(
                title: Text(agenda.judul),
                subtitle: Text(agenda.tanggal),
                onTap: () {
                  _showAgendaDetail(context, agenda);
                },
              );
            },
          );
        } else {
          return Center(child: Text('Tidak ada data tersedia'));
        }
      },
    );
  }

  void _showAgendaDetail(BuildContext context, Agenda agenda) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(agenda.judul),
          content: Text('Tanggal: ${agenda.tanggal}\n${agenda.isi}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}

class Info {
  final String judul;
  final String isi;
  final String tanggal;

  Info({required this.judul, required this.isi, required this.tanggal});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      judul: json['judul_info'],
      isi: json['isi_info'],
      tanggal: json['tgl_info'],
    );
  }
}

class Gallery {
  final String judul;
  final String imgUrl;

  Gallery({required this.judul, required this.imgUrl});

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      judul: json['judul_galeri'],
      imgUrl: json['img_galeri'],
    );
  }
}

class Agenda {
  final String judul;
  final String isi;
  final String tanggal;

  Agenda({required this.judul, required this.isi, required this.tanggal});

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      judul: json['judul_agenda'],
      isi: json['isi_agenda'],
      tanggal: json['tgl_agenda'],
    );
  }
}
