import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';
import 'app_exceptions.dart';

class emailVerificationApiCall {

  static Future<EmailVerification> fetchVerif(
      String email, String apiKey) async {
    String url = 'https://api.hunter.io/v2/email-verifier';
   // var responseVerification;
    try {
      final http.Response response =
          await http.get(url + '?email=' + email + '&api_key=' + apiKey);

      if (response.statusCode == 200) {
        czyPrawda.prawda = true;
        return EmailVerification.fromJson(json.decode(response.body));
      } else {
       return _returnResponse(response);
        //responseVerification = _returnResponse(response);
        //return responseVerification;
      }
    } on SocketException catch (e) {
      print('Socket Exception. Check your network status. \n$e');
    }
    catch (e) {print('Unknown Exception: $e');}
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

class EmailVerificationData {
  final String result;
  final int score;
  final String email;

  EmailVerificationData(this.result, this.score, this.email);

  factory EmailVerificationData.fromJson(dynamic json) {
    return EmailVerificationData(json['result'] as String, json['score'] as int,
        json['email'] as String);
  }
}

class EmailVerification {
  final EmailVerificationData data;
  EmailVerification({this.data});
  factory EmailVerification.fromJson(Map<String, dynamic> json) {
    return EmailVerification(
      data: EmailVerificationData.fromJson(json['data']),
    );
  }
}
