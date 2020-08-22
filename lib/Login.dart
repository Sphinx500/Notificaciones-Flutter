
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Cards.dart';


class Login extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Login> {
  final formKey = new GlobalKey<FormState>();

  final _controllerUser = TextEditingController();
  final _controllerPass = TextEditingController();
  final _controllerMail = TextEditingController();

  String _usuario;
  String _contrasena;
  String _email;

  String saveuser = '';
  String savemail = '';

  String user = '';
  String pass = '';
  String mail = '';

  @override
  Widget build(BuildContext context) {
    setState(() {
      obtenerPreferencias();
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title:
        Text('REGISTRO',style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25),
            child: Center(
              child: Container(
                height: 120,
                width: 120,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          new Padding(padding: EdgeInsets.all(7.0)),
          new Padding(padding: EdgeInsets.all(7.0)),
          new Divider(
              color: Colors.purple,
              indent: 20,
              endIndent: 20,
              thickness: 3.0),
          Padding(
            padding: const EdgeInsets.all(1),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 20.0,left: 20.0),
                                child: TextFormField(
                                  validator: (valor) =>
                                  valor.length < 3
                                      ? 'Nombre incorrecto'
                                      : null,
                                  controller: _controllerUser,
                                  onSaved: (valor) => _usuario = valor,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.verified_user),
                                    labelText: 'Nombre ',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Colors.pink,
                                        width: 3,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Colors.pink,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 20.0,left: 20.0),
                              child: TextFormField(
                                controller: _controllerMail,
                                validator: (valor) =>
                                !valor.contains('@')
                                    ? 'Correo incorrecto, inténtalo de nuevo'
                                    : null,
                                onSaved: (valor) => _email = valor,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.mail),
                                  labelText: 'Correo electrónico',
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.pink,
                                      width: 3,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: Colors.pink,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 20.0,left: 20.0),
                              child: TextFormField(
                                controller: _controllerPass,
                                validator: (valor) =>
                                valor.length < 3
                                    ? 'Incorrecto, inténtalo de nuevo'
                                    : null,
                                onSaved: (valor) => _contrasena = valor,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.enhanced_encryption),
                                  labelText: 'Contraseña',
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.pink,
                                      width: 3,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: Colors.blue[500],
                                      width: 3,
                                    ),
                                  ),
                                ),
                                obscureText: true,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          height: 40,
                          child: RaisedButton(
                            onPressed: () {
                              final form = formKey.currentState;
                              if (form.validate()) {
                                setState(() {
                                  user = _controllerUser.text;
                                  mail = _controllerMail.text;
                                  guardarPreferencias();
                                });
                                pushPage();
                              }
                            },
                            color: Colors.deepPurple,
                            child: Text(
                              'Registrar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //PANTALLA DE USUARIO
  @override
  void initState() {
    super.initState();
    _checkRegistro();
  }

  Future _checkRegistro() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool('_sesion')) {
      Navigator.push(context,MaterialPageRoute(builder: (context) {
        return new Scaffold(
          appBar: AppBar(
            title: new Text("Perfil de Usuario"),
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
          ),
          body:
          new Column(
            children: <Widget>[
              new Padding(padding: EdgeInsets.all(30.0)),
              Text(
                "DATOS DEL USUARIO",
                style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              new Padding(padding: EdgeInsets.all(5.0)),
              //RECORDATORIOS
              new Divider(
                  color: Colors.pink,
                  indent: 20,
                  endIndent: 20,
                  thickness: 3.0),
              new Padding(padding: EdgeInsets.all(30.0)),
              Text(
                "Nombre:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
              new Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  '$saveuser',
                  style: TextStyle(
                      fontSize: 25.0),
                ),
              ),
              new Padding(padding: EdgeInsets.all(30.0)),
              Text(
                "Correo electrónico:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
              new Padding(
                padding: EdgeInsets.all(5.0),
                child: Text('$savemail',
                    style: TextStyle(
                        fontSize: 25.0)),
              ),
              new Padding(padding: EdgeInsets.all(20.0)),
              FilterChip(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 3,horizontal:10),
                label: Text('Recordatorios',
                  style: TextStyle(
                      color: Colors.white),),
                onSelected: (b) {
                  print(b);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => NoteList()
                  ));
                },
              ),
              new Padding(padding: EdgeInsets.all(10.0)),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  _CerrarSession();
                  print("Clicko");
                },
                child: new Text(
                  "Cerrar Sesión",
                  textScaleFactor: 1.0,
                ),
              ),
            ],

          ),
        );
      }));
    }
  }

  void pushPage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('_sesion',true);

    Navigator.push(context,MaterialPageRoute(builder: (context) {
      return new Scaffold(
        appBar: AppBar(
          title: new Text("Perfil de Usuario"),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body:
        new Column(
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(30.0)),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 150,
                width: 150,
              ),
            ),
            new Padding(padding: EdgeInsets.all(20.0)),
            FilterChip(
              backgroundColor: Colors.pink,
              padding: const EdgeInsets.symmetric(vertical: 3,horizontal:10),
              avatar: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.notification_important),
              ),
              label: Text('Recordatorios',
                style: TextStyle(
                    color: Colors.white),),
              onSelected: (b) {
                print(b);
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => NoteList()
                ));
              },
            ),
            Text(
              "DATOS DEL USUARIO",
              style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            new Padding(padding: EdgeInsets.all(5.0)),
            new Divider(
                color: Colors.blue[300],
                indent: 20,
                endIndent: 20,
                thickness: 3.0),
            new Padding(padding: EdgeInsets.all(40.0)),
            Text(
              "Nombre:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(user,
                    style: TextStyle(
                        fontSize: 25.0))),
            new Padding(padding: EdgeInsets.all(30.0)),
            Text(
              "Correo Electrónico:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            new Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(mail,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black))),
            new Padding(padding: EdgeInsets.all(60.0)),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.green[300],
              onPressed: () {
                _CerrarSession();
                print("Clicko");
              },
              child: new Text(
                "Cerrar Sesión",
                textScaleFactor: 1.0,
              ),
            ),
          ],
        ),
      );
    }));
  }

  Future<void> guardarPreferencias() async {
    SharedPreferences datos = await SharedPreferences.getInstance();
    datos.setString('nombre',_controllerUser.text);
    datos.setString('email',_controllerMail.text);
  }

  Future<void> obtenerPreferencias() async {
    SharedPreferences datos = await SharedPreferences.getInstance();
    setState(() {
      saveuser = datos.get('nombre') ?? user;
      savemail = datos.get('email') ?? mail;
    });
  }

  Future<void> _CerrarSession() async {
    final sharedprefs = await SharedPreferences.getInstance();
    sharedprefs.setBool('_sesion', false);
    setState(() {
      Navigator.pop(context,MaterialPageRoute(
          builder: (context) => Login()));
      saveuser = '';
      savemail = '';
    });
  }
}