import serial 
import time

class Gripper:
    def __init__(self): 
        self.buffer=1

    def set_serial_port(self, port):
        port = str(port)
        self.ser = serial.Serial(port)

    def open_left_gripper(self): 
        self.ser.write(b'1000') 

    def close_left_gripper(self): 
        self.ser.write(b'3000') 

    def close_right_gripper(self): 
        self.ser.write(b'2000') 
    
    def open_right_gripper(self): 
        self.ser.write(b'4000') 

    def rotate_wrist(self, angle):
        angle = str(angle) 
        self.ser.write(bytes(angle, 'utf-8')) 