import "package:weisle/service/api_basics.dart";
import "package:weisle/utils/endpoints.dart";

class CustomerApiBasi {
  ApiBasics? _apiBasics;
  static final customerApiBasi = CustomerApiBasi.createInstance();
  CustomerApiBasi.createInstance();
  factory CustomerApiBasi(ApiBasics apiBasics) {
    customerApiBasi._apiBasics = apiBasics;
    return customerApiBasi;
  }

  //------------------------------------------REGISTER ENDOINT CALLING
  Future register(
      {String? fullName,
      String? phoneNo,
      String? userName,
      String? userPass,
      String? regCode}) {
    Map<String, dynamic> data = {
      "fullName": fullName,
      "phoneNo": phoneNo,
      "userName": userName,
      "userPass": userPass,
      "regCode": regCode
    };
    return _apiBasics!.makePostRequest(registerurl, null, data);
  }

  //-------------------------------------------SIGN IN
  Future signIn({username, password}) {
    Map<String, dynamic> data = {
      "username": username,
      "password": password,
    };
    return _apiBasics!.makePostRequest(signInurl, null, data);
  }

  //-------------------------------------------SET SQA
  //-------------------------------------------SET SQA
  //-------------------------------------------SET SQA
  //-------------------------------------------SET SQA
  Future setSqa({userName, secQuestion, secAnswer}) {
    Map<String, dynamic> data = {
      "userName": userName,
      "secQuestion": secQuestion,
      "secAnswer": secAnswer,
    };
    return _apiBasics!.makePostRequest(setSqaurl, null, data);
  }

  //-------------------------------------------ACCOUNT LOOKUP
  //-------------------------------------------ACCOUNT LOOKUP
  //-------------------------------------------ACCOUNT LOOKUP
  Future acctLookup({accountId, phoneNo}) {
    Map<String, dynamic> data = {
      "accountId": accountId,
      "phoneNo": phoneNo,
    };
    return _apiBasics!.makePostRequest(acctLookupurl, null, data);
  }

  //-------------------------------------------RESET PASSWORD
  //-------------------------------------------RESET PASSWORD
  //-------------------------------------------RESET PASSWORD
  Future resetPass({userName, secAnswer, userPass}) {
    Map<String, dynamic> data = {
      "userName": userName,
      "secAnswer": secAnswer,
      "userPass": userPass,
    };
    return _apiBasics!.makePostRequest(resetPassurl, null, data);
  }

  //-------------------------------------------EDIT PROFILE
  //-------------------------------------------EDIT PROFILE
  //-------------------------------------------EDIT PROFILE
  Future editProfile({userName, fullName, phoneNo}) {
    Map<String, dynamic> data = {
      "userName": userName,
      "fullName": fullName,
      "phoneNo": phoneNo,
    };
    return _apiBasics!.makePostRequest(editProfileurl, null, data);
  }

  //-------------------------------------------NOTIFICATION SERVICE
  //-------------------------------------------NOTIFICATION SERVICE
  //-------------------------------------------NOTIFICATION SERVICE
  Future notificationService({
    accountId,
    emergencySetupId,
    emergencyState,
    emergencyCity,
    longitude,
    latitude,
    fullAddress,
    emergencyCountry,
  }) {
    Map<String, dynamic> data = {
      "accountId": accountId,
      "emergencySetupId": emergencySetupId,
      "emergencyState": emergencyState,
      "emergencyCity": emergencyCity,
      "longitude": longitude,
      "latitude": latitude,
      "fullAddress": fullAddress,
      "emergencyCountry": emergencyCountry,
    };
    return _apiBasics!.makePostRequest(notificationServiceurl, null, data);
  }

  //-------------------------------------------GET NOTIFICATION
  //-------------------------------------------GET NOTIFICATION
  //-------------------------------------------GET NOTIFICATION
  Future getNotification({userName}) {
    return _apiBasics!.makeGetRequest(getNotificationurl + userName, null);
  }
}
