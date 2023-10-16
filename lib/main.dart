import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(LyricsApp());
}

class LyricsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Lirik Lagu',
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: {
        '/': (context) => MainMenu(),
        '/lagu1': (context) => SongLyricsPage(
              title: 'Potong Bebek Angsa',
              lyrics: longLyrics1,
            ),
        '/lagu2': (context) => SongLyricsPage(
              title: 'Balonku Ada Lima',
              lyrics: longLyrics2,
            ),
        '/lirikTersimpan': (context) => LyricsSavedPage(),
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final String savedLyrics;

  CustomSearchDelegate(this.savedLyrics);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('Hasil Pencarian: $query');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('$query');
  }
}

class MainMenu extends StatelessWidget {
  Future<String> getSavedLyrics() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('savedLyrics') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getSavedLyrics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String savedLyrics = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Daftar Lagu'),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(savedLyrics),
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    savedLyrics,
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Container(
                    width: 500.0,
                    height: 35.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/lagu1');
                      },
                      child: Text('Potong Bebek Angsa'),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: 500.0,
                    height: 35.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/lagu2');
                      },
                      child: Text('Balonku ada lima'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class SongLyricsPage extends StatelessWidget {
  final String title;
  final String lyrics;

  SongLyricsPage({required this.title, required this.lyrics});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              lyrics,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class LyricsSavedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lirik Tersimpan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'Lirik telah berhasil disimpan!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

final String longLyrics1 = '''
Potong bebek angsa, masak di kuali
Nona minta dansa, dansa empat kali
Sorong ke kiri, sorong ke kanan
La-la-la-la-la-la-la-la-la, la-la
Sorong ke kiri, sorong ke kanan
La-la-la-la-la-la-la-la-la, la-la
Potong bebek angsa, masak di kuali
Nona minta dansa, dansa empat kali
Sorong ke kiri, sorong ke kanan
La-la-la-la-la-la-la-la-la, la-la
Sorong ke kiri, sorong ke kanan
La-la-la-la-la-la-la-la-la, la-la
''';

final String longLyrics2 = '''
Balonku ada lima
Rupa-rupa warnanya
Hijau, kuning, kelabu
Merah muda dan biru
Meletus balon hijau, dor!
Hatiku sangat kacau
Balonku tinggal empat
Kupegang erat-erat
Balonku ada lima
Rupa-rupa warnanya
Hijau, kuning, kelabu
Merah muda dan biru
Meletus balon hijau, dor!
Hatiku sangat kacau
Balonku tinggal empat
Kupegang erat-erat
''';
