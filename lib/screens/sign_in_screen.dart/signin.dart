import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late String email, password;
  late String? title;
  bool isLoading = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late ScaffoldMessengerState scaffoldMessenger;
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
                        height: 5,
                      ),
                      Container(
                        width: 180,
                        child: const Text(
                          "Goowid Authenticator",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black54,
                              letterSpacing: 0.6,
                              fontFamily: 'Poppins',
                              fontSize: 11),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Sign In",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 1,
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'),
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
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 45),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                                controller: _emailController,
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black12)),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: Colors.black54, fontSize: 15),
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
                                enableSuggestions: false,
                                autocorrect: false,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black12)),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Colors.black54, fontSize: 15),
                                ),
                                onSaved: (val) {
                                  password = val!;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (isLoading) {
                                        return;
                                      }
                                      if (_emailController.text.isEmpty ||
                                          _passwordController.text.isEmpty) {
                                        scaffoldMessenger.showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Please fill all fields")));
                                        return;
                                      }
                                      login(_emailController.text,
                                          _passwordController.text);
                                      setState(() {
                                        isLoading = true;
                                      });
                                      //Navigator.pushReplacementNamed(
                                      //context, "/entrypoint");
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 0),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF77D8E),
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Text(
                                        "SUBMIT",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            letterSpacing: 1),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: (isLoading)
                                        ? Center(
                                            child: Container(
                                                height: 26,
                                                width: 26,
                                                child:
                                                    const CircularProgressIndicator(
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
                      const Text(
                        "OR",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/register");
                        },
                        child: const Text(
                          "Don't have an account?",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                              letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  login(email, password) async {
    Map data = {'userName': email, 'password': password};
    print(data.toString());
    final response = await http.post(
      Uri.parse(LOGIN),
      headers: {
        "Ocp-Apim-Subscription-Key": "7814fdc73dbe4abeb94bcc2d14956272",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data),
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne['displayName'] != null) {
        savePref(
            1,
            resposne['displayName'],
            resposne['givenName'],
            resposne['surname'],
            resposne['userPrincipalName'],
            resposne['mobilePhone'],
            resposne['userPrincipalName'],
            resposne['id']);
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text("Welcome ${resposne['displayName']}")));

        Navigator.pushReplacementNamed(context, "/entrypoint");
      }
    } else {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text("Your email or password are incorrect")));
    }
  }

  savePref(
      int value,
      String displayName,
      String givenName,
      String surname,
      String userPrincipalName,
      String mobileNumber,
      String email,
      String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setInt("value", value);
    preferences.setString("displayName", json.encode(displayName));
    preferences.setString("givenName", json.encode(givenName));
    preferences.setString("surname", json.encode(surname));
    preferences.setString("userPrincipalName", json.encode(userPrincipalName));
    preferences.setString("mobileNumber", json.encode(mobileNumber));
    preferences.setString("email", json.encode(email));
    preferences.setString("id", id.toString());
  }
}

class SharedPref {
  static write(String key, value) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setString(key, json.encode(value));
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
