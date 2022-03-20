import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoragePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _StoragePage();
  }
  
}

class _StoragePage extends State<StoragePage>{

  final TextEditingController controller = new TextEditingController();

  String hintText = "未设置";
  @override
  Widget build(BuildContext context) {
    getText();
    return Scaffold(
      appBar: AppBar(
        title: Text('缓存到本地页面'),
      ),
      body: Column(
        children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: TextFormField(
            controller: controller,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue),
            decoration: InputDecoration(
              hintText: hintText
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        RaisedButton(onPressed: (){
          saveText();
        },
        child: Text("保存"),
        color: Colors.yellow,)
      ],
      mainAxisAlignment: MainAxisAlignment.center,),
    );
  }

  void saveText() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("cache", controller.text);
  }

  void getText() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      hintText = prefs.getString("cache")??"未设置";
      print('setState    hintText:$hintText');
    });
  }
}