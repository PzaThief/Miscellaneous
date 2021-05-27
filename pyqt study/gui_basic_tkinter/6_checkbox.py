from tkinter import *

if __name__ == "__main__":
    root = Tk()
    root.title("Tkinter GUI")
    root.geometry("640x480")

    def btncmd():
        print(chkvar.get())

    chkvar = IntVar()
    checkbox = Checkbutton(root, text="sjdakfnkjasdn", variable=chkvar, command=btncmd)
    checkbox.pack()

    chkvar2 = IntVar()
    checkbox = Checkbutton(root, text="sjdakfnkjasdn", variable=chkvar2, command=btncmd)
    checkbox.pack()

    root.mainloop()