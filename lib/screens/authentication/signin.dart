import 'dart:convert';
import 'dart:developer';

import 'package:aims_mobile/screens/pages/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:msal_mobile/msal_mobile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  // const SignIn({Key key}) : super(key: key);
  SignIn({Key key}) : super(key: key);

  MsalMobile get getMsal => msal;
  @override
  _SignInState createState() => _SignInState();
}
MsalMobile msal;

class _SignInState extends State<SignIn> {
  //google sign in
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();
  // String postUrl =  "http://10.0.2.2:8080/api/v1/users";
  // String postUrl =  "http://10.0.2.2:8080/api/v1/users";
  String postUrl = "http://10.0.2.2:8080/api/v1/users";

  Future<FirebaseUser> _signIn(BuildContext context) async {
    debugPrint("_signIn(BuildContext) called");
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Sign in'),
    ));

    final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential));
    ProviderDetails providerInfo = new ProviderDetails(user.providerId);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("username", user.displayName);
    debugPrint("_signIn user details: $user");

    List<ProviderDetails> providerData = new List<ProviderDetails>();
    providerData.add(providerInfo);

    UserDetails details = new UserDetails(
      user.providerId,
      user.displayName,
      user.photoUrl,
      user.email,
      providerData,
    );
    final http.Response response = await http.post(
      postUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username':user.email,
        'displayName': user.email,
        'email': user.displayName,
        'identityProvider':"Google"
      }),
    );
    print(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var parse = jsonDecode(response.body);
    await prefs.setString('username', parse["username"]);
    // await prefs.setStringList('roles', parse['roles'].cast<String>());
    await prefs.setString('roles', parse['roles'][0]['name']);
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new NavScreen(detailsUser: details),
      ),
    );
    return user;
  }

  //microsoft login
  ProgressDialog progressDialog;
  static const String SCOPE =
      'api://8b504844-37db-4b52-bfb0-963b66fcf1b2/user_impersonation';
  static const String TENANT_ID = 'organizations';
  static String authority = "https://login.microsoftonline.com/$TENANT_ID";

  // MsalMobile msal;
  bool isSignedIn = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    MsalMobile.create('assets/auth_config.json', authority).then((client) {
      setState(() {
        msal = client;
      });
      refreshSignedInStatus();
    });
  }

  /// Updates the signed in state

  refreshSignedInStatus() async {
    debugPrint("refreshSignedInStatus() called");
    bool loggedIn = await msal.getSignedIn();
    if (loggedIn) {
      isSignedIn = loggedIn;
      if (isSignedIn) {
        dynamic data = await handleGetAccount();
        dynamic token = await handleGetTokenSilently();
        dynamic result = token;
        SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        String username = sharedPreferences.get("username");
        sharedPreferences.get("token");
        log('access token (truncated): ${result.accessToken}');

        await http.post(
          postUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'username':username,
            'email': username,
            'displayName': username,
            'identityProvider':"Microsoft"
          }),
        ).then((response) async {
          debugPrint("finished posting user");
          print(response.body);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var parse = jsonDecode(response.body);
          // await prefs.setStringList('roles', parse['roles']);
          // await prefs.setString('roles', parse['roles'][0]['name']);
          // await prefs.setString('roles', "ROLE_ADMIN");
          await prefs.setString("username", username);

          Navigator.pushReplacementNamed(context, 'nav');
        }).catchError((error) {
          debugPrint("ERROR POSTING USER");
          debugPrint("$error");

          progressDialog.hide();
        });
      }
      // Remaining code for navigation
    }

  }

  /// Gets a token silently.
  Future<dynamic> handleGetTokenSilently() async {
    debugPrint("handleGetTokenSilently() called");
    String authority = "https://login.microsoftonline.com/$TENANT_ID";
    final result = await msal.acquireTokenSilent([SCOPE], authority);
    if (result != null) {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sharedPreferences.setString("token", result.accessToken);
      print(result);
      return result;
    } else {
      print('no access token');
      return null;
    }
  }

  /// Signs a user in
  handleSignIn() async {
    debugPrint("handleSignIn() called");
    await msal.signIn(null, [SCOPE]).then((result) {
      // ignore: unnecessary_statements
      refreshSignedInStatus();
    }).catchError((exception) {
      if (exception is MsalMobileException) {
        logMsalMobileError(exception);
      } else {
        final ex = exception as Exception;
        print('exception occurred');
        print(ex.toString());
      }
    });
  }

  logMsalMobileError(MsalMobileException exception) {
    print('${exception.errorCode}: ${exception.message}');
    if (exception.innerException != null) {
      print(
          'inner exception = ${exception.innerException.errorCode}: ${exception.innerException.message}');
    }
  }

  /// Signs a user out.
  handleSignOut() async {
    try {
      print('signing out');
      await msal.signOut();
      print('signout done');
      refreshSignedInStatus();
    } on MsalMobileException catch (exception) {
      logMsalMobileError(exception);
    }
  }

  /// Gets the current and prior accounts.
  Future<dynamic> handleGetAccount() async {
    debugPrint("handleGetAccount() called");
    // <-- Replace dynamic with type of currentAccount
    final result = await msal.getAccount();
    if (result.currentAccount != null) {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sharedPreferences.setString("username", result.currentAccount.username);
      debugPrint("handleGetAccount result");
      debugPrint("${result.currentAccount}");
      debugPrint(result.currentAccount.username);
      return result.currentAccount;
    } else {
      print('no account found');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog  = ProgressDialog(context, type:ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(message: "Signing In ...");
    return MaterialApp(
        home: new Scaffold(
          body: Builder(
            builder: (context) => Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset('assets/landing.webp',
                      fit: BoxFit.fill,
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      colorBlendMode: BlendMode.modulate),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Container(
                      width: 230.0,
                      child: Visibility(
                        visible: !isSignedIn,
                        child: Align(
                            alignment: Alignment.center,
                            child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(30.0)),
                                    color: Color(0xffffffff),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.microsoft,
                                          color: Color(0xFF01A6F0),
                                        ),
                                        // Visibility(
                                        //   visible: !isSignedIn,
                                        SizedBox(width: 10.0),
                                        Text(
                                          'Sign in UMB Email',
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 18.0),
                                        ),
                                        // child: RaisedButton(
                                        //   child: Text("Sign In"),
                                        //   onPressed: handleSignIn,
                                        // ),
                                        // ),
                                      ],
                                    ),
                                    onPressed: () => {
                                      //showLoaderDialog(context),
                                      progressDialog.hide(),
                                      progressDialog.show(),
                                      handleSignIn(),
                                      progressDialog.hide()
                                    }
                                ),
                        ),
                      ),
                    ),
                    Container(
                      width: 230.0,
                      child: Visibility(
                        visible: !isSignedIn,
                        child: Align(
                            alignment: Alignment.center,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)),
                                color: Color(0xffffffff),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.google,
                                      color: Color(0xFF01A6F0),
                                    ),
                                    // Visibility(
                                    //   visible: !isSignedIn,
                                    SizedBox(width: 10.0),
                                    SizedBox(width: 10.0),
                                    Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18.0),
                                    ),
                                    // child: RaisedButton(
                                    //   child: Text("Sign In"),
                                    //   onPressed: handleSignIn,
                                    // ),
                                    // ),
                                  ],
                                ),
                              onPressed: () => _signIn(context)
                                  .then((FirebaseUser user) => print(user))
                                  .catchError((e) => print(e)),)
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class UserDetails {
  final String providerDetails;
  final String username;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails,this.username, this.photoUrl,this.userEmail, this.providerData);
}


class ProviderDetails {
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}
