import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        foregroundColor: UtilColor.textBase,
        elevation: 0,
      ),
      body: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          'Đăng nhập\nTài khoản của bạn',
                          style: TextStyle(
                              fontSize: 24,
                              color: UtilColor.textBase,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Utils.textField(
                            icon: Icon(Icons.person),
                            hintText: 'Nhập tài khoản',
                            maxLines: 1),
                        SizedBox(
                          height: 10,
                        ),
                        Utils.textFieldPass(
                            icon: Icon(Icons.lock),
                            hintText: 'Nhập mật khẩu',
                            changed: (value) {},
                            obscureText: true),
                      ],
                    ),
                  ),
                ),
              ),
              Utils.buttonBlack(context, 'Đăng nhập'),
            ],
          )),
    );
  }
}
