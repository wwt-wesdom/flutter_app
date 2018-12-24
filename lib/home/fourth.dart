import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../routers/application.dart';
import './../store/store.dart' show AppState;
import '../store/reducer/theme_reducer.dart' show ThemeAction;
import 'dart:ui' as ui;
import 'dart:core';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'dart:io';
class Fourth extends StatefulWidget {
  @override
  _FourthState createState() => _FourthState();
}

class _FourthState extends State<Fourth> {
  GlobalKey rootWidgetKey = GlobalKey();

  List<Uint8List> images = List();

  _capturePng(context) async {
    try {
      RenderRepaintBoundary boundary =
      rootWidgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format:ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      images.clear();
      images.add(pngBytes);
      print(images[0]);
      this.showDialogFun(context);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }

  void saveImage() async {
    var filePath = await ImagePickerSaver.saveFile(fileData: images[0]);
//    print(filePath);
  }

  showDialogFun(BuildContext context){
    showDialog(context:context,
      builder:(context)=> AlertDialog(
        title: Image.memory(images[0],fit: BoxFit.cover,),
        actions: <Widget>[
          FlatButton(onPressed: (){
            saveImage();
          }, child: Text('确定')),
          FlatButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text('取消')),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,Map>(
      converter: (store) {
        print( store.state.map);
        var map = Map()..['theme'] = store.state.map;
        map['changeTheme'] = (color) {
          store.dispatch(ThemeAction('change_theme_color',color));
        };
        return map;
      },
      builder: (context ,map){
        void changeThemeColor(color) {
          map['changeTheme'](color);
        }
        String international = map['theme']['international'];
        return Scaffold(
          appBar: AppBar(
            title: Text('fourth'),
          ),
          body: ListView(
            children: <Widget>[
              Center(
                child: RaisedButton(
                    onPressed: (){
                      changeThemeColor(Colors.blue);
                    },
                    child: Text('蓝色主题',style: TextStyle(color: map['theme']['color']),),
                ),
              ),
              Center(
                child: RaisedButton(
                  onPressed: (){
                    changeThemeColor(Colors.green);
                  },
                  child: Text('绿色主题',style: TextStyle(color: map['theme']['color']),),
                ),
              ),
              Center(
                child: RaisedButton(
                  onPressed: (){
                    changeThemeColor(Colors.yellow);
                  },
                  child: Text('黄色主题',style: TextStyle(color: map['theme']['color']),),
                ),
              ),
              Center(
                child: RaisedButton(
                  onPressed: (){
                    Application.router.navigateTo(context, "/five");
                    print('adlfasldfj');
                  },
                  child: Text('five',style: TextStyle(color: Colors.black)),
                ),
              ),
              /*Center(
                child: Container(
                  constraints: BoxConstraints.expand(
                    height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.teal.shade700,
                  alignment: Alignment.center,
                  child: Text('Hello World', style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white)),
                  foregroundDecoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://www.example.com/images/frame.png'),
                      centerSlice: Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                    ),
                  ),
                  transform: Matrix4.rotationZ(0.0),
                ),
              ),*/
              RepaintBoundary(
                key: rootWidgetKey,
                child: Image(image: NetworkImage("http://qiniu.nightfarmer.top/test.gif"),width: 300,height: 300,),
              ),
              Center(
                child: RaisedButton(
                  onPressed: (){
                    print('截图');
                    this._capturePng(context);
                  },
                  child: Text('点击截图',style: TextStyle(color: map['theme']['color']),),
                ),
              ),
             /* Expanded(
                child: ListView.builder(
                  itemBuilder: (context ,index){
                    return Image.memory(images[index],fit: BoxFit.cover,);
                  },
                  itemCount: images.length,
                )
              )*/
            ],
          ),
        );
      },
    );
  }
}
