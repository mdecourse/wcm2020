import flask
# 導入 flask_cors 模組中的 CORS
# 目的在讓伺服器可以被遠端的 Dart 程式跨網域擷取資料
from flask_cors import CORS

app = flask.Flask(__name__)
# 讓應用程式啟動後, 可以跨網域被截取資料
CORS(app, support_credentials=False)
global data

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
        data = {"a": 1, "b": data+"yen", "c": "字串"}
        output = flask.json.dumps(data)
    return output
    
@app.route('/<name>', methods=['POST', 'GET'])
def convert(name):
    #name[-1] 為字串最後一個字元
    # name[:-1] 則為數字
    if name[-1] is "F" or name[-1] is "f":
        # 表示要將華氏溫度轉為攝氏
        return FtoC(name[:-1])
    else:
        return CtoF(name[:-1])
    
#celsius = 5/9 ( fahrenheit − 32)
#定義一個 celsius 轉 fahrenheit  函式
def CtoF(c):
    return "攝氏" + c + "度=華氏" + str(round(int(c)*9/5 + 32, 2)) + "度"

#定義一個 celsius 轉 fahrenheit  函式
def FtoC(f):
    return "華氏" + f + "度=攝氏" + str(round((int(f) - 32)*5/9, 2)) + "度"


if __name__ == '__main__':
    # 內建的 Flask Web 啟動埠號為 5000
    app.run()