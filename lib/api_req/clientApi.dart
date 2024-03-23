import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/utility/utility.dart';
import '../style/styles.dart';


var BaseURL="https://task.teamrabbil.com/api/v1";
var RequestHeader={"Content-Type":"application/json"};

Future<bool> VerifyEmailRequest(Email) async{
  var URL=Uri.parse("${BaseURL}/RecoverVerifyEmail/${Email}");
  var response= await http.get(URL,headers:RequestHeader);
  var ResultCode=response.statusCode;
  var ResultBody=json.decode(response.body);
  if(ResultCode==200 && ResultBody['status']=="success"){
    await WriteEmailVerification(Email);
    SuccessToast("Verify Email Success!");
    return true;
  }
  else{
    ErrorToast("Verify Email failed! Try again");
    return false;
  }
}

Future<bool> VerifyOTPRequest(Email,OTP) async{
  var URL=Uri.parse("${BaseURL}/RecoverVerifyOTP/${Email}/${OTP}");
  var response= await  http.get(URL,headers:RequestHeader);
  var ResultCode=response.statusCode;
  var ResultBody=json.decode(response.body);
  if(ResultCode==200 && ResultBody['status']=="success"){
    await WriteOTPVerification(OTP);
    SuccessToast("OTP Verify Success!");
    return true;
  }
  else{
    ErrorToast("OTP Verify failed! Try again");
    return false;
  }
}
Future<bool> SetPasswordRequest(FormValues) async{
  var URL=Uri.parse("${BaseURL}/RecoverResetPass");
  var PostBody=json.encode(FormValues);
  var response= await  http.post(URL,headers:RequestHeader,body: PostBody);
  var ResultCode=response.statusCode;
  var ResultBody=json.decode(response.body);
  if(ResultCode==200 && ResultBody['status']=="success"){
    SuccessToast("Password has been successfully changed! Please Log in");
    return true;
  }
  else{
    ErrorToast("Password change failed! Try again");
    return false;
  }
}


