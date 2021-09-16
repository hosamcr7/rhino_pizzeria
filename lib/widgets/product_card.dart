import 'package:flutter/material.dart';

import '../constants.dart';
import 'modifier_data_card.dart';





class ProductCard extends StatefulWidget {
  final String name;
  final String description;
  final String imageUrl;
  final List<ModifierDataCard> modifierData;





  @override
  _ProductCardState createState() => _ProductCardState();

  const ProductCard({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.modifierData,
  });
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
          title: Text(widget.name),
        subtitle: Text(widget.description,style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
        children: widget.modifierData,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 70,

            child: Image.network(widget.imageUrl,loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {return child;}
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              );
            },),
          ),
        ),

      ),
    );
  }
}
