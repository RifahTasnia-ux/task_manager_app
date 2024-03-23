import 'package:flutter/material.dart';
import 'package:task_manager_app/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager_app/presentation/widgets/background_widget.dart';

import '../../../api_req/clientApi.dart';
import '../../../data/utility/utility.dart';
import '../../../style/styles.dart';
import '../../widgets/circular_progress_widget.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String,String> FormValues={"email":"", "OTP":"","password":"","cpassword":""};
  bool Loading=false;

  @override
  initState() {
    callStoreData();
    super.initState();
  }

  callStoreData() async {
    String? OTP= await ReadUserData("OTPVerification");
    String? Email= await ReadUserData("EmailVerification");
    InputOnChange("email", Email);
    InputOnChange("OTP", OTP);
  }

  InputOnChange(MapKey, Textvalue){
    setState(() {
      FormValues.update(MapKey, (value) => Textvalue);
    });
  }

  FormOnSubmit() async{
    if(FormValues['password']!=FormValues['cpassword']){
      ErrorToast('Password and confirmed password should be same!');
    }
    else{
      setState(() {Loading=true;});
      bool res=await SetPasswordRequest(FormValues);
      if(res==true){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const SignInScreen()),
                (route) => false);

      }
      else{
        setState(() {Loading=false;});
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    'Set New Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'Minimum 7 characters with letters and numbers combination',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    obscureText: true,
                    onChanged: (Textvalue){
                      InputOnChange("password",Textvalue);
                    },
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your password';
                      }
                      if (value!.length <= 6) {
                        return 'Password should more than 6 letters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    obscureText: true,
                    onChanged: (Textvalue){
                      InputOnChange("cpassword",Textvalue);
                    },
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your confirmed password';
                      }
                      if (value!.length <= 6) {
                        return 'Confirmed password should more than 6 letters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    child: Visibility(
                      visible: Loading == false,
                      replacement: const CircularProgressWidget(),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FormOnSubmit();
                          }
                        },
                      child: const Text('Confirm'),
                    ),
                   ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}