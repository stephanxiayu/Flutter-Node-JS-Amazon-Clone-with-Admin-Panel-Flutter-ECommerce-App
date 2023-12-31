// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_veriables.dart';
import 'package:amazon_clone/constants/utilis.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/router.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void createAccount({
    required String email,
    required BuildContext context,
    required String name,
    required String password,
  }) async {
    try {
      User user = User(
          id: "",
          name: name,
          password: password,
          address: "",
          type: "",
          token: "",
          email: email);

      http.Response res = await http.post(Uri.parse("$uri/api/signup"),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Account erfolgreich erstellt");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void loginUser({
    required String email,
    required BuildContext context,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse("$uri/api/signin"),
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

    
      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();

            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await sharedPreferences.setString(
                'x-auth-token', jsonDecode(res.body)['token']);
            Navigator.pushAndRemoveUntil(
                context,
                generateRoute(const RouteSettings(name: HomeScreen.routeName)),
                (route) => false);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

//get user Data 
Future<void> getUserData(

     BuildContext context,
   
  ) async {
    try {
      SharedPreferences preferences=await SharedPreferences.getInstance();
      String ? token=preferences.getString('x-auth-token');

      if(token==null){
        preferences.setString('x-auth-token', '');
      }

   var tokenRes=   await http.post(Uri.parse("$uri/tokenIsValid"),
   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token':token!

   }
   );

var response =  jsonDecode(  tokenRes.body);
      if(response==true){
      http.Response userRes=  await http.get(Uri.parse("$uri/"), headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token':token

   });
   var userProvider=Provider.of<UserProvider>(context, listen:false);
   userProvider.setUser(userRes.body);
      }
     
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }


}
