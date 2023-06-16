import 'package:flutter/material.dart';
import 'package:my_application/notifiers/signIn_notifier.dart';
import 'package:my_application/views/home_page.dart';
import 'package:my_application/views/toaster.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  bool isProtectedPassword = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sign In"), backgroundColor: Colors.black38),
        body: Consumer<SignInNotifier>(builder: (context, provider, listTile) {
          return SingleChildScrollView(
            child: Container(
              height: provider.isRegister ? 600 : 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black38),
              ),
              margin: EdgeInsets.all(30),
              child: Column(
                children: [
                  provider.isRegister ? _getSignUpContainer() : _getSignInContainer(),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(
                      padding: EdgeInsets.only(right: 60, top: 30),
                      child: InkWell(onTap: _onRegister, child: Text(provider.isRegister ? "Sign In Here" : "Register Here")),
                    ),
                    provider.isRegister
                        ? _getSignInButton("Submit", Colors.black, _onSubmit)
                        : _getSignInButton("Sign In", Colors.black, _onSignIn)
                  ])
                ],
              ),
            ),
          );
        }));
  }

  Center _getSignInContainer() {
    emailController.text = "";
    nameController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
    return Center(
      child: Container(
        width: 350,
        child: Card(
          elevation: 0,
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 0.5, top: 25),
                  child: Text("Sign In", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500))),
              Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 13),
                  child: _getSignInFormContent("User Name", "Enter username", Colors.grey, BorderRadius.circular(25),
                      EdgeInsets.only(left: 15, right: 8, bottom: 23, top: 23),
                      readOnly: false, controller: emailController, isDense: true, isEmail: true)),
              _getSignInFormContent(
                "Password",
                "Enter password",
                Colors.grey,
                BorderRadius.circular(25),
                EdgeInsets.only(left: 15, right: 8, bottom: 23, top: 23),
                controller: passwordController,
                readOnly: false,
                isDense: true,
                obscureText: isProtectedPassword,
                suffix: GestureDetector(
                    onTap: () {
                      // onShowPassword();
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          onTap: () {
                            Future.delayed(Duration.zero, () async {
                              // Provider.of<AuthenticationNotifier>(context, listen: false).setIsProtectedPassword(!isProtectedPassword);
                            });
                          },
                          child: isProtectedPassword
                              ? Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                )),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onSubmit() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    if (password != confirmPassword) {
      Toaster.showToast(message: "Passwords doesn't match,please try again");
      Future.delayed(Duration(milliseconds: 1000), () {
        Toaster.showToast(message: "Your details have been submitted, Please sign in to view your data");
        emailController.text = "";
        nameController.text = "";
        passwordController.text = "";
        confirmPasswordController.text = "";
      });
    } else {
      Map<String, dynamic> form = {"name": name, "email": email, "password": password};
      Provider.of<SignInNotifier>(context, listen: false).signUp(form);
      Future.delayed(Duration(milliseconds: 1000), () {
        Toaster.showToast(message: "Your details have been submitted, Please sign in to view your data");
        emailController.text = "";
        nameController.text = "";
        passwordController.text = "";
        confirmPasswordController.text = "";
      });
    }
  }

  _getSignUpContainer() {
    emailController.text = "";
    nameController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
    return Card(
        elevation: 0,
        child: Container(
            width: 350,
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(left: 0.5, top: 25),
                  child: Text("Sign Up", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500))),
              _getSignInFormContent("Name", "Enter Name", Colors.grey, BorderRadius.circular(25),
                  EdgeInsets.only(left: 15, right: 8, bottom: 23, top: 23),
                  readOnly: false, controller: nameController, isDense: true, isEmail: true),
              _getSignInFormContent("Email", "Enter email", Colors.grey, BorderRadius.circular(25),
                  EdgeInsets.only(left: 15, right: 8, bottom: 23, top: 23),
                  readOnly: false, controller: emailController, isDense: true, isEmail: true),
              _getSignInFormContent("Password", "Password", Colors.grey, BorderRadius.circular(25),
                  EdgeInsets.only(left: 15, right: 8, bottom: 23, top: 23),
                  readOnly: false, controller: passwordController, isDense: true, isEmail: true),
              _getSignInFormContent("ConfirmPassword", "Password", Colors.grey, BorderRadius.circular(25),
                  EdgeInsets.only(left: 15, right: 8, bottom: 23, top: 23),
                  readOnly: false, controller: confirmPasswordController, isDense: true, isEmail: true)
            ])));
  }

  _onRegister() {
    emailController.text = "";
    nameController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
    Provider.of<SignInNotifier>(context, listen: false).setIsRegister();
  }

  _onSignIn() async {
    final List<dynamic> maps = await Provider.of<SignInNotifier>(context, listen: false).getUsers();
    bool isValid = true;
    if (maps != null) {
      if (emailController.text.trim() != maps[0]["email"]) {
        isValid = false;
        Toaster.showToast(message: "Please check your email");
        return;
      }
      if (passwordController.text.trim() != maps[0]["password"]) {
        Toaster.showToast(message: "Please check your password and try again");
        isValid = false;
        return;
      }
    }
    if (isValid) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: maps[0])));
    }
  }

  _getSignInFormContent(String fieldName, String example, Color borderColor, borderRadius, textFieldPadding,
      {prefix, keyboardType, controller, enabled, readOnly, required bool isDense, suffix, obscureText, isEmail = false, lines}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: EdgeInsets.only(left: 5, top: 13, bottom: 15), child: Text(fieldName, style: TextStyle(fontSize: 15))),
        TextFormField(
            maxLines: lines != null ? 1 : lines,
            autofillHints: isEmail ? [AutofillHints.email] : [AutofillHints.password],
            enabled: enabled,
            readOnly: readOnly,
            controller: controller,
            keyboardType: keyboardType,
            cursorColor: Colors.black,
            obscureText: obscureText ?? false,
            decoration: InputDecoration(
              isDense: isDense,
              prefixIcon: prefix,
              suffixIcon: suffix,
              contentPadding: textFieldPadding,
              hintText: example,
              hintStyle: TextStyle(fontSize: 15),
              enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(width: 0, color: borderColor)),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(width: 0, color: borderColor),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(width: 0, color: borderColor),
              ),
            ))
      ]),
    );
  }

  Container _getSignInButton(text, buttonColor, onTap) {
    return Container(
        margin: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: buttonColor,
        ),
        width: 100,
        height: 35,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: buttonColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25), side: BorderSide(color: Colors.black))),
          onPressed: onTap,
          child: Text(
            text,
            style: TextStyle(color: buttonColor == Colors.black ? Colors.white : Colors.black),
          ),
        ));
  }
}
