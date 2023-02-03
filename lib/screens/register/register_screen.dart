import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:goowid_auth/app/core/client/http_client.dart';
import 'package:goowid_auth/app/core/failure/failure.dart';
import 'package:goowid_auth/utils/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, phone, email, password;
  final String emailFormat = "@goowid.com";
  bool isLoading = false;
  late String user;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late ScaffoldMessengerState scaffoldMessenger;
  var reg = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  double password_strength = 0;

  bool validatePassword(String password) {
    String _password = password.trim();

    if (_password.isEmpty) {
      setState(() {
        password_strength = 0;
      });
    } else if (_password.length < 6) {
      setState(() {
        password_strength = 1 / 4;
      });
    } else if (_password.length < 8) {
      setState(() {
        password_strength = 2 / 4;
      });
    } else {
      if (pass_valid.hasMatch(_password)) {
        setState(() {
          password_strength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          password_strength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 13,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          letterSpacing: 1,
                          fontSize: 34,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12)),
                                  hintText: "Name",
                                  hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                                ),
                                onSaved: (val) {
                                  name = val!;
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                                controller: _phoneController,
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12)),
                                  hintText: "Phone Number",
                                  hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                                ),
                                onSaved: (val) {
                                  phone = val!;
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                                controller: _emailController,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12)),
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                                ),
                                onSaved: (val) {
                                  email = val!;
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                                controller: _passwordController,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12)),
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                                ),
                                onChanged: (value) {
                                  _formKey.currentState!.validate();
                                },
                                onSaved: (val) {
                                  password = val!;
                                },
                                validator: (password) {
                                  if (password!.isEmpty) {
                                    return 'Please enter a password';
                                  } else {
                                    bool result = validatePassword(password);
                                    if (result) {
                                      return null;
                                    } else {
                                      return 'Password should contain Capital, small letter & Number & Special';
                                    }
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: LinearProgressIndicator(
                                  value: password_strength,
                                  backgroundColor: Colors.grey[300],
                                  minHeight: 5,
                                  color: password_strength <= 1 / 4
                                      ? Colors.red
                                      : password_strength == 2 / 4
                                          ? Colors.yellow
                                          : password_strength == 3 / 4
                                              ? Colors.blue
                                              : Colors.green,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF77D8E),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (isLoading) {
                                          return;
                                        }
                                        if (_nameController.text.isEmpty) {
                                          scaffoldMessenger.showSnackBar(
                                              const SnackBar(content: Text("Please Enter Name")));
                                          return;
                                        }
                                        if (!reg.hasMatch(_emailController.text)) {
                                          scaffoldMessenger.showSnackBar(
                                              const SnackBar(content: Text("Enter Valid Email")));
                                          return;
                                        }
                                        if (!(_emailController.text).contains(emailFormat)) {
                                          scaffoldMessenger.showSnackBar(const SnackBar(
                                              content: Text("Enter a Goowid.com email")));
                                          return;
                                        }

                                        if (_passwordController.text.isEmpty ||
                                            _passwordController.text.length < 6) {
                                          scaffoldMessenger.showSnackBar(const SnackBar(
                                              content:
                                                  Text("Password should be min 6 characters")));
                                          return;
                                        }
                                        signup(_nameController.text, _phoneController.text,
                                            _emailController.text, _passwordController.text);
                                      },
                                      child: const Text("CREATE ACCOUNT",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              letterSpacing: 1)),
                                    ),
                                  ),
                                  Positioned(
                                    child: (isLoading)
                                        ? Center(
                                            child: Container(
                                                height: 26,
                                                width: 26,
                                                child: const CircularProgressIndicator(
                                                  backgroundColor: Colors.green,
                                                )))
                                        : Container(),
                                    right: 30,
                                    bottom: 0,
                                    top: 0,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/signin");
                        },
                        child: const Text("Already have an account?",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                                letterSpacing: 0.5)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  signup(name, phone, email, password) async {
    print("Calling");

    setState(() {
      isLoading = true;
    });
    try {
      Map data = {
        'displayName': name,
        'firstName': name,
        'surname': 'test',
        'givenName': 'test',
        'mailNickname': name,
        'streetAddress': 'test',
        'accountEnabled': true,
        'email': email,
        'mobilePhone': '"' + phone + '"',
        'passwordProfile': {
          "forceChangePasswordNextSignIn": false,
          "password": password,
        }
      };
      print(data.toString());
      HttpClient httpClient = HttpClient();
      Response? res = await httpClient.post(
        REGISTRATION,
        data,
        headers: {
          "Ocp-Apim-Subscription-Key": "7814fdc73dbe4abeb94bcc2d14956272",
          "Content-Type": "application/json"
        },
      );
      setState(() {
        isLoading = false;
      });
      Map<String, dynamic> resposne = res?.data;

      AppLogger.log("This is the result: ======> ${res?.data}");

      if (resposne['displayName'] != null) {
        //return user;
        // User user = resposne['user'];
        //Provider.of<UserProvider>(context, listen: false).setUser(user);
        savePref(
            1,
            resposne['displayName'],
            resposne['givenName'],
            resposne['surname'],
            resposne['userPrincipalName'],
            resposne['mobilePhone'],
            resposne['userPrincipalName'],
            resposne['id']);
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("Welcome ${resposne['displayName']}")));
        Navigator.pushReplacementNamed(context, "/signin");
        setState(() {
          isLoading = false;
        });
      }
    } on Failure catch (e) {
       scaffoldMessenger
            .showSnackBar(SnackBar(content: Text(e.errorMessage)));
      setState(() {
        isLoading = false;
      });
      AppLogger.log("Error:  =====> ${e.errorMessage}");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      AppLogger.log(e.toString());
             scaffoldMessenger
            .showSnackBar(const SnackBar(content: Text("Something went wrong, try again later")));
    }
  }

  savePref(int value, String displayName, String givenName, String surname,
      String userPrincipalName, String mobileNumber, String email, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setInt("value", value);
    preferences.setString("displayName", displayName);
    preferences.setString("givenName", givenName);
    preferences.setString("surname", surname);
    preferences.setString("userPrincipalName", userPrincipalName);
    preferences.setString("mobileNumber", mobileNumber);
    preferences.setString("email", email);
    preferences.setString("id", id.toString());
  }

  // Future<String> getUser() async {
  //   final SharedPreferences preferences = await SharedPreferences.getInstance();

  //   String? name = preferences.getString("displayName");
  //   String? phone = preferences.getString("mobileNumber");

  //   String? email = preferences.getString("email");

  //   return user;
}
