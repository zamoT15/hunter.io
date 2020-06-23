import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'domain_search_api_call.dart';
import 'email_verification_api_call.dart';
import 'main.dart';
import 'local_db.dart';


class emailVerification extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EmailVerificationLayout(),
    );
  }
// #enddocregion build
}

class EmailVerificationState extends State<EmailVerificationLayout> {

  Future<EmailVerification> futureEmailVerification;
  Future<List<Email>> futureEmails;




  @override
  Widget build(BuildContext context) {
    String _Email;
    String _ApiKey;
    setState(() {
      _Email = getEmail();
      _ApiKey = getApiKey();
    });
    futureEmailVerification = emailVerificationApiCall.fetchVerif(
        "marcin.lawnik@polsl.pl",  _ApiKey);
    return Scaffold(
      body: FutureBuilder<EmailVerification>(
        future: futureEmailVerification,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var dh = DBHelper();
            dh.init();
            final ea = EmailAddress(value:snapshot.data.data.email);
            List _saved=getTempSavedMails();
            final alreadySaved = _saved.contains(snapshot.data.data.email);
            return ListTile(
              title: Text(snapshot.data.data.email,style: TextStyle(fontSize: 18.0)),
              leading: CircleAvatar(child: Text(snapshot.data.data.email[0].toUpperCase(),style: TextStyle(color: Colors.white),),backgroundColor: Colors.blueGrey,)
              , subtitle: Row(
              children: <Widget>[
                Text("Score: ",style: TextStyle(fontWeight: FontWeight.bold)),
                Text(snapshot.data.data.score.toString()),
                Text(" Result: ",style: TextStyle(fontWeight: FontWeight.bold)),
                Text(snapshot.data.data.result)
              ],
            ),
              trailing: Icon(
                alreadySaved ? Icons.star : Icons.star_border,
                color: alreadySaved ? Colors.yellow : null,
              ),
              onTap: () {
                //Saving email
                setState(() {

                  if(alreadySaved){
                    dh.removeEmailAddress(ea.value);
                    removeFromTempSavedList(snapshot.data.data.email);
                    // _saved.removeWhere((item)=> item==snapshot.data.data.email);

                  }else{

                    //   _saved.add(snapshot.data.data.email);
                    dh.addEmailAddress(ea);
                    addToTempSavedList(snapshot.data.data.email);


                  }
                });

              },


            );

          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return   Center(
              child: CircularProgressIndicator()
          );
        },
      ),
    );
  }
}



// #enddocregion RWS-build

class EmailVerificationLayout extends StatefulWidget {


  @override
  EmailVerificationState createState() => EmailVerificationState();
}
