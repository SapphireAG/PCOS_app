import 'package:flutter/material.dart';
import 'package:pcos_app/symptoms_discrete.dart';

class Symptom{
  final String name;
  bool value;
  Symptom(this.name, {this.value=false});

}


class YesNoToggle extends StatelessWidget {
  final bool value;              // true = YES, false = NO
  final ValueChanged<bool> onChanged;

  const YesNoToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value), // toggle on tap
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          color: value ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("YES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("NO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class SymptomInputPage extends StatefulWidget{
  const SymptomInputPage({super.key});
  @override
  State<SymptomInputPage> createState() => _SymptomInputPageState();

}
class _SymptomInputPageState extends State<SymptomInputPage>{
  final List<Symptom> symptoms=[
    Symptom("Skin Darkening"),
    Symptom("Hair Growth"),
    Symptom("Weight Gain"),
    Symptom("Irregular Cycle"),
    Symptom("Frequent FastFood intake"),
    Symptom("Pimples(Acne)"),
    Symptom("Hair Loss"),
  ];
  
// Converting to binary for backend 
  List<int> _submit(){
    return symptoms.map((s)=>s.value?1:0).toList();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Symptom Input")),
      body: ListView.builder(itemCount: symptoms.length, itemBuilder:(context,index){
        final symptom=symptoms[index];
        return ListTile(
          title: Text(symptom.name),
          trailing: YesNoToggle(
            value:symptom.value,
            onChanged:(val){
              setState(() {
                symptom.value=val;
              });
            },
          ),
        );
      }   
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          final bin=_submit(); 
          Navigator.push(context,MaterialPageRoute(builder: (_)=> SymptomsDiscrete(bin:bin),
          ),
          );
         // Navigator.pushNamed(context, '/symptoms_discrete');
          },
        child: const Icon(Icons.send),
      ),
    );
  }
  
}