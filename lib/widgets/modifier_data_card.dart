import 'package:flutter/material.dart';

import '../constants.dart';

const  Map<Types, String> typesExplain={
  Types.requiredOne: "choose one",
  Types.requiredMulti: "choose one or more",
  Types.optionalMulti: "optional",
};



class ModifierDataCard extends StatelessWidget {
  final List<dynamic> modifierChoices;
  final String modifierName;
  final Types type;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(

        children: [
          Text(modifierName,style: TextStyle(fontSize: 22,letterSpacing: 1, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorDark),),
          const SizedBox(height: 5,),
          Text(typesExplain[type]!,style: const TextStyle(fontSize: 10,letterSpacing: 1, fontWeight: FontWeight.bold,),),
          ...modifierChoices.map((e) =>
          ListTile(
      subtitle:Text(e["price"]+" \$") ,
      title: Text(e["name"]),
      trailing: IconButton(onPressed: (){},
      icon: Icon(type==Types.requiredOne?Icons.radio_button_off:Icons.check_box_outline_blank)),)
          ).toList()
          ,
        ],
      ),
    );
  }

  const ModifierDataCard({Key? key,
    required this.modifierChoices,
    required this.modifierName,
    required this.type,
  }) : super(key: key);
}
