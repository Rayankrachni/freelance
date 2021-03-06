import 'dart:io';
import 'package:freelance/Model/Client/Client_Model.dart';
import 'package:freelance/Model/Fcature/Facture_Model.dart';
import 'package:freelance/Model/Fournisseur/Fournisseur_Model.dart';
import 'package:freelance/Model/Produit/Produit_Model.dart';
import 'package:freelance/Querries/Client_session.dart';
import 'package:freelance/Querries/Fournisseur_Session.dart';
import 'package:freelance/Querries/Produit_Session.dart';
import 'package:freelance/Screens/Details/Facture_Detail/header_envoice.dart';
import 'package:freelance/controller.dart';
import 'package:freelance/widget/PdfApi.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' ;
//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
class PdfEnvoiceApi{

  static double? totaltva;
  static double?totalttc;
  static double?total;

  static Future<File> generate (Facture_Model invoice, Client_Model  invoiceclient, Fournisseur_Model invoicefournisseur, List<Produit_Model> invoiceproduit,List<String> qte) async {
    totalttc=0;
    totaltva=0;

    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice, invoiceclient,  invoicefournisseur, invoiceproduit,qte),
      ],
     // footer: (context) => buildFooter(invoice),
    ));

    return await PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);

  }


  static Widget buildHeader(Facture_Model invoice, Client_Model  invoiceclient, Fournisseur_Model invoicefournisseur,
      List<Produit_Model> invoiceproduit,List<String>qte) {
    total=totalttc!+totaltva!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 0.5 * PdfPageFormat.cm),
            Center(child: Text('SNC Krachni Lahcen et Ses Freres',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: PdfColors.green),),),
            SizedBox(height: 0.3 * PdfPageFormat.cm),
            Center(child: Text('Commerce Gros des Legumes Sec et Produits de la Minoterie',style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),),),
            SizedBox(height: 0.3 * PdfPageFormat.cm),
            Center(child: Text(invoicefournisseur.address!,style: TextStyle(fontSize: 13.5),),),
            SizedBox(height: 0.5 * PdfPageFormat.cm),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildClientsection(invoiceclient),
                  SizedBox(width: 0.5 * PdfPageFormat.cm),
                  buildfournisseursection(invoicefournisseur),

                ]),
            SizedBox(height: 0.5 * PdfPageFormat.cm),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(text: TextSpan(
                        children: [
                          TextSpan(text: 'Facture Numero : ',style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold) ),
                          TextSpan(text: invoice.num_facture.toString())
                        ]
                    )),
                    SizedBox(width: 1 * PdfPageFormat.cm),
                    RichText(text: TextSpan(
                        children: [
                          TextSpan(text: 'Date : ',style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          TextSpan(text: invoice.date.toString())
                        ]
                    )),
                  ]
              ),
            ),

            SizedBox(height: 0.5 * PdfPageFormat.cm),
            buildInvoice(invoiceproduit,qte),
            SizedBox(height: 1 * PdfPageFormat.cm),
            //buildTvaInvoice(invoiceproduit,qte),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTvaInvoice(invoiceproduit,qte),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 0.1 * PdfPageFormat.cm),
                            Text('Total Net Ht:',style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            SizedBox(height: 0.1 * PdfPageFormat.cm),
                            Text('Total TVA:',style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            SizedBox(height: 0.1 * PdfPageFormat.cm),
                            if(invoice.timber!=0) Text('Timber:',style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            if(invoice.timber!=0) SizedBox(height: 0.1 * PdfPageFormat.cm),
                            Text('Total :',style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),


                          ]
                        ),
                        SizedBox(width: 0.4 * PdfPageFormat.cm),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 0.1 * PdfPageFormat.cm),
                              Text('$totalttc',style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),),
                              SizedBox(height: 0.1 * PdfPageFormat.cm),
                              Text('$totaltva',style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),),
                              SizedBox(height: 0.1 * PdfPageFormat.cm),
                              if(invoice.timber!=0) Text('${(invoice.timber!/100)*totalttc!}',style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),),
                              if(invoice.timber!=0) SizedBox(height: 0.1 * PdfPageFormat.cm),
                              Text('${totaltva!+totalttc!+(0.1*totalttc!)}',style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),),

                            ]
                        ),
                        SizedBox(width: 0.1 * PdfPageFormat.cm),
                      ]
                    )
                  )
                  //buildTotalInvoice(),

                ]),
            SizedBox(height: 3 * PdfPageFormat.cm),
            Align(
              alignment: Alignment.bottomRight,
              child:Text("Signature et Cache ",style: TextStyle(fontSize: 13.5),),
            )




            ,SizedBox(height: 1 * PdfPageFormat.cm),

          ],
        );
      }


  static  Widget buildClientsection(Client_Model client) =>
   Container(
    width:260,
    decoration: const BoxDecoration(
      color: PdfColors.white,
        borderRadius: BorderRadius.all(Radius.circular(5))

    ),
    child:
    Column(
    mainAxisAlignment:MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     // Text("Client",style:TextStyle(fontWeight: FontWeight.bold,)),
      RichText(text: TextSpan(
          children: <TextSpan>[
            TextSpan(text:"Nom : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
            TextSpan(text:"${client.fullname}" )

          ]
      )),
      SizedBox(height: 1 * PdfPageFormat.mm),
      RichText(text: TextSpan(
          children: <TextSpan>[
            TextSpan(text:"Address : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
            TextSpan(text:"${client.address} Willaya ${client.willaya}" )

          ]
      )),
      SizedBox(height: 1 * PdfPageFormat.mm),
      RichText(text: TextSpan(
          children: <TextSpan>[
            TextSpan(text:"Tel/Fax : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
            TextSpan(text:"${client.telephone}" )

          ]
      )),
      SizedBox(height: 1 * PdfPageFormat.mm),
      RichText(text: TextSpan(
          children: <TextSpan>[
            TextSpan(text:"Activite : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
            TextSpan(text:"${client.activite}" )

          ]
      )),
      SizedBox(height: 1 * PdfPageFormat.mm),
      RichText(text: TextSpan(
          children: <TextSpan>[
            TextSpan(text:"Num Nif  : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
            TextSpan(text:"${client.nif}" )

          ]
      )),
      SizedBox(height: 1 * PdfPageFormat.mm),
      RichText(text: TextSpan(
          children: <TextSpan>[
            TextSpan(text:"Num Nic  : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
            TextSpan(text:"${client.nic}" )

          ]
      )),
      SizedBox(height: 1 * PdfPageFormat.mm),
      RichText(text: TextSpan(
          children: <TextSpan>[
            TextSpan(text:"Num Art  : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
            TextSpan(text:"${client.art}" )

          ]
      )),
      SizedBox(height: 1 * PdfPageFormat.mm),
      RichText(text: TextSpan(
          children: <TextSpan>[
            TextSpan(text:"Num rc  : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
            TextSpan(text:"${client.rc}" )

          ]
      ))

    ],
  ) );


  static  Widget buildfournisseursection(Fournisseur_Model fournisseur) =>
      Container(
        width:200,
          decoration: BoxDecoration(
            color: PdfColors.grey50,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           // Text("Fournisseur",style:TextStyle(fontWeight: FontWeight.bold,)),

            RichText(text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text:"Tel/Fax  : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
                  TextSpan(text:"${fournisseur.telephone}" )

                ]
            )),
            SizedBox(height: 1 * PdfPageFormat.mm),
            RichText(text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text:"No Nic  : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
                  TextSpan(text:"${fournisseur.nif}" )

                ]
            )),
            SizedBox(height: 1 * PdfPageFormat.mm),
            RichText(text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text:"No Nic  : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
                  TextSpan(text:"${fournisseur.nic}" )

                ]
            )),
            SizedBox(height: 1 * PdfPageFormat.mm),
            RichText(text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text:"Num Art  : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
                  TextSpan(text:"${fournisseur.art}" )

                ]
            )),
            SizedBox(height: 1 * PdfPageFormat.mm),
            RichText(text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text:"Num rc  : ",style:TextStyle(fontWeight: FontWeight.bold,) ),
                  TextSpan(text:"${fournisseur.rc}" )

                ]
            )),

          ],
        )
      )
     ;

 static Widget buildInvoice(List<Produit_Model> produit,List<String> quantite) {

    final headers = [
      'Code Article',
      'Designation',
      'Quantite',
      'Tva',
      'Prix Unit',
      'Total Hors Tax'
    ];
   final  data = produit.asMap().map((i,e){
      totalttc=totalttc!+(e.prix!*int.parse(quantite[i]));
      return MapEntry(i,[
       e.code,
       e.name,
       quantite[i],
       e.tva,
       e.prix,
      ' ${e.prix!*int.parse(quantite[i])} Da',



       ]);
   }).values.toList();



    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.green50),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.center,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
      },
    );
  }
 static Widget buildTvaInvoice(List<Produit_Model> produit,List<String> quantite) {
    final headers = [
      'Tva',
      'Total Ht',
      'Montant Tva',
    ];
    final  data = produit.asMap().map((i,e){
      totaltva=totaltva!+ ((e.tva! * 0.01)*(e.prix!*int.parse(quantite[i])));
      return MapEntry(i,[
        e.tva,
        e.prix!*int.parse(quantite[i]),
        ((e.tva! * 0.01)*(e.prix!*int.parse(quantite[i]))),


      ]);
    }).values.toList();



    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.green50),
      cellHeight: 20,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
      },
    );
  }

 static Widget buildTotalInvoice() {
    final headers = [
      'Total TTC',
      'Total Tva',
      'Timber',
      'Total',
    ];

    final data=<List> [
    [  totalttc,
        totaltva,
        total , totaltva! + totalttc!,]

    ].toList();
    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      //headerDecoration: BoxDecoration(color: PdfColors.green50),
      cellHeight: 20,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
      },
    );
  }




}


