import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// class state
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Week3());
  }
}
class Week3 extends StatelessWidget {
  const Week3({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey,
              width: 2,
            )
          ),
          child: Column(
            mainAxisAlignment:  MainAxisAlignment.start,
            children: [
              SizedBox(height: 16,),
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage("https://scontent.fbkk17-1.fna.fbcdn.net/v/t39.30808-1/347828510_1226611718040253_1924289041294470499_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=108&ccb=1-7&_nc_sid=e99d92&_nc_ohc=yzJlXBfO3yEQ7kNvwErzys2&_nc_oc=Adnt9sZW65_4eS3nlQVQMIyxI5fenXZp-RTEndxLq6hEEZEk_qMhz51LUxKDx98Pr-o&_nc_zt=24&_nc_ht=scontent.fbkk17-1.fna&_nc_gid=iH9tkmCQn9MktZ09093YQA&oh=00_AfXFbK5ZRLxtcJf3JqR1ymrtz6zUnCcpJ2qn1Zn_OYWpIg&oe=68AF25ED"),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Jakkrit Kiddee (จักรกฤช คิดดี)",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                "660710108",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                ),
              SizedBox(height: 4),
              Text(
                "Computer Science",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text("Believe in Yourself",
                style:TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign:  TextAlign.center,
                ),

              
            ],
            ),
              ),
            ),
          );
        
  }
}
