import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smart_advertising/pages/registeration.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AdvertAIse"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SafeArea(
        child: IntroductionScreen(
          next: Icon(Icons.navigate_next_outlined),
          skip: Text(
            'Skip',
            style: TextStyle(color: Colors.red),
          ),
          onSkip: () => gotoHome(context),
          pages: [
            PageViewModel(
              title: "AdvertAIse",
              body:
                  "A platform for companies to utilize smart advertising techniques to analyze and improve their advertisements based on user inputs",
              image: Center(
                  child: Image.asset(
                'assets/PredictiveAnalysis.png',
                width: 350,
              )),
              decoration: PageDecoration(
                  titleTextStyle: GoogleFonts.montserrat(
                      fontSize: 50, fontWeight: FontWeight.bold),
                  bodyTextStyle: GoogleFonts.montserrat(fontSize: 18)),
            ),
            PageViewModel(
              title: "Our Motto",
              body:
                  "Help them to make their advertisements more engaging thereby ensuring a better and effective reach of their advertisement",
              image: Center(
                  child: Image.asset(
                'assets/Process.png',
                width: 350,
              )),
              decoration: PageDecoration(
                  titleTextStyle: GoogleFonts.montserrat(
                      fontSize: 50, fontWeight: FontWeight.bold),
                  bodyTextStyle: GoogleFonts.montserrat(fontSize: 18)),
            ),
            PageViewModel(
              title: "Lets get Started",
              body: "Sign In to avail the amazing features of this App",
              decoration: PageDecoration(
                  titleTextStyle: GoogleFonts.montserrat(
                      fontSize: 50, fontWeight: FontWeight.bold),
                  bodyTextStyle: GoogleFonts.montserrat(fontSize: 18)),
              image: Center(
                  child: Image.asset(
                'assets/InThought.png',
                width: 350,
              )),
            )
          ],
          done: Text('Next'),
          onDone: () => gotoHome(context),
          dotsDecorator: getDotsDecoration(),
        ),
      ),
    );
  }

  void gotoHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RegisterationScreen()),
      );

  DotsDecorator getDotsDecoration() => DotsDecorator(
        color: Color(0xFFBDBDBD),
        activeColor: Color(0xFFFF5AAC),
        size: Size(10, 10),
        activeSize: Size(15, 15),
      );
}
