import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AdvertAIse"),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "About Us",
                style: GoogleFonts.montserrat(fontSize: 50),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  // color: Colors.orange,
                  child: Text(
                    "The AdvertAIse mobile application will act as a platform for the companies to utilise smart advertising techniques to analyse and improve their advertisements based on user inputs. The generalised data will help them to get a clear idea of places where work is needed. This will help them to make their advertisements more engaging thereby ensuring a better and effective reach of their advertisement. The focus is on providing overall suggestions as in features liked by most of the users and places where improvement is required.",
                    style: GoogleFonts.montserrat(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
