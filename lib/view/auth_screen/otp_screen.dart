import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/controller/services/auth_services/auth_services.dart';
import 'package:amazon/view/auth_screen/auth_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../utils/colors.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({super.key, required this.mobileNumber});
  String mobileNumber;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Image(
          image: const AssetImage('assets/images/amazon_logo.png'),
          height: height * 0.04,
        ),
      ),
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Authentication Required',
                style: textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CommonFunctions.blankSpace(
                height * 0.01,
                0,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.mobileNumber,
                      style: textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' Change',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              CommonFunctions.blankSpace(
                height * 0.02,
                0,
              ),
              Text(
                'We have send a One Time Password (OTP) to the mobile no. above. Please enter it to complete verification.',
                style: textTheme.bodyMedium,
              ),
              CommonFunctions.blankSpace(
                height * 0.02,
                0,
              ),
              TextField(
                controller: otpController,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                  hintStyle: textTheme.bodySmall,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: secondaryColor,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: grey,
                    ),
                  ),
                ),
              ),
              CommonFunctions.blankSpace(
                height * 0.01,
                0,
              ),
              CommonAuthButton(
                title: 'Continue',
                onPressed: () {
                  AuthServices.verifyOTP(
                    context: context,
                    otp: otpController.text.trim(),
                  );
                },
                btnWidth: 0.94,
              ),
              CommonFunctions.blankSpace(
                height * 0.01,
                0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Resend OTP',
                      style: textTheme.bodyMedium!.copyWith(
                        color: blue,
                      ),
                    ),
                  ),
                ],
              ),
              CommonFunctions.blankSpace(
                height * 0.02,
                0,
              ),
              const BottomAuthScreenWidget()
            ],
          ),
        ),
      ),
    );
  }
}
