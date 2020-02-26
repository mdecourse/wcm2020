// 程式來源: https://github.com/tensor-programming/flutter-temperature
// 導入 material 程式庫 https://flutter.dev/docs/development/ui/widgets/material
import 'package:flutter/material.dart';

// dart 程式從 main() 開始執行, 利用 fat arrow 函式定義執行 runApp() 輸入為 MyApp()
void main() => runApp(MyApp());

// MyApp 延伸自  StatelessWidget
class MyApp extends StatelessWidget {
  // 改寫 build 方法
  @override
  build(BuildContext context) {
    // 傳回 MaterialApp 物件, 亦即 runApp() 的輸入內容
    return MaterialApp(
      // MaterialApp 有兩個欄位 theme 與 home, 而 home 設為 TempConv() 物件內容
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TempConv(),
    );
  }
}

// TempConv 類別延伸自 StatefulWidget
class TempConv extends StatefulWidget {
  // 改寫 createState() 函式內容, 設為 TempState() 物件
  @override
  TempState createState() => TempState();
}

// TempState 類別延伸自 TempConv 資料型別物件的 State
class TempState extends State<TempConv> {
  double input;
  double output;
  bool fOrC;
  
  // 改寫 initState() 方法
  @override
  void initState() {
    // 建立案例時先執行父類別的 initState() 方法
    super.initState();
    // 起始變數值
    input = 0.0;
    output = 0.0;
    fOrC = true;
  }
  
  // 改寫 build 方法
  @override
  Widget build(BuildContext context) {
    // 宣告一個 TextField 型別的變數 inputField
    // https://flutter.dev/docs/cookbook/forms/text-input
    TextField inputField = TextField(
      // 輸入欄位的資料型別設為 number, 若在手機執行將帶出數字鍵盤
      keyboardType: TextInputType.number,
      // 欄位內容變更時, 事件傳遞變數為 str
      onChanged: (str) {
        // 欄位輸入內容將與 input 變數對應
        try {
          // 欄位輸入內容資料型別將為字串, 透過 double.parse() 轉為雙浮點數
          input = double.parse(str);
        } catch (e) {
          // 假如使用者沒有輸入資料, 則內定 input 為 0.0
          input = 0.0;
        }
      },
      decoration: InputDecoration(
        // 輸入欄位的標籤文字設定
        labelText:
            "請輸入 ${fOrC == false ? "Fahrenheit" : "Celsius"}",
      ),
      textAlign: TextAlign.center,
    );

    AppBar appBar = AppBar(
      title: Text("溫度轉換"),
    );
    // 在 build 方法中建立一個 Container
    // 其中帶有一個 radio 選項, 轉換按鈕, 以及利用 AlertDialog 顯示轉換結果
    Container tempSwitch = Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          //Text("Choose Fahrenheit or Celsius"),
          //Switch(
          //  value: fOrC,
          //  onChanged: (e) {
          //    setState(() {
          //      fOrC = !fOrC;
          //    });
          //  },
          //)

          //Checkbox(
          //  value: fOrC,
          //  onChanged: (e) {
          //    setState(() {
          //      fOrC = !fOrC;
          //    });
          //  },
          //),

          Text("F"),
          Radio<bool>(
              groupValue: fOrC,
              value: false,
              onChanged: (v) {
                setState(() {
                  fOrC = v;
                });
              }),
          Text("C"),
          Radio<bool>(
              groupValue: fOrC,
              value: true,
              onChanged: (v) {
                setState(() {
                  fOrC = v;
                });
              }),
        ],
      ),
    );

    Container calcBtn = Container(
      child: RaisedButton(
        child: Text("轉換"),
        onPressed: () {
          setState(() {
            fOrC == false
                ? output = (input - 32) * (5 / 9)
                : output = (input * 9 / 5) + 32;
          });
          AlertDialog dialog = AlertDialog(
            content: fOrC == false
                ? Text(
                    "${input.toStringAsFixed(2)} F : ${output.toStringAsFixed(2)} C")
                : Text(
                    "${input.toStringAsFixed(2)} C : ${output.toStringAsFixed(2)} F"),
          );
          showDialog(context: context, child: dialog);
        },
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        padding: EdgeInsets.all(16.0),
        // 部件的布局採 Column, 分別放入 inputField, tempSwitch 與 calcBtn
        child: Column(
          children: <Widget>[
            inputField,
            tempSwitch,
            calcBtn,
          ],
        ),
      ),
    );
  }
}
