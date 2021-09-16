import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rhino_pizzeria/constants.dart';
import 'package:rhino_pizzeria/helpers/functions.dart';
import 'package:rhino_pizzeria/helpers/helper_classes.dart';
import 'package:rhino_pizzeria/widgets/loading_widget.dart';




class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool _loading = false;
  final List<Modifier> _modifiers=[];
  final Map<String,List<ModifierData>> _modifiersData={};
   String? _imagePath;
  final TextEditingController _controller=TextEditingController();
  final TextEditingController _controller2=TextEditingController();

  void pickImage()async{
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image!=null) {
      setState(() {_imagePath= image.path;});
    }
  }
  
  void addModifier()async{
    Modifier? _modifier=await showDialog(context: context, builder: (context) =>const AddModifier(),);
    if(_modifier!=null){
      setState(() {
        _modifiers.add(_modifier);
        _modifiersData[_modifier.name]=[];
      });
    }
  }

  void addModifierData(Modifier modifier,)async{
    ModifierData? _data=await showDialog(context: context, builder: (context) => AddModifierData(type: modifier.type,modifierName:modifier.name ,),);
    if(_data!=null){
      setState(() {
        _modifiersData[modifier.name]!.add(_data);
      });
    }
  }

  void removeModifierData(Modifier modifier,ModifierData data)async{
  setState(() {
    _modifiersData[modifier.name]?.remove(data);
  });
  }

  void submit()async{
    if(_controller.text.isEmpty||_controller2.text.isEmpty||_modifiers.isEmpty||_imagePath==null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all field")));
    }
    else{
      setState(() {
        _loading=true;
      });
      final List<ModifiersHelper> _m=[];
      for (var element in _modifiersData.values) {
        _m.add(ModifiersHelper(name: element.first.modifierName, type: element.first.type, modifierData: element.map((e) => {"name":e.name,"price":e.price}).toList()));
      }
      final _p=ProductHelper(name: _controller.text, description: _controller2.text, imagePath: _imagePath!, productModifiers: _m);
     await  uploadProduct(product:  _p);
      setState(() {
        _loading=false;
      });
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: () => Navigator.pop(context), icon:const Icon(Icons.arrow_back,size: 35,)),
                      const Text("Add Product",style: TextStyle(fontSize: 23,letterSpacing: 1, fontWeight: FontWeight.bold),),
                      FloatingActionButton(elevation: 0,backgroundColor: Colors.transparent, onPressed: submit, child:const Icon(Icons.check_circle_outline,size: 35,color: Colors.green,)),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  SizedBox(
                    height: MediaQuery.of(context).size.longestSide/4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: pickImage,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          child:_imagePath!=null?ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(File(_imagePath!),)):
                          const Center(child:  Icon(Icons.add_photo_alternate,size: 45,),),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children:  [
                      TextField(maxLines: 1,controller: _controller, textInputAction: TextInputAction.next, decoration: KTextFieldDecoration.copyWith(labelText: "Title"),),
                      const SizedBox(height: 20,),

                      TextField(maxLines: 2,controller: _controller2, textInputAction: TextInputAction.done,decoration: KTextFieldDecoration.copyWith(labelText: "Description")),
                    ],),
                  ),
                  const SizedBox(height: 30,),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      const Text("Modifiers",style: TextStyle(fontSize: 25,letterSpacing: 1, fontWeight: FontWeight.bold,),),
                      ElevatedButton(onPressed: (){addModifier();}, child: const Text("Add")),
                    ],),
                  ),

                  Column(children: List.generate(_modifiers.length,  (index) => buildModifiers(index),),),

                ],
              ),
            ),
            Visibility(
                visible:_loading ,
                child: const LoadingWidget())
          ],
        ),

      ),
    );
  }

  Column buildModifiers(int index) {
    return Column(
                children: [
                 _modifiers[index],
                  Wrap(
                    children:List.generate(_modifiersData[_modifiers[index].name]!.length,
                  (i) => Row(
              children: [
              Expanded(child: _modifiersData[_modifiers[index].name]![i]),
              IconButton(onPressed: (){removeModifierData( _modifiers[index],_modifiersData[_modifiers[index].name]![i]);}, icon:const Icon(Icons.remove_circle,color: Colors.red,)),
              ],
            ),),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(borderRadius: BorderRadius.circular(20), child: GestureDetector(onTap: (){addModifierData(_modifiers[index]);}, child: Container(color: Colors.grey.shade200, height: 40,width: double.maxFinite,child: const Center(child: Text("Add+")),))),
                  ),
                ],
              );
  }

}

