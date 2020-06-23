import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sprawdzam/email_verification_api_call.dart';

import 'DomainSearch.dart';
import 'EmailFinder.dart';
import 'EmailVerification.dart';
import 'EmailVerificationSaved.dart';
import 'SavedEmails.dart';
import 'circularButton.dart';
import 'colorTheme.dart';
import 'local_db.dart';

String appTitle = "Hunter.io";
bool mode = false;

getAppBarColor(){
  Color AppBarColor;
  switch(mode){
    case false:{
      AppBarColor = colorTheme().primaryColor;
    }
    break;
    case true:{
      AppBarColor = colorTheme().primaryColorDark;
    }
    break;
  }
  return AppBarColor;

}
getAppBarColorAccent(){
  Color AppBarColor;
  switch(mode){
    case false:{
      AppBarColor = colorTheme().primaryColorAccent;
    }
    break;
    case true:{
      AppBarColor = colorTheme().primaryColorDarkAccent;
    }
    break;
  }
  return AppBarColor;


}
Widget AppBody;
setAppBody(Widget Body){
  AppBody = Body;
}

getAppBody(){
  return AppBody;
}
void main() {
  runApp(MyApp());
}
String ApiKey="b7abd28c12e9bedac17d169c03d88279456641c3";
getApiKey(){
  return ApiKey;
}
setApiKey(String Key){
  ApiKey=Key;
}
String InputEmail;
getEmail(){
  return InputEmail;

}
setEmail(String mail){
  InputEmail= mail;
}
String InputDomain;
getDomain(){
  return InputDomain;
}
setDomain(String domain){
  InputDomain= domain;

String InputName;
getName(){
  return InputName;
}
setName(String name){
  InputName = name;
}

String InputSurname;
getSurname(){
  return InputSurname;
}
setSurname(String surname){
  InputSurname = surname;
}

}
List<EmailAddress> savedMails;
setSavedMails(List list){
  savedMails = list;

}
getSavedMails(){
  return savedMails;
}
List<String> tempSavedMails=[];
getTempSavedMails(){
  return tempSavedMails;
}
setTempSavedMails(List mails){
  tempSavedMails=mails;
}
removeFromTempSavedList(String mail){
  tempSavedMails.removeWhere((element) => element==mail);


}
addToTempSavedList(String mail){
  tempSavedMails.add(mail);
}
class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      home: MyHomePage(title: appTitle),
      theme: theme.getTheme(),
    );
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<ThemeChanger>(
      builder: (_) => ThemeChanger(ThemeData.light()),
      child: new MaterialAppWithTheme(),
    );

  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final domainController = TextEditingController();
  final emailEditingController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  AnimationController animationController,animationControllerSmallerFab;
  Animation degOneTranslationAnimation,mainButtonCliclTranslationAnimation,degOneTranslationAnimationScale,smallButtonCliclTranslationAnimation;



  double getRadians (double degree){
    return degree/57.295779513;
  }
  @override
  void initState(){
    var dh = DBHelper();
    dh.init();


    animationController= AnimationController(vsync:this,duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = Tween(begin: 1.0, end: 0.0).animate(animationController);
    degOneTranslationAnimationScale= Tween(begin: 0.0, end: 1.0).animate(animationController);
    mainButtonCliclTranslationAnimation= TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0, end: 0.6),weight: 50),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.6, end: 1.0),weight: 50)
    ]).animate(animationController);
    animationController.addListener(() {
      setState(() {

      });
    });
    void dbTesting() async {
      final list = await dh.emails();
      setState(() {
        setSavedMails(list);
        list.forEach((element) {addToTempSavedList(element.value.toString()); });
      });

    }
    dbTesting();
    super.initState();

  }

  void _pushSaved() {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          /*final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();*/


          return Scaffold(
            appBar: AppBar(
              backgroundColor: getAppBarColor(),
              title: Text('Options'),
              /*backgroundColor: colorTheme().primaryColor*/
            ),
            body:  Center(
              child: ListView(/*children: divided*/
                children: <Widget>[
                  Padding(
                    padding:  EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: Row(
                        children: <Widget>[
                          Text("Night mode", style: _biggerFont,),
                          Switch(
                            value: mode,
                            onChanged: (bool state){
                              setState(() {
                                switch(state){
                                  case false:{
                                    _themeChanger.setTheme(ThemeData.light());
                                  }
                                  break;
                                  case true:{
                                    _themeChanger.setTheme(ThemeData.dark());
                                  }
                                  break;

                                }
                                mode=state;

                              });


                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(

                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: <Widget>[
                        Text("Your api key:", style: _biggerFont,),
                        Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          width: 250,
                          child: TextField(
                            controller: TextEditingController(text: getApiKey()),
                            onChanged: (text){
                              setApiKey(text);
                            },
                            decoration: InputDecoration(
                                hintText: "Enter your Api Key"
                            ),
                          ),
                        ),

                      ],
                    ),
                  )
                ],),
            )
            ,
          );
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
/*    MainBody _bodyChanger = Provider.of<MainBody>(context);*/

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          backgroundColor: getAppBarColor(),
          title: Text('Hunter.io'),
          actions: <Widget>[      // Add 3 lines from here...
            IconButton(icon: Icon(Icons.settings), onPressed: _pushSaved),
          ],                      // ... to here.
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                  decoration:BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[getAppBarColorAccent(),getAppBarColor()])
                  )
                  ,child: Center(
                child: Container(
                  height: 120,
                  width: 120,
                  child: Material(

                    elevation: 10,
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),

                    child: Padding(

                      padding: EdgeInsets.all(17.0),
                      child: Image.asset("images/hunterio.png",height: 100,width: 100,),
                    ),
                  ),
                ),
              )),
              customListTile(Icons.search,"Searched Domains",colorTheme().mailColor,(){setState(() {
                setAppBody(DomainSearchLayout());
                Navigator.of(context).pop();
              });}),
              customListTile(Icons.perm_identity,"Found E-mails",colorTheme().domainColor,(){setState(() {
                setAppBody(EmailFinderLayout());
                Navigator.of(context).pop();
              });}),
              customListTile(Icons.verified_user,"Verified mails",colorTheme().verifieduserColor,(){setState(() {

                setAppBody(EmailVerificationLayout());
                Navigator.of(context).pop();
              });}),
              customListTile(Icons.star,"Saved E-mails",Colors.yellow,(){setState(() {
                Navigator.of(context).pop();
                setAppBody(EmailSaved());
              });})
            ],
          ),
        ),

        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: getAppBody(),
        )
        ,
        floatingActionButton: Stack(
          children: <Widget>[



            Positioned(
              height: 160,
              width: 160,
              bottom: 0,
              right: 0,

              child: Stack(
                children: [
                  Positioned(
                    bottom: 105,
                    right: 5,
                    child: Transform.translate(
                      offset: Offset.fromDirection(getRadians(90),degOneTranslationAnimation.value * 100),
                      child: Transform.scale(
                        scale: degOneTranslationAnimationScale.value,
                        child: circularButton(
                          width: 50,
                          height: 50,
                          icon: Icon(Icons.search,color: Colors.white),
                          color: Colors.blue,
                          onClick: (){
                            animationController.reverse();
                            return showDialog(context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    content: SingleChildScrollView(
                                      child: TextField(
                                        controller: domainController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: "company.com"
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                        disabledColor: Colors.grey,
                                        disabledTextColor: Colors.black,
                                        padding: EdgeInsets.all(8.0),
                                        /* splashColor: Colors.blueAccent,*/
                                        child: Text('Find email adress'),
                                        onPressed: () {
                                          setState(() {
                                            setDomain(domainController.text);
                                            setAppBody(DomainSearchLayout());
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),

                                    ],
                                    title: Container(child: Row(
                                      children: <Widget>[
                                        Icon(Icons.search,color: Colors.blue),
                                        Text("Domain search"),
                                      ],
                                    )),
                                  ) ;
                                });},
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 70,
                    right: 75,
                    child: Transform.translate(
                      offset: Offset.fromDirection(getRadians(45),degOneTranslationAnimation.value * 100),
                      child: Transform.scale(
                        scale: degOneTranslationAnimationScale.value,
                        child: circularButton(
                          width: 50,
                          height: 50,
                          icon: Icon(Icons.perm_identity,color: Colors.white),
                          color: Colors.green,
                          onClick: (){
                            animationController.reverse();
                            return showDialog(context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    content: Container(
                                      height: 150,
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex:1,
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: 8),
                                              child: TextField(
                                                controller: nameController,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: "First name"
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex:1,
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: 8),
                                              child: TextField(
                                                controller: surnameController,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: "Last name"
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex:1,
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: 8),
                                              child: TextField(
                                                controller: domainController,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: "Domain"
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Cancel'),
                                        onPressed: () {

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                        disabledColor: Colors.grey,
                                        disabledTextColor: Colors.black,
                                        padding: EdgeInsets.all(8.0),
                                        /* splashColor: Colors.blueAccent,*/
                                        child: Text('Search'),
                                        onPressed: () {
                                          setState(() {
                                           // setName(nameController.text);
                                           // setSurname(surnameController.text);
                                            setDomain(domainController.text);
                                            setAppBody(EmailFinderLayout());
                                            Navigator.of(context).pop();
                                          });

                                        },
                                      ),

                                    ],
                                    title: Container(child: Row(
                                      children: <Widget>[
                                        Icon(Icons.perm_identity,color: Colors.green),
                                        Text(" Email Finder"),
                                      ],
                                    )),
                                  ) ;
                                });
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 105,
                    child: Transform.translate(
                      offset: Offset.fromDirection(getRadians(0),degOneTranslationAnimation.value * 100),

                      child: Transform.scale(
                        scale: degOneTranslationAnimationScale.value,
                        child: circularButton(
                          width: 50,
                          height: 50,
                          icon: Icon(Icons.verified_user,color: Colors.white),
                          color: Colors.orangeAccent,
                          onClick: (){
                            animationController.reverse();
                            return showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    content: SingleChildScrollView(

                                      child: TextField(
                                        controller: emailEditingController,
//                                        validator: (value) {
//                                          if (value.isEmpty) {
//                                            return 'Please enter a valid email address';
//                                          }
//                                          if (!value.contains('@')) {
//                                            return 'Email is invalid, must contain @';
//                                          }
//                                          if (!value.contains('.')) {
//                                            return 'Email is invalid, must contain .';
//                                          }
//                                          return null;
//                                        },
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: "johndoe@company.com"
                                        ),

                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Cancel'),
                                        onPressed: () {

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                        disabledColor: Colors.grey,
                                        disabledTextColor: Colors.black,
                                        padding: EdgeInsets.all(8.0),
                                        /* splashColor: Colors.blueAccent,*/
                                        child: Text('Verify'),
                                        onPressed: () {setState(() {
                                          setEmail(emailEditingController.text);
                                          setAppBody(EmailVerificationLayout());
//                                          if (czyPrawda.prawda == false) {
//                                            Fluttertoast.showToast(
//                                                msg: czyPrawda.prawda.toString(),
//                                                toastLength: Toast.LENGTH_LONG,
//                                                gravity: ToastGravity.BOTTOM,
//                                                backgroundColor: Colors.blue,
//                                                textColor: Colors.white,
//                                                fontSize: 16.0);
                                          Navigator.pop(context);
////                                          setAppBody(EmailVerificationLayout());
////                                          Navigator.pop(context);
//                                        });
                                        });


                                        },
                                      ),

                                    ],
                                    title: Container(child: Row(
                                      children: <Widget>[
                                        Icon(Icons.verified_user,color: Colors.orangeAccent),
                                        Text(" Email Verifier")

                                      ],
                                    )),
                                  ) ;
                                });

                          },
                        ),
                      ),
                    ),
                  ),


                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Transform.scale(
                      scale: mainButtonCliclTranslationAnimation.value,
                      child: circularButton(
                        width: 60,
                        height: 60,
                        icon: Icon(Icons.list,color: Colors.white),
                        color: Colors.deepPurple,
                        onClick: (){
                          if (animationController.isCompleted){
                            animationController.reverse();
                          }
                          else{
                            animationController.forward();
                          }
                        },
                      ),
                    ),
                  ),



                ],
              ),
            )
          ],
        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class customListTile extends StatelessWidget{
  String text;
  final iconColor;
  final icon;
  final Function onClick;

  customListTile(this.icon,this.text,this.iconColor,this.onClick);
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(bottom:20.0 ),

      child: Padding(
        padding:  EdgeInsets.only(left: 20.0, right: 20.0),
        child: Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
          child: InkWell(
            /*splashColor: Colors.orangeAccent,*/
            onTap: onClick,
            child: Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(icon, color: iconColor,size: 30,),

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(text, style: TextStyle(fontSize: 20.0 ),),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class czyPrawda {
  static bool prawda = false;
}