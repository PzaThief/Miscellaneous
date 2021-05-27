from tkinter import *

if __name__ == "__main__":
    root = Tk()
    root.title("Tkinter GUI")
    root.geometry("640x480")

    txt = Text(root, width=30, height=30)
    txt.pack()

    txt.insert(END, "글자를 입력하세요")

    e = Entry(root, width=30)
    e.insert(0, "한줄")
    e.pack()

    def btncmd():
        print(txt.get("1.0", END))
        print(e.get())

        txt.delete("1.0", END)
        e.delete(0, END)

    btn7 = Button(root, text="동작", command=btncmd)
    btn7.pack()

    root.mainloop()