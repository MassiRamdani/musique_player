import 'dart:async';

import 'package:audioplayer/audioplayer.dart';

 import 'package:flutter/material.dart';

import 'musique.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Music player'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Musique> maListMusique = [
    new Musique("Theme swifts", "Justin beber", "assets/un.jpg",
        "https://codabee.com/wp-content/uploads/2018/06/un.mp3"),
    new Musique("Theme flutter", "Yasmine auto", "assets/deux.jpg",
        "https://codabee.com/wp-content/uploads/2018/06/deux.mp3")
  ];

  late Musique maMusiqueAcctuel;
  late Duration position = new Duration(seconds: 0);
    Duration duree = new Duration(seconds: 0);
  PlayersState statut = PlayersState.stoped;
  late AudioPlayer audioPlayer;
  late StreamSubscription posSub;
  late StreamSubscription statusSub;

  @override
  void initState() {
    super.initState();
    maMusiqueAcctuel = maListMusique[0];
    ConfigAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              elevation: 10.0,
              child: new Container(
                width: MediaQuery.of(context).size.height / 2.5,
                child: new Image.asset(maMusiqueAcctuel.pathImage),
              ),
            ),
            textAvecStyle(maMusiqueAcctuel.title, 1.5),
            textAvecStyle(maMusiqueAcctuel.artiste, 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                button(Icons.fast_rewind, 30, ActionMusique.rewind),
                button(Icons.play_arrow, 45, ActionMusique.play),
                button(Icons.fast_forward, 30, ActionMusique.forward)
              ],
            ),
            Slider(
                value: position.inSeconds.toDouble(),
                min: 0.0,
                max: 30.0,
                inactiveColor: Colors.white,
                activeColor: Colors.red,
                onChanged: (double d) {
                  setState(() {
                    Duration nouvelleDuration =
                        new Duration(seconds: d.toInt());
                    position = nouvelleDuration;
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textAvecStyle('0:0', 0.8),
                textAvecStyle('0:22', 0.8),
              ],
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  IconButton button(IconData icone, double taille, ActionMusique action) {
    return new IconButton(
        icon: new Icon(icone),
        iconSize: taille,
        color: Colors.white,
        onPressed: () {
          switch (action) {
            case ActionMusique.play:
              print("play");
              break;
            case ActionMusique.pause:
              print("play");
              break;
            case ActionMusique.rewind:
              print("rewind");
              break;
            case ActionMusique.forward:
              print("forward");
              break;
          }
        });
  }

  Text textAvecStyle(String data, double scale) {
    return new Text(
      data,
      textScaleFactor: scale,
      textAlign: TextAlign.center,
      style: new TextStyle(
        fontSize: 20.0,
        color: Colors.white,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  void ConfigAudioPlayer() {
    audioPlayer = new AudioPlayer();
    posSub = audioPlayer.onAudioPositionChanged
        .listen((pos) => setState(() => position = pos));
    statusSub = audioPlayer.onPlayerStateChanged.listen((state) {
      if (state ==  AudioPlayerState.PLAYING) {
        setState(() {
          duree = audioPlayer.duration;
        });
      } else if (state == AudioPlayerState.STOPPED) {
        setState(() {
          statut = PlayersState.stoped;
        });
      }
    }, onError: (message) {
      print('erreur:  $message');
      setState(() {
        statut = PlayersState.stoped;
        duree == new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }
}

enum ActionMusique { play, pause, rewind, forward }
enum PlayersState { playing, stoped, paused }
