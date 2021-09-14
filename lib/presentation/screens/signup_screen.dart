import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:procrew_task/business_logic/auth/auth_cubit.dart';
import 'package:procrew_task/constants/my_colors.dart';
import 'package:procrew_task/constants/strings.dart';
import 'package:procrew_task/presentation/widgets/custom_elevated_button.dart';
import 'package:procrew_task/presentation/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = true;

  Widget _buildIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "ProCrew App!",
            style: TextStyle(
                fontSize: 20,
                color: MyColors.myNavyBlue,
                fontWeight: FontWeight.bold),
          ),
        ),
        Image.asset(
          'assets/images/login.png',
          fit: BoxFit.cover,
        ),
        Text(
          "Register",
          style: TextStyle(
              fontSize: 32,
              color: MyColors.myNavyBlue,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEmailTextField() {
    return Container(
      width: double.infinity,
      child: CustomTextField(
        hintText: 'Email',
        keyboardType: TextInputType.emailAddress,
        hidePassword: false,
        suffixIcon: Icon(
          Icons.email_outlined,
          color: MyColors.myGrey,
          size: 20,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your email!';
          }
          return null;
        },
        controller: _emailController,
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      width: double.infinity,
      child: CustomTextField(
        hintText: 'Password',
        keyboardType: TextInputType.text,
        hidePassword: _passwordVisible,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          color: MyColors.myGrey,
          icon: Icon(
            _passwordVisible ? Icons.visibility_off : Icons.visibility,
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your password!';
          }
          return null;
        },
        controller: _passwordController,
      ),
    );
  }

  Widget _buildRegisterButton() {
    return CustomElevatedButton(
        width: double.infinity,
        height: 60,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(MyColors.myBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          "Register",
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          // showProgressIndicator(context);
          _register(context);
        });
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomElevatedButton(
          width: 80,
          height: 50,
          child: FaIcon(
            FontAwesomeIcons.facebook,
            color: MyColors.myBlue,
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          onPressed: () {},
        ),
        CustomElevatedButton(
          width: 80,
          height: 50,
          child: FaIcon(
            FontAwesomeIcons.google,
            color: Colors.black,
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          onPressed: () {},
        ),
        CustomElevatedButton(
          width: 80,
          height: 50,
          child: FaIcon(
            FontAwesomeIcons.twitter,
            color: Colors.cyan,
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );

    showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthCubit>(context).registerWithEmailAndPassword(
          _emailController.text, _passwordController.text);
    }
  }

  Widget _buildRegisterButtonBloc() {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is AuthLoading) {
          showProgressIndicator(context);
        }

        if (state is Authenticated) {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(loginScreen);
        }

        if (state is ErrorOccurred) {
          Navigator.pop(context);
          String errorMsg = (state).errorMsg;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.black,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 88),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntro(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildEmailTextField(),
                  SizedBox(
                    height: 30,
                  ),
                  _buildPasswordTextField(),
                  SizedBox(
                    height: 30,
                  ),
                  _buildRegisterButton(),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Or, register with...",
                      style: TextStyle(
                        color: MyColors.myGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildSocialButtons(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: MyColors.myGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: MyColors.myBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(loginScreen);
                        },
                      ),
                    ],
                  ),
                  _buildRegisterButtonBloc(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
