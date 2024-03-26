import 'package:chat_app/Navigation/Navigation.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splash extends StatelessWidget {
  Splash({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors
            .transparent, // Đặt màu nền của thanh trạng thái thành trong suốt
      ),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Image.asset(
                      'assets/images/3714960.jpg',
                      height: 200,
                      width: size.width,
                    ),
                    Text(
                      'Chào mừng bạn đến với',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: UtilColor.textBase),
                    ),
                    Text(
                      'Work Chat',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: UtilColor.textBase),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigation.navigateTo(page: 'LoginScreen');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: UtilColor.buttonBlack,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50))),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        width: size.width,
                        child: const Center(
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: UtilColor.buttonGrey,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50))),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      width: size.width,
                      child: Center(
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: UtilColor.textGrey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Liên lạc trao đổi nội bộ an toàn bảo mật',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: UtilColor.textGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
