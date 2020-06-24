import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class domainSearchApiCall {
  static Future<List<Email>> fetchEmails(String domain, String apiKey) async {
    String url = 'https://api.hunter.io/v2/domain-search';
    try {
      final http.Response response =
      await http.get(url + '?domain=' + domain + '&api_key=' + apiKey);
      if (response.statusCode == 200) {
        return emailsToList(response.body);
      } else {
        return _returnResponse(response);
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
      throw Fluttertoast.showToast(
          msg: "The request was successful and the resource was created.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    case 202:
      throw Fluttertoast.showToast(
          msg: "The Email Verification is still in progress. "
              "Feel free to make the same Verification again as often as you want, "
              "it will only count as a single request until we return the response.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    case 204:
      throw Fluttertoast.showToast(
          msg: "The request was successful and no additional content was sent.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    case 222:
      throw Fluttertoast.showToast(
          msg:
          "The Email Verification failed because of an unexpected response from the remote SMTP server. "
              "This failure is outside of our control. We advise you to retry later.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
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
    case 401:
      throw Fluttertoast.showToast(
          msg: "No valid API key was provided.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    case 403:
      throw Fluttertoast.showToast(
          msg: "You have reached the rate limit.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    case 404:
      throw Fluttertoast.showToast(
          msg: "The requested resource does not exist.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    case 422:
      throw Fluttertoast.showToast(
          msg:
          "Your request is valid but the creation of the resource failed. Check the errors.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    case 429:
      throw Fluttertoast.showToast(
          msg:
          "You have reached your usage limit. Upgrade your plan if necessary.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    case 451:
      throw Fluttertoast.showToast(
          msg: "The person behind the requested resource has asked us directly"
              " or indirectly to stop the processing of this resource. "
              "For this reason, you shouldn't process this resource yourself in any way.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    default:
      throw Fluttertoast.showToast(
          msg: response.statusCode.toString() +
              " " +
              response.reasonPhrase.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
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
