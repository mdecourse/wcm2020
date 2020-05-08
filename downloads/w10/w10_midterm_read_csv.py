import csv

# read student list

filename = 'E:/wcm2020/data/tmp/2020_spring_score/2a/2a_list.txt'
with open(filename, encoding="utf-8") as f:
    content = f.readlines()
#print(content)
student = [x.strip() for x in content] 
#print(student)


# Timestamp, email, 修課名稱, url, score, desp, memo
# 0, 1, 2, 3, 4, 5, 6
#total = 0
all = {}
with open('y:/2020midterm.csv', encoding="utf-8") as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    #print(csv_reader)

    line_count = 0
    for row in csv_reader:
        if line_count == 0:
            #print(f'Column names are {", ".join(row)}')
            line_count += 1
        else:
            student_num = row[1].split("@")[0]
            #print(student_num)
            student_score = row[4]
            #print(student_score)
            try:
                all.update({student_num: student_score})
            except:
                all.update({student_num: "error"})
            #print(f'\t{row[0]} works in the {row[1]} department, and was born in {row[2]}.')
            #print(f'\t{row[4]}')
            #total += int(row[4])
            line_count += 1
#print(all)
#print(student)


for i in student:
    
    #if i in all:
        #pass
    #else:
        #print(str(i))
    
    try:
        print(i + "\t" + all[i])
    except:
        print(i + "\t60")

    #print(f'Processed {line_count} lines.')
    #print("平均=" + str(total/line_count))
