import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      songName: 'Tune Jo Na Kaha',
      artistName: 'Mohit Chauhan',
      audioPath: 'audio/Tune Jo Na Kaha.mp3',
      albumImageArtPath: 'assets/images/TuneJoNaKaha.jpg',
    ),
    Song(
      songName: 'Saiyaan',
      artistName: 'Kailash Kher',
      audioPath: 'audio/Saiyaan - Kailash Kher.mp3',
      albumImageArtPath: 'assets/images/kailashKher.jpg',
    ),
    Song(
      songName: 'Bulleya',
      artistName: 'Papon',
      audioPath: 'audio/bulleya.mp3',
      albumImageArtPath: 'assets/images/Sultan.jpg',
    ),
    Song(
      songName: 'Aaoge Tum Kabhi',
      artistName: 'The Local Train',
      audioPath: 'audio/Aaoge tum kabhi.mp3',
      albumImageArtPath: 'assets/images/theLocalTrain.jpg',
    ),
  ];
  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  //constructor
  PlaylistProvider() {
    listenToDuration();
  }

  //initially not playing
  bool _isPlaying = false;

  //play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  //pause the song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  //resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //Check is playing or paused
  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  //seek postion
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      //if not on last song
      if (_currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      }
      //if on last song
      else {
        currentSongIndex = 0;
      }
    }
    notifyListeners();
  }

  //play previous song
  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
    notifyListeners();
  }

  void listenToDuration() {
    //listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    //listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    //listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
      notifyListeners();
    });
  }

  //Current Song Index
  int? _currentSongIndex;

  //getters
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  //setter
  set currentSongIndex(int? songIndex) {
    _currentSongIndex = songIndex;
    if (songIndex != null) {
      play();
    }
    notifyListeners();
  }
}
