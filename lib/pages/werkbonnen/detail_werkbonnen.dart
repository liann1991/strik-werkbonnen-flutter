import 'package:flutter/material.dart';
import 'package:flutter_app_backend/components/text_widget.dart';
import 'package:flutter_app_backend/models/get_werkbonnen_info.dart';
import 'package:intl/intl.dart';


class DetailWerkbonnenPage extends StatefulWidget {
  final Werkbon werkbonnen;
  final int index;
   DetailWerkbonnenPage({Key key, this.werkbonnen, this.index}) : super(key: key);

  @override
  _DetailWerkbonnenPageState createState() => _DetailWerkbonnenPageState();
}

class _DetailWerkbonnenPageState extends State<DetailWerkbonnenPage> {
  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd-MM-yyyy').format(this.widget.werkbonnen.datum);
    final double screenWidth=MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 30,
              backgroundColor: Color(0xFFffffff),
              elevation: 0.0,
            ),
          body:Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left:0, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          padding:EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon:

                      Icon(Icons.arrow_back_ios, color:Color(0xFF363f93)),
                          onPressed:()=>Navigator.pop(context))
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  child: Row(
                    children: [
                      Material(
                        elevation:0.0,
                      ),
                      Container(
                        width: screenWidth-30-180-20,
                        margin: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(text: dateStr, fontSize: 30,),
                            TextWidget(text:this.widget.werkbonnen.werkomschrijving.omschrijving, fontSize: 20,color:Color(0xFF7b8ea3)),
                            Divider(color:Colors.grey),
                            TextWidget(text:'totaaltijd: ' + this.widget.werkbonnen.totaaltijdDag, fontSize: 16,color:Color(0xFF7b8ea3)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40,),
                Divider(color:Color(0xFF7b8ea3)),
                SizedBox(height: 10,),

                Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.lock_clock, color:Color(0xFF7b8ea3), size: 40,),
                          SizedBox(width: 10,),
                          TextWidget(text:"Begintijd: " + this.widget.werkbonnen.begintijd, fontSize: 20),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.lock_clock, color:Color(0xFF7b8ea3), size: 40,),
                          SizedBox(width: 10,),
                          TextWidget(text:"Pauze: " + this.widget.werkbonnen.pauze, fontSize: 20),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.lock_clock, color:Color(0xFF7b8ea3), size: 40,),
                          SizedBox(width: 10,),
                          TextWidget(text:"Eindtijd: " + this.widget.werkbonnen.eindtijd, fontSize: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40,),
                Row(
                  children: [
                    TextWidget(text:"Details", fontSize: 20,),
                    Expanded(child: Container())
                  ],
                ),
                SizedBox(height: 30,),
                Container(
                  height: 100,
                  child: TextWidget(text:this.widget.werkbonnen.werkomschrijving.omschrijving, fontSize: 16, color: Colors.grey),
                ),
                Divider(color:Color(0xFF7b8ea3)),
                GestureDetector(
                  onTap: (){
                  },
                  child:
                Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      TextWidget(text:"Edit", fontSize: 20,),
                      Expanded(child: Container()),
                      IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: null)
                    ],
                  ),

                ),
                ),
                Divider(color:Color(0xFF7b8ea3)),
                GestureDetector(
                  onTap: (){
                  },
                  child:
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        TextWidget(text:"Delete", fontSize: 20,),
                        Expanded(child: Container()),
                        IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: null)
                      ],
                    ),

                  ),
                ),
                Divider(color:Color(0xFF7b8ea3)),

              ],
            ),
          )
        ),
      ),
    );
  }
}
