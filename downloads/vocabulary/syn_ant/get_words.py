import os
# 導入 pybean 模組與所要使用的 Store 及 SQLiteWriter 方法
from pybean import (
    Store, 
    SQLiteWriter
)
import sqlite3

data_dir = "./"

stud_fn = os.path.abspath(os.path.join(os.path.dirname(__file__), 'words.txt'))

with open(stud_fn) as f:
    # 讀進檔案內容作為字串
    data = f.read()
# 利用 "=" 切割, 將個單字段落放入數列中
words = data.split("=")
# 去除第一個符號元素
words = words[1:]
# 共有 7939 個單字
print(len(words))
print(words[0])
word = []
for i in range(len(words)):
    wordSegment = words[i].split("\n")
    #print(wordSegment)
    
    if (len(wordSegment) == 5):
        try:
            vocabulary = wordSegment[1].split(":")[1]
            #print(vocabulary)
            syn = wordSegment[2].split(":")[1]
            ant = wordSegment[3].split(":")[1]
            word.append(vocabulary)
        except:
            #print(vocabulary)
            continue
print(word)

'''
可以再將每一元素以 \n 切割, 並以 ":" 進行分離, 之後再利用資料庫中的 word, syn 與 ant 等三個資料欄位進行儲存, 之後就可以利用單字查詢同義字與反義字, 或者建立 flaskcard 應用
'''
