import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:weisle/customer/welcome_back.dart';
import 'package:weisle/helpers/Alerts.dart';
import 'package:weisle/ui/constants/asset_images.dart';
import 'package:weisle/ui/widgets/basic_widgets.dart';
import 'package:weisle/ui/widgets/custom_fields.dart';
import 'package:weisle/ui/widgets/form_button.dart';
import 'package:weisle/ui/widgets/margin.dart';
import 'package:weisle/ui/widgets/navigtion.dart';
import 'package:weisle/utils/base_provider.dart';
import 'package:weisle/utils/index.dart';
import 'package:weisle/ui/constants/colors.dart';
import '../ui/constants/colors.dart';

class ResetPasword extends StatefulWidget {
  const ResetPasword({Key? key}) : super(key: key);

  @override
  _ResetPaswordState createState() => _ResetPaswordState();
}

class _ResetPaswordState extends State<ResetPasword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            const YMargin(10),
            SideSpace(
              10,
              10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextOf('Reset password', 22, FontWeight.w600, black),
                  TextOfDecoration(
                      'Set a new password if you think your current password has been compromised',
                      17,
                      FontWeight.w400,
                      black,
                      TextAlign.left),
                ],
              ),
            ),
            const YMargin(20),
            Expanded(
              child: Consumer<ResetPasswordProvider>(
                  builder: (context, value, child) {
                return ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 36),
                    children: [
                      PasswordField(
                          onchanged: (String e) {
                            value.setuserPass = e;
                          },
                          leading: const Icon(Icons.person_add_alt_1,
                              color: Color(0xffFF2156)),
                          hint: "Pawword"),
                      PasswordField(
                          onchanged: (String e) {
                            value.setconfirmPass = e;
                          },
                          leading: const Icon(Icons.person_add_alt_1,
                              color: Color(0xffFF2156)),
                          hint: "Confirm pawword"),
                      const YMargin(20),
                      const YMargin(20),
                      FormButton(
                          enabled: true,
                          text: "Reset password",
                          function: () {
                            value.resetPass(context);
                          }),
                      const YMargin(40),
                    ]);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeisleHeader(
        Image.asset(
          weisle_logo,
          height: 30,
        ),
        Image.asset(
          headericons,
          height: 30,
        ),
        Card(
            elevation: 7,
            //shape: RoundedRectangleShapeBorder(),
            child: Stack(children: [
              Image.asset(
                alarm,
                height: 40,
              ),
              const Positioned(
                  bottom: 20,
                  left: 20,
                  child: CircleAvatar(radius: 2, backgroundColor: Colors.pink))
            ])));
  }
}
//------------------------------------------------------------RESET PASWORD PROVIDER
class ResetPasswordProvider extends BaseProvider {
  String? _userPass;
  String? _secAnswer;
  String? _userName;
  String? _confirmPass;
  bool formValidity = false;

  String get userPass => _userPass ?? '';
  String get secAnswer => _secAnswer ?? '';
  String get userName => _userName ?? '';
  String get confirmPass => _confirmPass ?? '';

  set setuserPass(String userPass) {
    _userPass = userPass;
    checkFormValidity();
    notifyListeners();
  }

  set setsecAnswer(String secAnswer) {
    _secAnswer = secAnswer;
    checkFormValidity();
    notifyListeners();
  }

  set setuserName(String userName) {
    _userName = userName;
    checkFormValidity();
    notifyListeners();
  }

  set setconfirmPass(String confirmPass) {
    _confirmPass = confirmPass;
    checkFormValidity();
    notifyListeners();
  }

  void checkFormValidity() {
    if ((_userPass != null) && (_confirmPass != null)) {
      formValidity = true;
    } else {
      formValidity = false;
    }
    notifyListeners();
  }

  void resetPass(BuildContext context) async {
    try {
      var box = await Hive.openBox(weisleUserBox);
      setuserName = box.get(weisleUserName) ?? box.get(rweisleUserName);
      setsecAnswer = box.get(weisleSecurityAnswer);
      if (_userPass == null || _confirmPass == null) {
        Alerts.errorAlert(context, 'All fields are required', () {
          Navigator.pop(context);
        });
      } else if (userPass != confirmPass) {
        Alerts.errorAlert(context, 'Password mismatch', () {
          goBack(context);
        });
      } else {
        Alerts.loadingAlert(context, 'Resetting pass...');
        FocusScope.of(context).unfocus();
        setLoading = true;
        var registerResponse = await customerApiBasic.resetPass(
            userName: userName, userPass: _userPass, secAnswer: secAnswer);
        if (registerResponse['resposeCode'] == '00') {
          setLoading = false;
          print('Request Successful');
          goBack(context);
          Alerts.successAlert(
              context, registerResponse['data']['responseMessage'], () {
            navigatedForever(context, const WelcomeBack());
          });
        } else {
          setLoading = false;
          goBack(context);
          Alerts.errorAlert(context, 'Password reset successful', () {
            Navigator.pop(context);
          });
        }
      }
    } catch (e) {
      setLoading = false;
      goBack(context);
      Alerts.errorAlert(context, 'Go and set a security Q&A first', () {
        goBack(context);
      });
    }
  }

  ResetPasswordProvider() {
    checkFormValidity();
  }
}
