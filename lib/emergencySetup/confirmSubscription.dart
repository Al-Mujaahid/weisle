import 'package:flutter/material.dart';
import 'package:weisle/helpers/Alerts.dart';
import 'package:weisle/ui/constants/colors.dart';
import 'package:weisle/ui/screens/dashboard/landing_screen.dart';
import 'package:weisle/ui/widgets/navigtion.dart';
import 'package:weisle/utils/base_provider.dart';
import 'package:weisle/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:weisle/ui/widgets/custom_fields.dart';
import 'package:weisle/ui/widgets/form_button.dart';
import 'package:weisle/ui/widgets/margin.dart';

class ConfirmSubscriptionPage extends StatefulWidget {
  const ConfirmSubscriptionPage({Key? key}) : super(key: key);

  @override
  _ConfirmSubscriptionPageState createState() =>
      _ConfirmSubscriptionPageState();
}

class _ConfirmSubscriptionPageState extends State<ConfirmSubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Consumer<ConfirmSubscriptionServiceProvider>(
            builder: (context, value, child) {
          return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
              children: [
                SizedBox(
                    height: 163,
                    width: 129,
                    child: Image.asset("assets/images/signIn.png")),
                PlainTextField(
                    onchanged: (String e) => value.setaccountId = e,
                    leading: const Icon(Icons.remember_me_rounded,
                        color: Color(0xffFF2156)),
                    hint: "Account ID"),
                PlainTextField(
                    onchanged: (String e) => value.setpaymentStatus = e,
                    leading: const Icon(Icons.phone_android_rounded,
                        color: Color(0xffFF2156)),
                    hint: "Paymet status"),
                PlainTextField(
                    onchanged: (e) => value.setsubId = e,
                    leading: const Icon(Icons.payment_rounded,
                        color: Color(0xffFF2156)),
                    hint: "Subscription ID"),
                PlainTextField(
                    onchanged: (e) => value.settxtRef = e,
                    leading: const Icon(Icons.text_fields_rounded,
                        color: Color(0xffFF2156)),
                    hint: "Text ref"),
                const YMargin(20),
                FormButton(
                    enabled: true,
                    text: "Complete confirmation",
                    function: () {
                      value.notoficationService(context);
                    }),
                const YMargin(40),
              ]);
        }),
      ),
    );
  }
}

class ConfirmSubscriptionServiceProvider extends BaseProvider {
  String? _accountId;
  String? _subId;
  String? _txtRef;
  String? _paymentStatus;
  bool formValidity = false;

  String get accountId => _accountId ?? "";
  String get subId => _subId ?? '';
  String get txtRef => _txtRef ?? '';
  String get paymentStatus => _paymentStatus ?? "";

  set setaccountId(String accountId) {
    _accountId = accountId;
    checkFormValidity();
    notifyListeners();
  }

  set setsubId(String subId) {
    _subId = subId;
    checkFormValidity();
    notifyListeners();
  }

  set settxtRef(String txtRef) {
    _txtRef = txtRef;
    checkFormValidity();
    notifyListeners();
  }

  set setpaymentStatus(String paymentStatus) {
    _paymentStatus = paymentStatus;
    checkFormValidity();
    notifyListeners();
  }

  void checkFormValidity() {
    if ((_accountId != null) &&
        (_subId != null) &&
        (_txtRef != null) &&
        (_paymentStatus != null)) {
      formValidity = true;
    } else {
      formValidity = false;
    }
    notifyListeners();
  }

  void notoficationService(BuildContext context) async {
    try {
      if (_accountId == null ||
          _subId == null ||
          _txtRef == null ||
          _paymentStatus == null) {
        Alerts.errorAlert(context, 'Al fields are required', () {
          Navigator.pop(context);
        });
      } else if (_subId!.length < 1) {
        Alerts.errorAlert(context, 'Emergency Setup Id lengt too short', () {
          Navigator.pop(context);
        });
      } else {
        Alerts.loadingAlert(context, 'Processing confirmation...');
        FocusScope.of(context).unfocus();
        setLoading = true;
        var notoficationServiceResponse =
            await emergencyApiBasics.confirmSubscription(
                accountId: _accountId,
                subId: _subId,
                txtRef: _txtRef,
                paymentStatus: _paymentStatus);
        print(
            "Weisle ConfirmSubscription service response is $notoficationServiceResponse");
        if (notoficationServiceResponse['resposeCode'] == '00') {
          setLoading = false;
          print('Request Successful');
          navigate(context, LandingScreen());
        } else if (notoficationServiceResponse['resposeCode'] == '06') {
          Alerts.errorAlert(context, 'Improper format', () {
            Navigator.pop(context);
          });
        } else {
          print(
              "Weisle ConfirmSubscription Response is $notoficationServiceResponse");
        }
      }
    } catch (e) {
      print("Weisle error: $e");
      Alerts.errorAlert(context, 'Something went Wrong', () {
        Navigator.pop(context);
      });
    }
  }

  ConfirmSubscriptionServiceProvider() {
    checkFormValidity();
  }
}
