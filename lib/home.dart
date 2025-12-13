import 'package:flutter/material.dart';


class AppColors {
  // gradient
  static const bg1 = Color(0xFF2A84F2);
  static const bg2 = Color(0xFF9C27B0);
  static const bg3 = Color(0xFFEF423C);

  // button options
  static const indigo     = Color(0xFF4338CA); // primary (recommended)
  static const indigoHover= Color(0xFF3730A3);
  static const nearBlack  = Color(0xFF0B1220); // alt dark pill
}
class HomeWidget extends StatelessWidget{
  const HomeWidget({super.key});
@override 
  Widget build(context){
    return Center(child: 
    Column(
      mainAxisAlignment:MainAxisAlignment.center,
      mainAxisSize:MainAxisSize.min,
      children: [
        Image.asset(
          'assets/healthcare.png',
          width: 100,
          color: const Color.fromARGB(149, 255, 255, 255),
        ),
        const SizedBox(height: 30),
        Text("Take Control of PCOS", 
        style: TextStyle(color: Colors.white,fontSize: 25
        ),
        ),
        const SizedBox(height:15),
        Text(
     "Empowering Early PCOS\ndetection",
      textAlign: TextAlign.center,
      style: const TextStyle(
       color: Colors.white70,
       fontSize: 15,
        ),
      ),
      const SizedBox(height:10),
        OutlinedButton.icon(onPressed: (){Navigator.pushNamed(context,
        '/landing_page');}, label: Text("Get Started", 
        style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        icon: Icon(Icons.play_arrow,color: Colors.white,),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.indigo,
          foregroundColor: Colors.white) 
          ),
        const SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: (){}, child: Text("Terms of Service",style: TextStyle(color: Colors.white70),)),
            TextButton(onPressed: (){}, child: Text("\tPrivacy Policy",style: TextStyle(color: Colors.white70),))
          ],
        )
        
      ],
      )
      );
  }
}