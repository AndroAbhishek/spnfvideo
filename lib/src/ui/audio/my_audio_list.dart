import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:SPNF/database/AppDatabase.dart';
import 'package:SPNF/model/Audio_Model.dart';
import 'package:SPNF/model/Datum.dart';
import 'package:SPNF/model/Multimedia.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:SPNF/src/ui/audio/custom_list_tile.dart';
import 'package:SPNF/utils/Constants.dart';
import 'package:SPNF/utils/FireStoreQuery.dart';
import 'package:SPNF/utils/PreferenceUtils.dart';


class MyAudioList extends StatefulWidget with WidgetsBindingObserver{

  final String choiceValue;

  MyAudioList({Key? key, required this.choiceValue}) : super(key: key);

  @override
  _MyAudioListState createState() => _MyAudioListState();
}

class _MyAudioListState extends State<MyAudioList> {

  bool downloading = false;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String currentTitle = "";
  late String currentCover = "";
  String currentSinger = "";
  String currentSong = "";
  IconData iconData = Icons.play_arrow;
  bool isLoading = false;
  bool isVisible = false;
  late Dio dio ;
  int _selectedIndex = -1;
  String _progress = "";
  int progressInt = 0;
  var filterList =[];
  List<Datum> list_multimedia_data =[];
  late final file;
  final datacount = GetStorage();
  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  bool isGetDataFromServer = true;
  Duration duration = new Duration();
  Duration position = new Duration();
  var doublePosition;
  List files= [];
  List stringFiles= [];


