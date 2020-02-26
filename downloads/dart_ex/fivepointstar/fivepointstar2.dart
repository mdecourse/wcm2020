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

fivePointStar(x, y, r, solid, theta, color) {
  // 假如在 html 模式下執行非超文件內容相關的 print, 資料將會顯示在 console 區
  print("準備畫一個位於 ($x, $y), 半徑 $r, 實心為 $solid, 顏色為 $color 的五芒星");
}

main() {
  int x = 100;
  int y = 100;
  int r = 30;
  bool solid = false;
  var theta = 0;
  var color = "black";
  // 呼叫 fivePointStar() 函式
  fivePointStar(x, y, r, solid, theta, color);
}
