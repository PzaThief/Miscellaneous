from tkinter import *

if __name__ == "__main__":
    root = Tk()
    root.title("Tkinter GUI")
    root.geometry("640x480")

    listbox = Listbox(root, selectmode="extended", height=0)
    listbox.insert(0, "사과")
    listbox.insert(1, "딸기")
    listbox.insert(END, "끝")
    listbox.pack()

    def btncmd():
        if listbox.curselection():
            listbox.delete(listbox.curselection())

    btn7 = Button(root, text="동작", command=btncmd)
    btn7.pack()

    root.mainloop()