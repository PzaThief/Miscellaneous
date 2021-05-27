from tkinter import *

if __name__ == "__main__":
    root = Tk()
    root.title("Tkinter GUI")
    root.geometry("640x480")

    label1 = Label(root, text="hi")
    label1.pack()

    photo = PhotoImage(file="gui_basic_tkinter/notitle.png")
    label2 = Label(root, image=photo)
    label2.pack()

    def change():
        label1.config(text="또 만나요")
        global photo2
        photo2 = PhotoImage(file="gui_basic_tkinter/notitle copy.png")
        label2.config(image=photo2)

    btn7 = Button(root, text="동작", command=change)
    btn7.pack()
    root.mainloop()