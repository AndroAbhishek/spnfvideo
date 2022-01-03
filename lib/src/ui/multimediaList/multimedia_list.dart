import 'dart:convert';

import 'package:SPNF/database/AppDatabase.dart';
import 'package:SPNF/database/multimedia_dao.dart';
import 'package:SPNF/model/Languages.dart';
import 'package:SPNF/model/Model_Multimedia.dart';
import 'package:SPNF/model/Multimedia.dart';
import 'package:SPNF/src/ui/audio/my_audio_list.dart';
import 'package:SPNF/src/ui/video/my_youtube_video_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:SPNF/utils/Constants.dart';
import 'package:SPNF/utils/connectionStatusSingleton.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


/*final languageRef = FirebaseFirestore.instance.collection('data');*/
class MultimediaList extends StatefulWidget {


  @override
  _MultimediaListState createState() => _MultimediaListState();
}

class _MultimediaListState extends State<MultimediaList> {

  String choiceValue ="";
  int index =0;
  List<Languages> languages_List = [];
  final datacount = GetStorage();
  int _selectedIndex = 0;
  late AppDatabase appDatabase;
  late multimedia_dao m_dao;
  bool isLoading = false;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];


  @override
  void initState() {
    getPermission();
    _makeGetRequest();
    //getCurrentTime();
    super.initState();
    Provider.of<ConnectionStatusSingleton>(context,listen: false).startMonitoring();

  }


  Future<bool> getPermission() async {
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
    if(status == PermissionStatus.granted){
      datacount.write(Constants.PERMISSION, true);
    }else{
      datacount.write(Constants.PERMISSION, false);
    }

    return status == PermissionStatus.granted;
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_selectedIndex].currentState!.maybePop();

        print(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: isLoading
          ? Center(
          child: CircularProgressIndicator(),
      )
      : Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text('SPNF Training'),
          centerTitle: true,
          actions: [
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return languages_List.map((item) => (
                    PopupMenuItem<String>(
                      value: item.id,
                      child: Text(item.name),
                    )),
                ).toList();
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          selectedItemColor: Colors.red,
          showUnselectedLabels: false,
          backgroundColor: Colors.green[900],

          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.video_collection,
                color: Colors.white,
              ),
              label: 'Video',
              activeIcon: Icon(
                Icons.video_collection,
                color: Colors.red,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.audiotrack,
                color: Colors.white,
              ),
              label: 'Audio',
              activeIcon: Icon(
                Icons.audiotrack,
                color: Colors.red,
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },

        ),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
          ],
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    if(choiceValue.isEmpty){
      choiceValue = Constants.DEFAULTLANGUAGE;
    }else{
      choiceValue = choiceValue;
    }
    return {
      '/': (context) {
        return [
          MyYoutubeVideoPage(choiceValue: choiceValue),
          MyAudioList(choiceValue: choiceValue),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);
    var route_builder_temp;
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          route_builder_temp = routeBuilders[routeSettings.name];
          if(route_builder_temp!=null){
            return MaterialPageRoute(
              builder: (context) => route_builder_temp(context),
            );
          }
        },
      ),
    );
  }


  choiceAction(String choice) {
    setState(() {
      choiceValue = choiceValue.isNotEmpty ? choice : Constants.DEFAULTLANGUAGE;;
    });
  }

