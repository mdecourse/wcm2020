var tipuesearch = {"pages": [{'title': 'About', 'text': 'Repository:\xa0 https://github.com/mdecourse/wcm2020 \n Project:\xa0 https://github.com/mdecourse/wcm2020/projects/1 \n Gitter:\xa0 https://gitter.im/mdecourse/wcm2020 \n Web site:  https://mde.tw/wcm2020 \xa0 \n Blog:  https://mde.tw/wcm2020/blog \xa0 \n Presentation:\xa0  https://mde.tw/wcm2020/reveal \xa0 \n 參考:  https://mde.tw/cd2020pj1 \n 電腦輔助設計室與協同設計室行事曆 \n 全頁檢視 \n \n 請登入 gm 電子郵箱後, 填寫下列表單: \n 選課學員基本資料 \n 課程回饋表單 \n 網際內容管理自評與互評表單', 'tags': '', 'url': 'About.html'}, {'title': 'Grouping', 'text': '亂數分組: \n https://mde.tw/wcm2020/downloads/2020spring_wcm_1a_list.txt \xa0was taken from\xa0 https://osa.nfu.edu.tw/ \xa0on Feb. 19, 2020. \n The most updated list:\xa0 http://s1.mde.nfu.edu.tw:8000/?semester=1082&courseno=0744 \xa0 \n semester: 1082 \n courseno: 0744 \n Under https protocol use port 7443, for http use port 8000. \n 學員名單 URL:      \n \n Dart source code for random grouping \n evenGrouping.dart: \n import \'dart:html\';\n \n  InputElement studListUrl = querySelector("#studListUrl");\n  String studUrl;\n  // 將 Label 改為 Textarea, 避免產生過程結果嵌入所在頁面\n  TextAreaElement output = querySelector("#output");\n \nmain() {\n  querySelector("#submit").onClick.listen((e) => grouping());\n}\n \ngrouping() {\n  output.innerHtml = "";\n \n  if (studListUrl.value != "") {\n    studUrl = studListUrl.value;\n  } else {\n    studUrl = \'https://mde.tw/group/downloads/2019fall_cp_1a_list.txt\';\n  }\n \n  // 組序由 1 開始\n  int gth = 1;\n  // 迴圈序號變數\n  int i;\n  int j;\n  int total;\n  int inc;\n  // 每組學員暫存數列\n  var gpList = [];\n  // 全班分組數列\n  var group = [];\n  // 各組人數數列\n  var numList = [];\n  var courseTitle = \'wcm2020\';\n \n  HttpRequest.getString(studUrl).then((String resp) {\n    // 利用 trim() 去除字串最後的跳行符號, 之後再利用 split() 根據 \\n 轉為數列\n    var studList = resp.trim().split("\\n");\n    // 數列利用 shuffle() 方法以隨機方法弄亂順序\n    studList.shuffle();\n    total = studList.length;\n    output.text += "全班總計" + total.toString() + " 人\\n";\n    numList = getNumList(studList.length);\n    inc = 0;\n    for (i in numList){\n      // 列印區隔符號\n      output.text += \'=\' * 20 + "\\n";\n      output.text += "group $gth 有 " + i.toString() + " 人: \\n";\n      gpList = [];\n      for (j = 0; j < i; j++){\n        output.text += studList[j+inc] + "\\n";\n        // 在各分組數列中加入將對應的學員學號\n        gpList.add(studList[j+inc]);\n      }\n      gth = gth + 1;\n      inc = inc + j;\n        //output.text += studList[j] + "\\n";\n        // 逐步將各組暫存的分組數列加入全班分組數列中\n      gpList.sort();\n      group.add(gpList);\n    }\n    // 列出全班分組數列\n    output.text += group.toString() + "\\n";\n    // 列出已經排序後的分組名單\n    output.text += \'=\' * 25 + "\\n";\n    output.text += \'以下為排序後的各組成員名單: \\n\';\n    gth = 1;\n    /*\n    404231\n    s4052\n    4062\n    s4072\n    4082\n    5072\n    5083\n    */\n    // 先列出純文字以 \\n 跳行組員資料\n    for (i=0; i < group.length; i++){\n      // 列印區隔符號\n      output.text += \'=\' * 20 + "\\n";\n      output.text += "group $gth \\n";\n      gpList = [];\n      for (j=0; j < group[i].length; j++){\n        output.text += group[i][j] + "\\n";\n      }\n      gth = gth + 1;\n    }\n    \n    gth = 1;\n    // 最後列出超文件以 <br\\> 跳行組員資料, 包含倉儲與網站\n    for (i=0; i < group.length; i++){\n      // 列印區隔符號\n      output.text += \'\\n\' + \'=\' * 30 + "<br \\>";\n      output.text += "group $gth <br \\>";\n      gpList = [];\n      for (j=0; j < group[i].length; j++){\n          if (group[i][j].startsWith(\'4052\') || group[i][j].startsWith(\'4072\')) {\n              output.text += "Repository: <a href=\'https://github.com/s" + \n                                      group[i][j] + "/" + courseTitle + "\'>" + group[i][j] + \n                                      "</a>" + " | Site: <a href=\'https://s" + group[i][j] + \n                                      ".github.io/" + courseTitle + "\'>" + group[i][j] + \n                                      "</a><br \\>";\n          }\n          else {\n              output.text += "Repository: <a href=\'https://github.com/" + \n                                      group[i][j] + "/" + courseTitle +"\'>" + group[i][j] + \n                                      "</a>" + " | Site: <a href=\'https://" + group[i][j] + \n                                      ".github.io/" + courseTitle + "\'>" + group[i][j] + \n                                      "</a><br \\>";\n          }\n      }\n      gth = gth + 1;\n    }\n  });\n}\n \nList getNumList(int total){\n  // total student number\n  // int total = 65;\n  // initial each group expect to be "eachGrp" number of people\n  int eachGrp = 10;\n  // may divide into "grpNum" number of group\n  int grpNum = total ~/ eachGrp;\n  // vacant list\n  var splits = [];\n  // find remainder when total number divid into "grpNum" number of group\n  int remainder = total % grpNum;\n  // number of people in one group by calculation\n  int calGrp = total ~/ grpNum;\n \n  for (int i = 0; i < grpNum; i++) {\n    splits.add(calGrp);\n  }\n  //print(splits);\n \n  for (int i = 0; i < remainder; i++) {\n    splits[i] += 1;\n  }\n  //print(splits);\n  return splits;\n } \n index.html: \n <h1>亂數分組:</h1>\n學員名單 URL: <input type="text" id="studListUrl" size="50" value="https://mde.tw/wcm2020/downloads/2020spring_wcm_1a_list.txt"><br />\n<input type="submit" value="開始分組" id="submit"><br />\n<textarea id="output" cols="80" rows="10"></textarea> \n style.css: \n body {\n  color: white;\n  font-size: 20px;\n}\n\ninput, select, textarea {\nfont-size: 100%;\n} \n get_student.py \n from flask import Flask, request \nfrom flask_cors import CORS\n\nimport requests\nimport bs4\nimport ssl\n\n\'\'\'\nhttps://s1.mde.nfu.edu.tw:7443/?semester=1082&courseno=0767\ncd\n2a 1082/0767\n2b 1082/0780\n\n2a 1072/0777\n2b 1072/0790\n2a 1062/0788\n2a 1062/0802\n\nwcm\n1082/0744\n\n1072/0754\n1062/0765\n\nwcmj\n1082/2418\n\'\'\'\n\napp = Flask(__name__)\nCORS(app)\n\n@app.route(\'/studlist\')\n@app.route(\'/\')\ndef studlist():\n    semester = request.args.get(\'semester\')\n    courseno = request.args.get(\'courseno\')\n    if semester == None:\n        semester = \'1082\'\n    if courseno == None:\n        courseno = \'0744\'\n    \n    url = \'https://osa.nfu.edu.tw/query/studlist_ajax.php\'\n    post_var = {\'pselyr\': semester, \'pseqno\': courseno}\n\n    result = requests.post(url, data = post_var)\n\n    soup = bs4.BeautifulSoup(result.content, \'lxml\')\n    table = soup.find(\'table\', {\'class\': \'tbcls\'})\n    data = []\n    rows = table.find_all(\'tr\')\n    for row in rows:\n        cols = row.find_all(\'td\')\n        cols = [ele.text.strip() for ele in cols]\n        data.append([ele for ele in cols if ele]) # Get rid of empty values\n    output = ""\n    for i in data[2:]:\n        #print(i[0])\n        output +=i[0] + "\\n"\n    return output\n    #return  str(pselyr) + " + " +str(pseqno)\n\n# 即使在近端仍希望以 https 模式下執行\ncontext = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)\ncontext.load_cert_chain(\'localhost.crt\', \'localhost.key\')\n\n# 取 flaskapp.py 中的 uwsgi 變數設定\nuwsgi = False\nif uwsgi:\n    # 表示程式在雲端執行\n    application = app\nelse:\n    # 表示在近端執行, 以 python3 wsgi.py 執行\n    app.run(host=\'127.0.0.1\', port=5443, debug=True, ssl_context=context)\n \n nginx sites-available/default settings: \n server {\n    listen 8000;\n    server_name s1.mde.nfu.edu.tw;\n    charset utf-8;\n    \n    listen 7443 ssl;\n \n    location /static {\n        alias /home/kmol2019/course_studlist/static/;\n    }\n \n    location / {\n        include uwsgi_params;\n        uwsgi_pass  127.0.0.1:8087;\n    }\n    \n    ssl_certificate /etc/stunnel/localhost.crt;\n    ssl_certificate_key /etc/stunnel/localhost.key;\n    ssl_session_timeout 5m;\n    ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;\n    ssl_ciphers "HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES";\n    ssl_prefer_server_ciphers on;\n    try_files $uri $uri/ =404;\n} \n uwsgi7.ini \n [uwsgi]\nsocket = 127.0.0.1:8087\nuid = kmol2019\ngid = kmol2019\nplugins-dir = /usr/lib/uwsgi/plugins/\nplugin = python3\nmaster = true\nlogto = /var/log/uwsgi/emperor.log\nlogfile-chown = kmol2019:kmol2019\nprocesses = 4\nthreads = 2\nchdir = /home/kmol2019/course_studlist\nwsgi-file = /home/kmol2019/course_studlist/get_student.py \n /etc/systemd/system/cmsimfly.service \n [Unit]\nDescription=uWSGI to serve CMSimfly\nAfter=network.target\n\n[Service]\nUser=kmol2019\nGroup=kmol2019\nWorkingDirectory=/home/kmol2019/uwsgi_ini\nExecStart=/usr/local/bin/uwsgi --emperor /home/kmol2019/uwsgi_ini\n\n[Install]\nWantedBy=multi-user.target \n', 'tags': '', 'url': 'Grouping.html'}, {'title': '1a', 'text': 'wcmg1 組長: 40823131 40823126 40823123 40823124 40823128 \n wcmg2 組長: 40823112 40823108 40823109 40823111 40823145 \n wcmg3 組長: 40823125 40823129 40823137 40823136 40823151 \n wcmg4 組長:\xa040823110 40823103 40823107 40823130 40823142 \n wcmg5 組長:\xa040823143 40823144  40543118 40823127 \n HW: 已知選課名單:\xa0 http://s1.mde.nfu.edu.tw:8000/?semester=1082&courseno=0744 \n 請找出第五組的其他組員學號!!', 'tags': '', 'url': '1a.html'}, {'title': 'Topics', 'text': 'Portable programming system:\xa0 https://github.com/mdecourse/wcm2020/tree/master/downloads/portable \n WCM \n Login to your gm email account and download  2020wcm_topic_1.pdf . \n What is a content management system? \n Analyzing your information life cycle. \n Overview of enterprise content management. \n Git \n Login to your gm email account and download  IntroductionToVersionControlAndGit.pdf . \n What is version control? \n Git installation and setup. \n Git getting started. \n Commits and remote git. \n Github \n Login to your gm email account and download  GithubPrimer.pdf \n Login to your gm email account and download  ConflictsGUIToolAdvGit.pdf \n Python and Flask \n Login to your gm email account and download  2019_ABeginnersGuideToPython3Programming.pdf \n Login to your gm email account and download  2019_BuildingRESTAPIsWithFlask.pdf \n https://github.com/mstamy2/PyPDF2 \n Dart and Flutter \n Login to your gm email account and download   2020_ QuickStartGuideToDartProgramming.pdf \n Login to your gm email account and download   2019_BeginningAppDevelopmentWithFlutter.pdf \n', 'tags': '', 'url': 'Topics.html'}, {'title': 'Online Course', 'text': 'Google 因 COVID-19 疫情蔓延, 因此允許教育版的 Ｇ Suite 可以在 2020.9 月前免費使用 Meet 中的線上錄影與 live stream 功能. \n 而 Youtube Live 目前可以免費從 OBS 串流連接後直播, Ｍeet 的會議錄影將 mp4 存入發起開會者的 Google Drive, 而 Youtube live stream 則將影片存入使用者 channel 中的直播影片區. \n Google Handout Meet \n https://meet.google.com \xa0 \n Youtube Streaming  +  Portable OBS \n 現場直播的 audio 錄音設定 \n 在電腦輔助設計室進行直播時, 由於現場有擴音設備, 因此採用 OBS 串流至 Youtube 的最佳收音並非從 Webcam 的麥克風, 而是從擴音器以 audio output 連接到電腦的麥克風插槽, 然後將 OBS 的 audio 設定為從電腦的麥克風收音. \n W6 \n \n \n \n W7 \n \n \n \n W8 \n wcm w8 第一段錄影 \n wcm w8 第二段錄影 \n wcm w8 第三段錄影 \n 當使用 git 指令 push 時, Windows 跳出要求使用者登入 github 的帳號與密碼視窗時, 一旦在此視窗輸入帳號與密碼, Windows 會將此帳號密碼登錄在操作系統中. 為了達到使用可攜的目錄, 可以利用下列指令: \n git config --edit --system\xa0 \n 以 vi 編輯器將 credential -> helper 欄位刪除後存檔, 之後 git 便不會再要求 Windows 操作系統代存使用者的相關帳號與密碼. \n Python and Flask \n Login to your gm email account and download  2019_ABeginnersGuideToPython3Programming.pdf \n Login to your gm email account and download  2019_BuildingRESTAPIsWithFlask.pdf \n https://github.com/mstamy2/PyPDF2 \n https://mde.tw/cd2020pj1   \n W9 \n https://www.blog.pythonlibrary.org/2018/06/07/an-intro-to-pypdf2/   \n https://github.com/topics/pypdf2   \n https://flask.palletsprojects.com/en/1.1.x/patterns/fileuploads/   \n Flask 與 SQLite \n 目標 : 建立一個網際 PDF 檔案編修服務系統', 'tags': '', 'url': 'Online Course.html'}, {'title': 'MDETools', 'text': '這裡提供機械設計工程課程相關的工具下載與安裝步驟說明. \n SolidWorks 2017 DVD  下載 (請登入 ＠gm 帳號後下載) \n NX12.02 DVD  下載 (請登入 @gm 帳號後下載) \n COMSOL 5.5 DVD  下載 (請登入 @gm 帳號後下載) \n Ubuntu 20.04 Virtualbox  下載, 可用於 CMSiMDE, Oauth2 and CoppeliaSim RemoteAPI 開發 (請登入 @gm 帳號後下載) \n 安裝步驟請根據上課說明進行.', 'tags': '', 'url': 'MDETools.html'}, {'title': 'Virtualbox', 'text': '更改 win10_64_comsol5.5.vmdk 的 UUID \n "c:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe" internalcommands sethduuid win10_64_comsol5.5.vmdk \n', 'tags': '', 'url': 'Virtualbox.html'}, {'title': 'Ubuntu', 'text': '以下為建立 Ubuntu 20.04 虛擬主機, 用於網際內容管理, 電腦輔助設計實習與協同產品設計實習課程, 作爲區域網路或廣域網路伺服器主機課程練習之用. \n 由於每一台 Virtualbox 最多可以設定支援 36 片網路卡, 而且設定檔案可以透過程式方法控制各種設定, 因此適合用於上述課程中相關網際應用程式的部署使用, 也可以作為之後將網際程式配置到實體主機, 雲端主機或分散式版次管理系統 CI/CD 配置模擬. \n 請登入 ＠gm 帳號後下載  Ubuntu20.04_cd2020pj1.vdi  (11 GB, 用於 CMSiMDE, CoppeliaSim, Pyslvs, Range3, NGSolve, Jupyter 網際程式開發) \n 因為在 Virtualbox 中的每一個虛擬硬碟檔案, 都必須要有獨立的 UUID, 因此若複製虛擬硬碟檔案, 而且要在同一電腦上使用, 可以使用下列指令變更 UUID: \n "c:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe" internalcommands sethduuid registered_vdi.vdi \n Ubuntu Server (3GB) \n 登入 @gm 帳號後, 下載  ubuntu-20.04-live-server-amd64.iso \n 或從\xa0 https://ubuntu.com/download/server \xa0下載 Ubuntu Server 20.04 iso 檔案, 利用  Virtualbox  建立成虛擬主機檔案. \n 安裝 Graphical Environment (1GB) \n sudo apt install xorg \n 安裝 LXDE Window Manager (800 MB) \n sudo apt install lxde \n \xa0安裝 CMSiMDE 所需的 modules \n sudo pip3 install flask flask_cors lxml bs4 markdown pelican leo \n 安裝開發 Oauth2 所需模組 \n sudo pip3 install authomatic github3.py \n 安裝 CoppeliaSim \n 從  https://www.coppeliarobotics.com/ubuntuVersions \xa0 下載 edu Linux 版本, 解開壓縮檔案後, 透過 coppelia.sh 執行. \n 安裝 numpy, opencv-python 與 imutils 等 Python 3 模組, 用於影像辨識程式開發 \n sudo pip3 install numpy opencv-python imutils \n 編譯 Pyslvs-UI \n 編譯 Range3 \n git clone  https://github.com/Range-Software/range3.git \n cd range3 \n sudo ./scripts/prereqs_debian.sh \n ./scripts/build.sh --clean && ./scripts/create_package.sh \n 執行 \n cd build-Release/Range/ \n ./Range \n 修改所有用戶的指令搜尋路徑 \n 編輯 /etc/profile \n 加入 \n export PATH=/home/kmol2020/tmp/range3/build-Release/Range:PATH \n 之後 \n source /etc/profile \n 接下來只要輸入 Range 就可以開啟 Range3 \n 安裝 NGSolve \n sudo apt-add-repository universe sudo add-apt-repository ppa:ngsolve/ngsolve \n sudo apt-get update sudo apt-get install ngsolve', 'tags': '', 'url': 'Ubuntu.html'}, {'title': 'Netplan', 'text': '若在 Windows 10 中啟動 Virtualbox Ubuntu 20.04 則可將網路設為 Host Only, 不使用 DHCP, 而進入 Ubuntu 之後, 以 netplan 手動設定在 Windows 10 可以連線的區域網路. \n 例如: Windows Gateway 設為 192.168.56.1, 而 Host Only 虛擬主機設為 192.168.56.2 \n /etc/netplan/00-installer-config.yaml \n network:\n  version: 2\n  renderer: networkd\n  ethernets:\n    enp3s0:\n      dhcp6: true\n      addresses:\n        - 10.10.10.2/24\n      gateway4: 10.10.10.1\n      nameservers:\n          search: [mydomain, otherdomain]\n          addresses: [10.10.10.1, 1.1.1.1] \n', 'tags': '', 'url': 'Netplan.html'}, {'title': 'Dartpad', 'text': 'Notice: the\xa0 rate limits of Github Apps \n Github rate limits \n Gitlab rate limits setup \n  透過 getDart(dirname) 取位於 downloads/dart_ex/ 目錄中 dirname 目錄中的 Dart 程式碼  \n \n  取 Dart 程式的按鈕  \n https://mde.tw/wcm2020/downloads/dartpad/ \xa0 \n 純 Dart 程式 \n Hello   For Loop   Sum   Runge-Kutta   RK ex1   Mass Spring Damping   Function   Function Parameter   Fat Arrow   Temp 1 \n Html 程式 \n 亂數分組   ROC Flag   rot ROC   USA Flag   Grid   X-Y Plot   Slithery   Tetris \n Flutter 程式 \n Flutter0   Flutter1   Flutter2   Flutter3   Flutter4   Flutter Counter   ROC Flag   踩地雷 1   踩地雷 2   踩地雷 3   踩地雷 4   Dropdown   Multiselect   Search   Login   溫度轉換   Tic-Tac-Toe   Calculator   Mouse1   Paint1 \n  內建放入的 Dart 原始碼  \n 放大   回復 \n', 'tags': '', 'url': 'Dartpad.html'}, {'title': 'Project', 'text': 'Build an online pdf file manipulation system. \n pdf file upload \n pdf file split \n pdf file merge \n Build an online content management system. \n markdown editor \n markdown to LaTeX \n LaTeX to pdf \n References \n Pypdf2 examples: \n # pypdf2_ex1.py\nimport os\nfrom PyPDF2 import PdfFileWriter, PdfFileReader\n\npdfReader = PdfFileReader(open("2002_Book_Real-WorldASPNETBuildingAConte.pdf", "rb"))\ninformation = [("WhatIsCMS",18,45)]\n\nfor page in range(len(information)):\n    pdf_writer = PdfFileWriter()\n    start = information[page][1]\n    end = information[page][2]\n    while start<=end:\n        pdf_writer.addPage(pdfReader.getPage(start-1))\n        start+=1\n    if not os.path.exists("./"):\n        os.makedirs(savepath)\n    output_filename = \'{}_{}_page_{}.pdf\'.format(information[page][0],information[page][1], information[page][2])\n    with open(output_filename,\'wb\') as out:\n        pdf_writer.write(out)\n \n # pypdf2_ex2.py\nimport os\nfrom PyPDF2 import PdfFileWriter, PdfFileReader\n\npdfReader = PdfFileReader(open("Beginning-Git-and-GitHub.pdf", "rb"))\ninformation = [("GitAndGithub",17,105),("GitAndGithub",107,194),("GitAndGithub",196,289)]\n\nfor page in range(len(information)):\n    pdf_writer = PdfFileWriter()\n    start = information[page][1]\n    end = information[page][2]\n    while start<=end:\n        pdf_writer.addPage(pdfReader.getPage(start-1))\n        start+=1\n    if not os.path.exists("./"):\n        os.makedirs(savepath)\n    output_filename = \'{}_{}_page_{}.pdf\'.format(information[page][0],information[page][1], information[page][2])\n    with open(output_filename,\'wb\') as out:\n        pdf_writer.write(out)\n \n # pypdf2_ex3.py\n# merge several pdf files\nimport sys\nimport PyPDF2\n\npdf_write_object = PyPDF2.PdfFileWriter()\n\n#for i in sys.argv[1:]:\nfor i in ["WhatIsCMS.pdf","InforLifeCycle.pdf","EnterpriseContentManage.pdf"]:\n    pdf_read_object = PyPDF2.PdfFileReader(i)\n    print(\'processing file : \'+ i + \'number of pages : \' +  str(pdf_read_object.numPages))\n    for page in range(pdf_read_object.numPages):\n        pdf_write_object.addPage(pdf_read_object.getPage(page))\n\nfinal_file_object = open(\'2020CMS.pdf\', \'wb\')\npdf_write_object.write(final_file_object)\nfinal_file_object.close()\n \n Python: \n Learn to Program with Python 3 \n https://link.springer.com/book/10.1007/978-1-4842-3879-0 \n https://github.com/mstamy2/PyPDF2 \n Building REST APIs with Flask \n https://link.springer.com/book/10.1007/978-1-4842-5022-8 \n The Definitive Guide to SQLite \n https://link.springer.com/book/10.1007/978-1-4302-3226-1 \n \n Dart: \n Quick Start Guide to Dart Programming \n https://link.springer.com/book/10.1007/978-1-4842-5562-9 \n Practical Flutter \n https://link.springer.com/book/10.1007/978-1-4842-4972-7 \n Beginning App Development with Flutter \n https://link.springer.com/book/10.1007/978-1-4842-5181-2 \n Backend Framework in Dart: \n https://angel-dart.dev/ \n \n LaTeX, Markdown and Pandoc \n Login to your gm email account and download \n 2017_LaTeXIn24Hours.pdf \n 2014_PracticalLaTeX.pdf \n 2016_MoreMathIntoLaTeX.pdf \n 2019_IntroducingMarkdownAndPandoc.pdf \n https://pandoc.org/ \n https://yihui.org/tinytex/', 'tags': '', 'url': 'Project.html'}, {'title': 'Tools', 'text': 'W1:\xa0 https://github.com/mdecourse/wcm2020/blob/master/downloads/portable/wcm2020_w1.zip \xa019MB \n wcm2020_w2.7z \xa0325 MB\xa0 (登入 gm 後下載) \n msys64_201905_clean.7z  66MB\xa0 (登入 gm 後下載) \n wcm2020_w3.7z \xa0948 MB \xa0 (登入 gm 後下載) \xa0', 'tags': '', 'url': 'Tools.html'}, {'title': 'Python as backend', 'text': 'Web based PDF file manipulation system \n A Beginners Guide to Python 3 Programming \n https://link.springer.com/book/10.1007/978-3-030-20290-3 \n https://github.com/mstamy2/PyPDF2 \n Building REST APIs with Flask \n https://link.springer.com/book/10.1007/978-1-4842-5022-8 \n CMSiMDE (integrated with Pelican blog and Reveal.js) \n https://github.com/mdecourse/cmsimde \n Temp Conversion (Dart as frontend) \n http://mde.tw/cp2019/content/Temp%20Conv.html \n Pygrouf (linked with SQLite, MySQL and PostgreSQL) \n https://github.com/chiamingyen/pygrouf \n CP to CAD (deployment with\xa0 https://www.heroku.com/ ) \n https://github.com/mdecourse/wcms-scrum1 \n Web-based Laboratory 2020 \n based on  Creating Web-based Laboratories  (2004 with Matlab and Simulink)', 'tags': '', 'url': 'Python as backend.html'}, {'title': 'Dart as backend', 'text': 'Dart-Angel \n \n \n \n \n \n \n Aquenduct \n https://aqueduct.io/ \n', 'tags': '', 'url': 'Dart as backend.html'}, {'title': 'Threejs', 'text': 'Essential TypeScript \n https://link.springer.com/book/10.1007/978-1-4842-4979-6 \n https://github.com/threeDart/three.dart \n http://threedart.github.io/three.dart/ \n https://github.com/block-forest/threejs-dart-facade \n', 'tags': '', 'url': 'Threejs.html'}, {'title': 'WebVR', 'text': 'Learning Web-based Virtual Reality \n https://link.springer.com/book/10.1007/978-1-4842-2710-7 \n https://glitch.com/~fancy-python \n https://aframe.io/ \n https://www.roadtovr.com/4-steps-to-start-experimenting-with-webvr-in-10-minutes/ \n http://borismus.github.io/webvr-boilerplate/ \n https://skywell.software/blog/what-is-webvr-and-how-to-use-it/ \n Flutter and AR \n https://medium.com/flutterpub/flutter-and-ar-a65bb202c5d8 \n https://flatteredwithflutter.com/how-to-create-ar-in-flutter/ \n https://pub.dev/packages/arcore_flutter_plugin', 'tags': '', 'url': 'WebVR.html'}]};