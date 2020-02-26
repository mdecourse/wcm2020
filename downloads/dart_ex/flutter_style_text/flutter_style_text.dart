   // 導入 flutter material 程式庫
   import 'package:flutter/material.dart';

    // 主函式
    void main() => runApp(MyApp());
    
    // 定義 Myapp 類別, 延伸 StatelessWidget
    class MyApp extends StatelessWidget {
      // 改寫 StatelessWidget 既有的 build 方法
      @override
      Widget build(BuildContext context) {
        // 傳回 MaterialApp 物件
        return MaterialApp(
          // 不顯示 debug 標示
          debugShowCheckedModeBanner: false,
          // home 欄位設定採 Scaffold 布局
          home: Scaffold(
            // 布局設定有 appBar 與 body
            appBar: AppBar(title: Text('列出格式化字串')),
            // body 內容設為 Container, 其中有置中的部件, 而置中部件內容為 _myWidget()
            body: Container(
              child: Center(
                child: _myWidget(context),
              ),
            ),
          ),
        );
      }
    }

    // modify this widget with the example code below
    Widget _myWidget(BuildContext context) {
      String myString = 'I ❤️ Flutter';
      print(myString);
      return Text(
        myString,
        style: TextStyle(fontSize: 30.0),
      );
    }