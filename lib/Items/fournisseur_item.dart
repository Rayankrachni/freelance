
import 'package:flutter/material.dart';
import 'package:freelance/Model/Fournisseur/Fournisseur_Model.dart';
import 'package:freelance/Querries/Fournisseur_Session.dart';
import 'package:freelance/Screens/Details/Detail_Fournisseur.dart';
import 'package:freelance/widgets/Success_Diag.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Screens/HomePage.dart';

class FournisseurItem extends StatefulWidget {
  Fournisseur_Model? fournisseur;
  FournisseurItem({Key? key,this.fournisseur}) : super(key: key);

  @override
  _FournisseurItemState createState() => _FournisseurItemState();
}

class _FournisseurItemState extends State<FournisseurItem> {
  void Delete_Fourniseur()async {

    int insrtcleint=   await FournisseurSession.DeleteFournisseur(widget.fournisseur!.id!);
    if( insrtcleint!= 0)
    {
      showDialog(context: context, builder:(_)=>Success_Dialog(mytext: "Client done",mywidgets :()=> HomePage()));
    }
    else {
      print('results $insrtcleint');
    }

  }
  @override
  Widget build(BuildContext context) {
    double _width=MediaQuery.of(context).size.width;
    double _height=MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: ()=>{
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FournisseurDetail(fournisseur: widget.fournisseur! )))
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          height: _height*0.1,
          decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [BoxShadow(
                  blurRadius:5 ,
                  color: Colors.grey.withOpacity(0.2),
                  offset: Offset(0,3)
              )]
          ),
          child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Row(
                  children:  [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/client.jpg",),
                      radius: 25,
                    ),
                    const SizedBox(width:20 ,),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(widget.fournisseur!.fullname!,style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.bold ),),
                          SizedBox(height: 4.0,),
                          Text(widget.fournisseur!.willaya!,style: GoogleFonts.lato(color:Colors.black54,fontSize: 12,fontWeight: FontWeight.bold ),)

                        ],
                      ),
                    )

                    ,],
                ),
                IconButton(onPressed: (){
                  Delete_Fourniseur();
                }, icon: Icon(Icons.more_vert,size: 30,color: Colors.teal,))

              ],
            ),
          ),

        ),
      ),
    );
  }
}