/*  Future<List> getLanguageFinal() async{
    try{
      CollectionReference _collectionRef = FirebaseFirestore.instance.collection('languages');
      QuerySnapshot querySnapshot = await _collectionRef.orderBy('timeStamp',descending: true).getSavy();
      DateStringToTimeStamp dst= new DateStringToTimeStamp();
      var timeStamps= await dst.convertStringToDate(PreferenceUtils.getString(Constants.SAVEDTIMESTAMP)!);
      await _collectionRef
          .orderBy('timeStamp',descending: true)
          .where(
          'timeStamp',isGreaterThan:timeStamps)
          .getSavy().then((event) {
        if (event.docs.isNotEmpty) {
          updated_List = event.docs.map((doc) => doc.data()).toList();
          cache_List = querySnapshot.docs.map((doc) => doc.data()).toList();
          languages_List = new List.from(cache_List)..addAll(updated_List);
        }else{
          languages_List = querySnapshot.docs.map((doc) => doc.data()).toList();
        }
      }).catchError((e) => print("error fetching data: $e"));
    }catch(e){
      print(e);
    }
    return languages_List;
  }*/

  Future<Timestamp> convertStringToDate(String dateTime) async {
    DateTime dt = DateTime.parse(dateTime);
    Timestamp myTimeStamp = Timestamp.fromDate(dt);
    return myTimeStamp;
  }

  _makeGetRequest() async{
    try{
      setState(() {
        isLoading = true;
      });

      var url = Uri.parse("https://ia902307.us.archive.org/19/items/spnf-training-app/SPNF_TrainingAppData.json");
      http.Response response = await http.get(url) ;
      String json= utf8.decode(response.bodyBytes);
      final appDatabase = await $FloorAppDatabase.databaseBuilder('multimedia_Subhash.db').build();
      final m_dao=appDatabase.multimediaDao;
      String replaceJson = json.replaceAll('\n', "").replaceAll('\r', "").trim();
      Map<String,dynamic> dataServer = jsonDecode(replaceJson);
      if(dataServer['version']!=null){
        final result = await m_dao.fetchAllStoredData();
        if(result!.length > 0){
          var jsonId = result[result.length-1].json_id;
          if(jsonId?.toString() == dataServer['version']) {
            //fetch Data from Local Database
            fetchDataFromLocalDB(result);
          }else{
            //update Local Database
              updateLocalDB(dataServer,replaceJson);
          }
        }else{
          //update Local Database
          updateLocalDB(dataServer,replaceJson);
        }
      }
    }catch(e){
      print(e);
    }
  }


  Future<List> updateLocalDB(Map<String, dynamic> dataServer, String replaceJson) async{
    try{
      final appDatabase = await $FloorAppDatabase.databaseBuilder('multimedia_Subhash.db').build();
      final m_dao=appDatabase.multimediaDao;
      Model_Multimedia model_multimedia = Model_Multimedia.fromJson(dataServer['version'],replaceJson);
      await m_dao.insertMultimedia(model_multimedia);
      final result = await m_dao.fetchAllStoredData();

      Map<String,dynamic> data = jsonDecode(result?[result.length-1].jsonData?.trim() ?? "");
      Multimedia multimedia = Multimedia.fromJson(data);
      languages_List = multimedia.languages;
      print(multimedia.languages);
    }catch(e){
      print(e);
    }
    setState(() {
      isLoading =false;
    });
    return languages_List;
  }

  Future<List> fetchDataFromLocalDB(List<Model_Multimedia> result) async{
    Map<String, dynamic> dataLocal = jsonDecode(
        result[result.length-1].jsonData?.trim() ?? "");
    Multimedia multimedia = await Multimedia.fromJson(dataLocal);
    languages_List = multimedia.languages;
    setState(() {
      isLoading =false;
    });

    return languages_List;

  }

  /*void getCurrentTime() {
    var currentDeviceTime = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(currentDeviceTime);
    var setDeviceTime = DateTime.parse('$formatted 09:00:00');
    if(currentDeviceTime.isAfter(setDeviceTime) && isRefreshClicked==false){
      //enableButton
    }else if(currentDeviceTime.isAfter(setDeviceTime) && isRefreshClicked==true){
      //disableButton
    }else if(currentDeviceTime.isBefore(setDeviceTime) && isRefreshClicked==false){
      //disableButton
    }else if(currentDeviceTime.isBefore(setDeviceTime) && isRefreshClicked == true){
      //enableButton
    }
  }*/
}
