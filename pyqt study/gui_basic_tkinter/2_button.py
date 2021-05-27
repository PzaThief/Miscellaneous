from tkinter import *

if __name__ == "__main__":
    root = Tk()
    root.title("Tkinter GUI")
    root.geometry("640x480")
    btn1 = Button(root, text="버튼1")
    btn1.pack()

    btn2 = Button(root, text="버튼222222222")
    btn2.pack()
    btn3 = Button(root, padx=50, pady=10, text="버튼3")
    btn3.pack()
    btn3 = Button(root, width=50, height=10, text="버튼3")
    btn3.pack()
    photo = PhotoImage(file="gui_basic_tkinter/notitle.png")
    btn6 = Button(root, image=photo)
    btn6.pack()

    def btncmd():
        print("클릭")

    btn7 = Button(root, text="동작", command=btncmd)
    btn7.pack()

    root.mainloop()