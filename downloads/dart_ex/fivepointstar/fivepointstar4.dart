// 因為要應用 html 表單以及 canvas 繪圖物件因此要導入 dart:html 程式庫
import 'dart:html';
// 因為需要用到三角函式以及 pi 來執行運算求點座標, 因此要導入 dart:math 程式庫
// 而對於初學者而言, 將所導入的數學程式庫, 特別又命名為 Math, 目的在讓使用者了解那些函式來自 math 程式庫
import 'dart:math' as Math;

// 這裡將 canvas 與 ctx 變數設計為全域變數, 表示有效範圍擴及整個程式
// 在 Dart 程式中宣告完變數後, 直接賦予初始值, 也可以分兩段式賦值
// 但是若宣告與複製分兩段且位於同一 block 區段, 就會產生重複宣告變數的錯誤, 所以這裡採宣告後直接賦值
CanvasElement canvas = querySelector('#canvas');
CanvasRenderingContext2D ctx = canvas.getContext('2d');
// 五個圓周外點數列
List outerPoints = [];

fivePointStar(x, y, r, solid, theta, color) {
  // 假如在 html 模式下執行非超文件內容相關的 print, 資料將會顯示在 console 區
  print("準備畫一個位於 ($x, $y), 半徑 $r, 實心為 $solid, 顏色為 $color 的五芒星");
  // 先設法畫一個圓心位於 x, y, 半徑為 r 的圓
  // 開始設定 path
  ctx.beginPath();
  // 沿用既有的座標系統, x 向右為正, y 向下為正
  // 假設從五芒星最上頭的一個點開始算, 座標從圓心 x,y 開始, 五芒星第一點座標為
  // x 座標為 x, 而 y 座標為 y - r
  // 至於以 z 軸向右旋轉五分之一圓周角度 (也就是 72 度), 其座標系統為:
  // x + r*sin(72度), 而 y 座標則為 y - (r - r*cos(72度))
  // 利用 for 迴圈求五芒星的五個外點座標
  var degree = Math.pi / 180;
  for (int i = 0; i <= 5; i++) {
    outerPoints.add([
      x + r * Math.sin(72 * degree * i + theta * degree),
      y - r * Math.cos(72 * degree * i + theta * degree)
    ]);
  }
  print(outerPoints);
  ctx.beginPath();
  for (int i = 0; i < 3; i++) {
    if (i == 2) {
      ctx.moveTo(outerPoints[i][0], outerPoints[i][1]);
      ctx.lineTo(outerPoints[i + 2][0], outerPoints[i + 2][1]);
    } else {
      ctx.moveTo(outerPoints[i][0], outerPoints[i][1]);
      ctx.lineTo(outerPoints[i + 2][0], outerPoints[i + 2][1]);
      ctx.moveTo(outerPoints[i][0], outerPoints[i][1]);
      ctx.lineTo(outerPoints[i + 3][0], outerPoints[i + 3][1]);
    }
  }
  //ctx.closePath();

  // 根據所設定的 color 值設定 strokeStyle
  ctx.strokeStyle = color;
  // path 要執行到 stroke() 方法才會下筆繪圖
  ctx.stroke();
  ctx.fillStyle = color;
  ctx.fill();
}

main() {
  int x = 200;
  int y = 200;
  int r = 150;
  bool solid = false;
  var theta = 20;
  // 因為背景為暗色, 改用 white 作圖
  var color = "white";
  // 呼叫 fivePointStar() 函式
  fivePointStar(x, y, r, solid, theta, color);
}