class AddModifier extends StatefulWidget {
  const AddModifier({
    Key? key,
  }) : super(key: key);

  @override
  State<AddModifier> createState() => _AddModifierState();
}

class _AddModifierState extends State<AddModifier> {
  Types _selectedType=Types.requiredOne;
  final TextEditingController _name=TextEditingController(text: "Drinks");
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),),

      content: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(maxLines: 1,controller: _name, textInputAction: TextInputAction.next, decoration: KTextFieldDecoration.copyWith(labelText: "Modifier Name"),),
          ),
          Column(
            children: [
              RadioListTile<Types>(value: Types.requiredOne,title: const Text("Required - must pick one"), groupValue: _selectedType, onChanged: (v){setState(() {_selectedType=v!;});},),
              RadioListTile<Types>(value: Types.requiredMulti,title: const Text("Required - multi select"), groupValue: _selectedType, onChanged: (v){setState(() {_selectedType=v!;});},),
              RadioListTile<Types>(value: Types.optionalMulti,title: const Text("Optional - multi select"), groupValue: _selectedType, onChanged: (v){setState(() {_selectedType=v!;});},),
            ],
          ),
      ]
    ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                  style:TextButton.styleFrom(primary: Colors.redAccent),
                  onPressed:(){Navigator.pop(context);} ,
                  child:  const Text("Cancel",)
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed:  (){
                  if(_name.text.isNotEmpty) {
                    Navigator.pop(context,Modifier(name: _name.text, type: _selectedType,onTapAdd: (){}));
                  }
                  },
                child:  const Text("Submit",),
              ) ,
            ),
          ],
        )
      ],
    );
  }
}

class AddModifierData extends StatefulWidget {
  final String modifierName;
  final Types type;

  @override
  _AddModifierDataState createState() => _AddModifierDataState();

   const AddModifierData({
    required this.modifierName,
    required this.type,
  });
}

class _AddModifierDataState extends State<AddModifierData> {

  final TextEditingController _name=TextEditingController(text: "Water");
  final TextEditingController _price=TextEditingController(text: "10");
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),),

      content: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(controller: _name, maxLines: 1, textInputAction: TextInputAction.next, decoration: KTextFieldDecoration.copyWith(labelText: "Modifier Name"),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(maxLines: 1,
                controller: _price,
                keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done, decoration: KTextFieldDecoration.copyWith(labelText: "Price"),),
            ),
          ]
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                  style:TextButton.styleFrom(primary: Colors.redAccent),
                  onPressed:(){Navigator.pop(context);} ,
                  child:  const Text("Cancel",)
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed:  (){
                  if(_name.text.isNotEmpty&&_price.text.isNotEmpty){Navigator.pop(context,ModifierData(name: _name.text, modifierName: widget.modifierName, price: _price.text, type: widget.type ));}
                  },
                child:  const Text("Submit",),
              ) ,
            ),
          ],
        )
      ],
    );
  }
}





class Modifier extends StatelessWidget {

  final String name;
  final Types type;
  final Function onTapAdd;
   const Modifier({Key? key,
    required this.name,
    required this.type,
     required this.onTapAdd
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 20,),
      Text(name,style: TextStyle(fontSize: 30,letterSpacing: 1, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorDark),),
      const SizedBox(height: 30,),



    ],);
  }
}

class ModifierData extends StatelessWidget {
  final String name;
  final String modifierName;
  final String price;
  final Types type;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle:Text(price+" \$") ,
      title: Text(name),
      leading: IconButton(onPressed: (){},
        icon: Icon(type==Types.requiredOne?Icons.radio_button_off:Icons.check_box_outline_blank)),);
  }

    const ModifierData({Key? key,
    required this.name,
    required this.modifierName,
    required this.price,
    required this.type,
  }) : super(key: key);
}


