import serial
from tkinter import * 
from tkinter.ttk import *
from time import strftime


# importing whole module
from tkinter import *
from tkinter.ttk import *
 
# importing strftime function to
# retrieve system's time
from time import strftime
 
# creating tkinter window
root = Tk()
root.title('Clock')
  
def time():
    string = strftime(gg)
    lbl.config(text=string)
    lbl.after(1000, time)
 
lbl = Label(root, font=('calibri', 40, 'bold'),background='purple',foreground='white')

serialPort = serial.Serial(port = "COM1", baudrate=115200,bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)
serialString = ""

while(1):
     if(serialPort.in_waiting > 0):        
        serialString = serialPort.readline()
        gg = serialString.decode('Ascii')
        print('ampi')
        print(gg)
        lbl.pack(anchor='center')
        time()
        root.update()

root.mainloop()        
        


    


        
    

