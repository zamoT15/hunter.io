import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


Future<List<Email>> fetchEmails(String domain, String apiKey) async {
  String url = 'https://api.hunter.io/v2/domain-search';
  try {
    final http.Response response = await http.get(
        url + '?domain=' + domain + '&api_key=' + apiKey);
    _returnResponse(response);
  } on SocketException {
    print('Socket Exception. Check your network status. \n');
  }
  catch (e) {print('Unknown Exception: $e');}
//    if (response.statusCode == 200) {
//      // If the server did return a 200 OK response,
//      // then parse the JSON.
//      return emailsToList(response.body);
//    } else {
//      // If the server did not return a 200 OK response,
//      // then throw an exception.
//      print('Failed to load email, ${response.statusCode}');
//      /*
//      *
//      * TODO: Implement Error response handling
//      *
//      */
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      return emailsToList(response.body);
//    case 201:
//      return emailsToList(response.body.toString());
//    case 202:
//      Fluttertoast.showToast(
//          msg: "This is Short Toast",
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          backgroundColor: Colors.red,
//          textColor: Colors.white,
//          fontSize: 16.0
//      );
//    case 204:
//      throw Fluttertoast.showToast(
//          msg: "This is Short Toast",
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          backgroundColor: Colors.red,
//          textColor: Colors.white,
//          fontSize: 16.0
//      );
//    case 222:
//      Fluttertoast.showToast(
//          msg: "This is Short Toast",
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          backgroundColor: Colors.red,
//          textColor: Colors.white,
//          fontSize: 16.0
//      );
//  //throw EmailVerificationFailedException(response.body.toString());
//    case 400:
//      throw BadRequestException(response.body.toString());
//    case 401:
//      throw UnauthorisedException(response.body.toString());
//    case 403:
//
//    case 404:
//    case 422:
//    case 429:
//    case 451:
    default:
      return emailsToList(response.body);
//      throw FetchDataException(
//          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

class Email {
  final String value;
  final String type;
  final int confidence;
  final String firstName;
  final String lastName;
  final String position;
  final String department;

  Email(
      this.value, this.type, this.confidence,
      this.firstName, this.lastName,
      this.position, this.department
      );

  factory Email.fromJson(dynamic json) {
    return Email(
        json['value'] as String, json['type'] as String,
        json['confidence'] as int, json['first_name'] as String,
        json['last_name'] as String, json['position'] as String,
        json['department'] as String);
  }

  @override
  toString() {
    return(
        "${this.value}, ${this.type}, ${this.confidence}, " +
            "${this.firstName}, ${this.lastName}, ${this.position}, " +
            "${this.department}");
  }
}

emailsToList(String response) {
  var dataJson = jsonDecode(response)['data']['emails'];
  var emails = new List<Email>();
  for (var k in dataJson){emails.add(Email.fromJson(k));}

  return emails;
}