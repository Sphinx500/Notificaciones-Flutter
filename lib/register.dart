import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Database.dart';

enum NoteMode {
  Editing,
  Adding
}

class Note extends StatefulWidget {

  final NoteMode noteMode;
  final Map<String, dynamic> note;

  Note(this.noteMode, this.note);

  @override
  NoteState createState() {
    return new NoteState();
  }
}

class NoteState extends State<Note> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  int Num;
  int Hora;
  int Minuto;
  int Segundo;
  int dia;
  int mes;
  int year;



  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;


  Future scheuleAtParticularTime(DateTime timee) async {
    var time = Time(timee.hour, timee.minute, timee.second);
    print(time.toString());

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id', 'channel_name', 'channel_description',
    );

    var IOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, IOSPlatformChannelSpecifics);
    var now = new DateTime.now();
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        widget.note['title'],
        widget.note['text'],
        time,
        platformChannelSpecifics, payload: 'Hello from my data');

    //Ver la hora programada
    Fluttertoast.showToast(
      msg: "Scheduled at time ${time.hour} : ${time.minute} : ${time.second} ",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
    );
  }
  @override
  void initState() {
    super.initState();
    initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future _onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    await Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new SecondPage(payload: payload,)));
    print('Called On Select local Notification');
  }

  Future _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SecondPage(payload: payload,)));
              },
            ),
          ],
        ));
    print('Called On did Receive local Notification');
  }


  @override
  void didChangeDependencies() {
    if (widget.noteMode == NoteMode.Editing) {
      _titleController.text = widget.note['title'];
      _textController.text = widget.note['text'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
            widget.noteMode == NoteMode.Adding ? 'Add note' : 'Edit note'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  hintText: 'Note title'
              ),
            ),
            Container(height: 8,),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                  hintText: 'Note text'
              ),
            ),
            Container(height: 16.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _NoteButton('Save', Colors.blue, () {
                  var title = _titleController.text;
                  var text = _textController.text;

                  if (widget?.noteMode == NoteMode.Adding) {
                    NoteProvider.insertNote({
                      'title': title,
                      'text': text
                    });
                  } else if (widget?.noteMode == NoteMode.Editing) {
                    NoteProvider.updateNote({
                      'id': widget.note['id'],
                      'title': _titleController.text,
                      'text': _textController.text,
                    });
                  }
                  Navigator.pop(context);
                  print(title);
                  print(text);
                  print(Hora);
                  print(Minuto);
                  print(Segundo);
                  print(dia);
                  print(mes);
                  print(year);
                }),
                Container(height: 16.0,),
                _NoteButton('Discard', Colors.grey, () {
                  Navigator.pop(context);
                }),
                widget.noteMode == NoteMode.Editing ?
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _NoteButton('Delete', Colors.red, () async {
                    await NoteProvider.deleteNote(widget.note['id']);
                    Navigator.pop(context);
                  }),
                )
                    : Container()
              ],
            ),
            Container(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Container(height: 30.0),
            MaterialButton(
              onPressed: () {
                DatePicker.showDateTimePicker(context, showTitleActions: true, onChanged: (date) {
                  print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                }, onConfirm: (date) {
                  setState(() {
                    Hora = date.hour;
                    Minuto = date.minute;
                    Segundo = date.second;
                    year = date.year;
                    mes = date.month;
                    dia = date.day;

                  });
                  print('confirm $date');
                  //NOTIFICACIÓN
                  scheuleAtParticularTime(
                      DateTime.fromMillisecondsSinceEpoch(
                          date.millisecondsSinceEpoch)
                  );
                }, currentTime: DateTime.now(), locale: LocaleType.es);},
              child: Text('Agregar recordatorio',
                style: TextStyle(color: Colors.white),
              ),
              height: 40,
              minWidth: 80,
              color: Colors.purple,
            ),
          ],
        ),
        ]
      ),
    )
    );
  }
}

class _NoteButton extends StatelessWidget {

  final String _text;
  final Color _color;
  final Function _onPressed;

  _NoteButton(this._text, this._color, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      child: Text(
        _text,
        style: TextStyle(color: Colors.white),
      ),
      height: 40,
      minWidth: 100,
      color: _color,
    );
  }
}

//DATETIME PICKER
class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.day);
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
        this.currentLeftIndex(), this.currentMiddleIndex(), this.currentRightIndex())
        : DateTime(currentTime.year, currentTime.month, currentTime.day, this.currentLeftIndex(),
        this.currentMiddleIndex(), this.currentRightIndex());
  }
}

class SecondPage extends StatelessWidget {

  final String payload;
  const SecondPage({Key key, this.payload}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: new Text('$payload'),
        ),
        body: Column(
            children: <Widget>[
              MaterialButton(
                  child: Text('Go back...'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),

            ]
        ));
  }
}