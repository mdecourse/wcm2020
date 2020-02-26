import flask
# 導入 flask_cors 模組中的 CORS (cross-origin resource
sharing)
# 目的在讓伺服器可以被遠端的 Dart 程式跨網域擷取資料
from flask_cors import CORS

app = flask.Flask(__name__)
# 讓應用程式啟動後, 可以跨網域被截取資料
CORS(app, support_credentials=False)


@app.route('/', methods =['POST', 'GET'])
def root():
    if flask.request.method == 'POST': 
        data = flask.request.form['data'] 
        print(data)
        resp = {"data": data}
        output = flask.json.dumps(data)
    else:
        # 將 Python 中的 dictionary 資料透過 json 格式送出後
        # 讓遠端的 Dart 程式可以擷取
        data = {"a": 1, "b": 2, "c": "字串"}
        output = flask.json.dumps(data)
    return output

if __name__ == '__main__':
    # 內建的 Flask Web 啟動埠號為 5000
    app.run()
    
'''
https://api.dartlang.org/stable/2.6.1/dart-html/HttpRequest/request.html
https://stackoverflow.com/questions/43810508/dart-convert-string-representation-of-list-of-lists-to-list-of-list
https://stackoverflow.com/questions/19756349/how-can-i-access-the-result-of-the-response-of-httprequest-in-dart
// 因為要使用超文件表單, 因此導入 html 程式庫
// 希望從 Dart 表單取得的字串, 在 Dart 拆開後,
// 利用遠端的 Flask 進行溫度轉換
import "dart:html";
import "dart:convert";
import "dart:async";

// celsius = 5/9 ( fahrenheit − 32)
// 定義一個 celsius 轉 fahrenheit  函式
CtoF(num c) {
  return c * 9 / 5 + 32;
}

// 定義一個 celsius 轉 fahrenheit  函式
FtoC(num f) {
  return (f - 32) * 5 / 9;
}

// 每一個 Dart 程式都從 main() 開始執行
main() {
  // 透過表單, 取得使用者輸入的溫度值, 語法為數字加上 C 或 F
  InputElement tempInput = querySelector("#temp");
  querySelector("#submit").onClick.listen((e) => pyConvert(tempInput.value));
}

convert(String data) {
  // 宣告 len 整數變數, 準備設為各字串的長度
  int len;
  // 宣告 var 變數 type, 準備設為各字串最後一個字元, 可能為 C 或 F
  var type;
  // 宣告 var 變數 number, 準備設為各字串中的數字
  var number;
  // 準備將轉換結果顯示在 output Label 區
  LabelElement output = querySelector("#output");
  // 直接取得單一輸入 data 字串
  len = data.length;
  // 取得各筆資料的最後一個字元
  type = data[len - 1];
  number = data.substring(0, len - 1);
  // 將字串轉為數字
  number = int.parse(number);
  if (type == "C" || type == "c") {
    output.innerHtml = "攝氏 $number 度 = 華氏 ${CtoF(number).toStringAsFixed(2)} 度";
  } else if ((type == "F" || type == "f")) {
    output.innerHtml = "華氏 $number 度 = 攝氏 ${FtoC(number).toStringAsFixed(2)} 度";
  } else {
    output.innerHtml = "請輸入數字加上 C 或 F!";
  }
} // convert

pyConvert(String tempString) async {
  var data = {'data': tempString};
  var arequest = await HttpRequest.postFormData('http://localhost:5000', data)
      .then((HttpRequest request) {
    request.onReadyStateChange.listen((e) {
      // 準備將轉換結果顯示在 output Label 區
      LabelElement output = querySelector("#output");
      print(e);
      output.innerHtml = "ok";
    });
    request.open('post', 'nowhere');
    //request.send('');
  }).catchError((error) {
    print(
        error.target.responseText); // Current target should be you HttpRequest
        
  });
}
'''