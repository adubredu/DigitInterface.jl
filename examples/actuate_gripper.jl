using DigitInterface

gripper = Gripper.Gripper()

# may have to change this depending on 
# your gripper's serial port address
serial_port = "/dev/ttyUSB0"

# set the gripper's serial port
gripper.set_serial_port(serial_port)

# open the gripper on Digit's right wrist
gripper.open_right_gripper()

# close the gripper on Digit's right wrist
gripper.close_right_gripper()

# open the gripper on Digit's left wrist
gripper.open_left_gripper()

# close the gripper on Digit's left wrist
gripper.close_left_gripper()