  @override
  void initState() {
    getAudioFromLocalDB();
    getListFiles();
    super.initState();
    notificationBuilder();
    dio = Dio();
  }

  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.paused){
      audioPlayer.pause();
    }
  }


  Future<void> _download(String urlPath, String fileName, index) async {
    final dir = await getExternalStorageDirectory();
    final isPermissionStatusGranted = await datacount.read(Constants.PERMISSION);
    if (isPermissionStatusGranted) {
      var value = "";
      if(dir?.path.isEmpty == true){
        value = "";
      } else {
        value = dir!.path;
      }
      final savePath = path.join(value, fileName);
      await _startDownload(savePath,urlPath,value);
    } else {


    }
  }

  Future<void> _startDownload(String savePath, String urlPath, String value) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await dio.download(
          urlPath,
          savePath,
          onReceiveProgress: _onReceiveProgress
      );
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;

    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      await _showNotification(result,savePath);
      progressInt = 0;
    }

  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + "%";
        progressInt = (received / total * 100).toInt();
        print('progress downloading $_progress');
      });
    }
  }

  bool isExist(int index){
    return File(datacount.read(Constants.FILEPATH) !=null ?  datacount.read(Constants.FILEPATH) : "").existsSync();
  }

  @override
  Widget build(BuildContext context) {
     setState(() {
       filterList.clear();
       if(widget.choiceValue.isNotEmpty && widget.choiceValue != 'All') {
        filterList.addAll(
            list_multimedia_data.where((e) => e.id == widget.choiceValue)
                .toList().map((e) => e.audio).toList());
      }else{
         filterList.addAll(list_multimedia_data.map((e) => e.audio).toList());
      }
     });

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: filterList[0].length,
                    itemBuilder: (context, index) => customListTile(
                      onTap: () {
                        setState(() {
                          if(isExist(index)){
                            playMusic(datacount.read(Constants.FILEPATH));
                          }else{
                            String fetchurl = filterList[0][index].url.toString().substring(4);
                            String remainingurl;
                            if(fetchurl.startsWith(':')){
                              remainingurl = 'https'+fetchurl;
                            }else{
                              remainingurl = 'http' + fetchurl;
                            }
                            playMusic(remainingurl);
                          }
                          currentTitle = filterList[0][index].title;
                          currentSinger = Constants.SubhashPalekar;
                        });
                      },
                      onPressed: (){
                        getListFiles();
                        setState(() {
                          _selectedIndex = index;
                        });
                        _download(filterList[0][index].URL, filterList[0][index].title+'.mp3',filterList[0][index]);
                      },
                        title:  filterList[0][index].title,
                        singer: Constants.SubhashPalekar,
                        progress :  progressInt,
                        selectedIndex :  _selectedIndex,
                        index : index,
                        fileList: stringFiles,
                    ),
                ), decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: new DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
                    image: new NetworkImage('https://images.unsplash.com/photo-1622310505762-a813a1c2e0bf?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Z3JlZW4lMjBjb2xvdXJ8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80',),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isVisible,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
                    image: new NetworkImage('https://images.unsplash.com/photo-1622310505762-a813a1c2e0bf?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Z3JlZW4lMjBjb2xvdXJ8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80',),
                  ),
                ),
                child: Column(
                  children: [
                    Slider.adaptive(
                      activeColor: Colors.red,
                      inactiveColor: Colors.grey,
                      value: position.inSeconds.toDouble(),
                      min: 0.0,
                      max: duration.inSeconds.toDouble(),
                      onChanged: (double value){
                        setState(() {
                          changedToSecond(value.toInt());
                          value =value;
                        });
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            position.toString().split(".")[0],
                            style: TextStyle(
                                fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            duration.toString().split(".")[0],
                            style: TextStyle(
                                fontSize: 12,
                              color: Colors.white70,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0,left: 12.0,right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Container(
                          height: 50.0,
                          width: 50.0,
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/Subhash_Palekar.jpg"),
                            radius: 40.0,
                          ),
                        ),
                        SizedBox(width:16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentTitle,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.purple[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                currentSinger,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if(isPlaying){
                                audioPlayer.pause();
                                setState(() {
                                  iconData = Icons.play_arrow;
                                  isPlaying= false;
                                });
                              }else{
                                audioPlayer.resume();
                                setState(() {
                                  iconData = Icons.pause;
                                  isPlaying = true;
                                });
                              }
                            },
                            icon: Icon(
                              iconData,
                              color: Colors.red,
                            ),
                          iconSize: 42.0,
                        ),
                      ],),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*Future<List> getMusicList() async{
    try{
      CollectionReference _collectionRef = FirebaseFirestore.instance.collection('data');
      QuerySnapshot querySnapshot = await _collectionRef.orderBy('timeStamp',descending: true).getSavyMultimedia();
      var timeStamps= await convertStringToDate(PreferenceUtils.getString(Constants.SAVEDMULTIMEDIATIME)!);
      await _collectionRef
          .orderBy('timeStamp',descending: true)
          .where(
          'timeStamp',isGreaterThan:timeStamps)
          .getSavyMultimedia().then((event) {
        if (event.docs.isNotEmpty) {
          updated_List = event.docs.map((doc) => doc.data()).toList();
          for(var i=0; i<updated_List.length;i++){
            if(updated_List[i]['media_type']== 'A'){
              updatedListTemp.add(updated_List[i]);
            }
          }
          cache_List = querySnapshot.docs.map((doc) => doc.data()).toList();
          for(var i=0; i<updated_List.length;i++){
            if(updated_List[i]['media_type']== 'A'){
              cacheListTemp.add(updated_List[i]);
            }
          }
          audioList = new List.from(cacheListTemp)..addAll(updatedListTemp);
        }else{
          updated_List = querySnapshot.docs.map((doc) => doc.data()).toList();
          for(var i=0; i<updated_List.length;i++){
            if(updated_List[i]['media_type']== 'A'){
              audioList.add(updated_List[i]);
            }
          }
        }
      }).catchError((e) => print("error fetching data: $e"));
    }catch(e){
      print(e);
    }
    return audioList;
  }
*/


  Future<Timestamp> convertStringToDate(String dateTime) async {
    DateTime dt = DateTime.parse(dateTime);
    Timestamp myTimeStamp = Timestamp.fromDate(dt);
    return myTimeStamp;
  }


  Future<void> _showNotification(Map<String, dynamic> downloadStatus, String value) async {
    final android = AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        priority: Priority.high,
        importance: Importance.max
    );
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];
    downloading = downloadStatus['isSuccess'];
    datacount.write(Constants.FILEPATH, value);
    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess ? 'File has been downloaded successfully!' : 'There was an error while downloading the file.',
        platform,
        payload: json
    );
  }




  /*
  *   MUSIC PLAYER
  * */
  void playMusic(String url) async{

    if(isPlaying && currentSong !=url){
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if(result == 1){
        setState(() {
          isVisible = true;
          currentSong = url;
        });
      }
    }else if(!isPlaying){
      int result = await  audioPlayer.play(url);
      if(result == 1){
        setState(() {
          isPlaying = true;
          iconData = Icons.pause;
          isVisible = true;
        });
      }
    }

    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position  = event;

      });
    });


  }

  /*
  * AFTER SELECTING DOWNLOADED AUDIO FROM NOTIFICATION PLAY
  *
  * */
  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  void notificationBuilder() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (String? json) async {
          _onSelectNotification(json!);
        });
  }

  void changedToSecond(int second) {
      Duration newDuration = Duration(seconds: second);
      audioPlayer.seek(newDuration);
  }

  Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);

    lister.listen((file) async {
      FileStat f = file.statSync();
      if (f.type == FileSystemEntityType.directory) {
        await dirContents(Directory(file.uri.toFilePath()));
      } else if (f.type == FileSystemEntityType.file && file.path.endsWith('.mp3')) {
        files.add(file);
      }
    }, onDone: () {
      completer.complete(files);
      setState(() {
        //
      });
    });
    return completer.future;
  }

  void getListFiles() async{
    Directory dir = Directory('/storage/emulated/0/Android/data/com.example.subhashpalekarapp/files/');
    files = await dirContents(dir);
    for(int i=0; i<files.length;i++){
      String basename =files[i].path;
      stringFiles.add(basename);
    }

  }

  Future<List> getAudioFromLocalDB() async{
    final appDatabase = await $FloorAppDatabase.databaseBuilder('multimedia_Subhash.db').build();
    final m_dao=appDatabase.multimediaDao;
    final result = await m_dao.fetchAllStoredData();
    Map<String, dynamic> dataLocal = jsonDecode(
        result?[result.length-1].jsonData?.trim() ?? "");
    Multimedia multimedia = Multimedia.fromJson(dataLocal);
    list_multimedia_data =  multimedia.data;
    return list_multimedia_data;
  }

}


