import io
import os
import sys
import random
from contextlib import redirect_stdout

def printcap(i):
    f = io.StringIO()
    with redirect_stdout(f):
        testerlist[i]()
    return f.getvalue()

def tester_1():
    ###1. 조건문과 반복문을 활용하여 1부터 10000까지의 3의 배수의 합, 개수, 평균을 출력하시오.
    sum3 = cnt3 = 0
    for i in range(10000):
        if i%3 == 0:
            sum3 += i
            cnt3 += 1
    print(sum3)
    print(cnt3)
    print(sum3/cnt3)
    return 0

def tester_2():
    ###2. 기본요금 20000원, 데이터요금 100원/MB일때 이번 달 사용한 데이터를 입력받아 최종 휴대폰 요금을 출력하시오.
    a = int(input())
    print(a * 100 + 20000)
    return 0

def tester_3():
    ###3. 월드컵은 4년에 한번 개최된다. 반복문을 사용하여 2002년부터 2080년까지 중 월드컵이 개최되는 연도를 출력하시오.
    for i in range(2002, 2081, 4):
        print(i)
    return 0

def tester_4():
    ###4. 세 실수를 입력받아 리스트에 저장한 후, 반복문을 이용하여 합과 평균을 출력하시오.
    lst = list(map(float,input().split()))
    sum3 = 0
    for i in range(3):
        sum3 += lst[i]
    print(sum3, sum3/3)
    return 0

def tester_5():
    ###5. 두 개의 양의 정수를 입력 받아 어떤 것이 작은 수인지 판별하여 작은 수를 출력하고, 그 작은 수가 홀수인지 짝수인지 출력하시오.
    ### 짝수면 "짝수" 홀수면 "홀수" 라고 출력하면 됩니다. 둘다 같은 수이면 어느 수이던 상관 없습니다.
    a, b = map(int, input().split())
    k = min(a, b)
    print(k, "홀수" if k%2 else "짝수")
    return 0

def tester_6():
    ###6. 학점이 4.0 이상이면 A, 3.0 이상이면 B, 2.0 이상이면 C, 그 이외이면 F를 부여하려 한다. 점수를 입력받은 후 어느 학점을 부여받게 되는지 출력하시오.
    Nun_gnyang_F_hackjumyeeya = float(input())
    if Nun_gnyang_F_hackjumyeeya >= 2:
        print(chr(max(69-int(Nun_gnyang_F_hackjumyeeya),65)))
    else:
        print("F")
    return 0

def tester_7():
    ###7. 두 양의 정수를 입력 받은 후 두 양의 정수 사이의 홀수의 개수는 몇개인지 출력하시오. 두 정수는 포함하지 않습니다.
    a, b = map(int, input().split())
    print((abs(a-b)-1)//2+(1 if not(a%2 and b%2) else 0))
    return 0

testerlist = [tester_1,tester_2,tester_3,tester_4,tester_5,tester_6,tester_7]
try:
    for i in range(7):
        if i==0:
            print(list(map(float,printcap(i).split()))==[16668333,3334,4999.5])
        elif i==1:
            for j in range(1000):
                sys.stdin = io.StringIO(str(j))
                if j*100+20000!=int(printcap(i)):
                    print(False)
                    break
            else:
                print(True)
        elif i==2:
            print(printcap(i).replace("\n","")=="20022006201020142018202220262030203420382042204620502054205820622066207020742078")
        elif i==3:
            for j in range(-100,100):
                sys.stdin = io.StringIO(str(j/10-5) + " " + str(j/10) + " " + str(j/10+1))
                t1,t2 = map(float,printcap(i).split())
                if round(t1,5) != round(j/10*3-4,5) or round(t2,5) != round((j/10*3-4)/3,5):
                    print(False)
                    break
            else:
                print(True)
        elif i==4:
            for j in range(100):
                a = random.randrange(1,1000)
                b = random.randrange(1,1000)
                sys.stdin = io.StringIO(str(a)+" "+str(b))
                t1, t2 = printcap(i).split()
                if int(t1) != min(a,b) or ("홀수"==t2) != bool(min(a,b)%2):
                    print(False)
                    break
            else:
                print(True)
        elif i==5:
            for j in range(50):
                n = j/10
                sys.stdin = io.StringIO(str(n))
                t = printcap(i).strip()
                if not((n>=2 and chr(max(69-int(n),65))==t) or (n<2 and t=="F")):
                    print(False)
                    break
            else:
                print(True)
        elif i==6:
            for j in range(100):
                a = random.randrange(1,1000)
                b = random.randrange(1,1000)
                sys.stdin = io.StringIO(str(a)+" "+str(b))
                t = int(printcap(i))
                if t != ((abs(a-b)-1)//2+(1 if not(a%2 and b%2) else 0)):
                    print(False)
                    break
            else:
                print(True)
except:
    print("에러")
finally:
    os.system("pause")
