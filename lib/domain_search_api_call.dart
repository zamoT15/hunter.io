import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'app_exceptions.dart';

class domainSearchApiCall {
  static Future<List<Email>> fetchEmails(String domain, String apiKey) async {
    var responseDomain;
    String url = 'https://api.hunter.io/v2/domain-search';
    try {
      final http.Response response =
      await http.get(url + '?domain=' + domain + '&api_key=' + apiKey);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Przeszło? " + response.statusCode.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
        return emailsToList(response.body);
      } else {
        responseDomain = _returnResponse(response);
        return responseDomain;
      }
    } on SocketException {
      print('Socket Exception. Check your network status. \n');
    } catch (e) {
      print('Unknown Exception: $e');
    }
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 201:
      return emailsToList(response.body.toString());
    case 202:
    case 204:
    case 222:
  //throw EmailVerificationFailedException(response.body.toString());
    case 400:
    Fluttertoast.showToast(
        msg: "Your request was not valid.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
    break;
      //throw BadRequestException(response.body.toString());
    case 401:
      throw UnauthorisedException(response.body.toString());
    case 403:

    case 404:
    case 422:
    case 429:
    case 451:
    default:
    Fluttertoast.showToast(
        msg: "Your request was not valid.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
    break;
      //return emailsToList(response.body);
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

  Email(this.value, this.type, this.confidence, this.firstName, this.lastName,
      this.position, this.department);

  factory Email.fromJson(dynamic json) {
    return Email(
        json['value'] as String,
        json['type'] as String,
        json['confidence'] as int,
        json['first_name'] as String,
        json['last_name'] as String,
        json['position'] as String,
        json['department'] as String);
  }

  @override
  toString() {
    return ("${this.value}, ${this.type}, ${this.confidence}, " +
        "${this.firstName}, ${this.lastName}, ${this.position}, " +
        "${this.department}");
  }
}

emailsToList(String response) {
  var dataJson = jsonDecode(response)['data']['emails'];
  var emails = new List<Email>();
  for (var k in dataJson) {
    emails.add(Email.fromJson(k));
  }

  return emails;
}
