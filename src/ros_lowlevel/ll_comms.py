import sys
sys.path.append("src/lowlevel/sim/ws/devel/lib/python2.7/dist-packages")
from digit_msgs.srv import *
import rospy 

class Comms:
    def __init__(self): 
        rospy.init_node("ll_comms") 
        rospy.wait_for_service("observation_service")  
        self.observation_channel = rospy.ServiceProxy("observation_service", Digit_Observation_srv)
        self.command_channel = rospy.ServiceProxy("command_service", Digit_Commands_srv)
        # self.velocity_command_channel = rospy.ServiceProxy("walker_server/walking_service", Digit_Walker_srv)
        # self.vel_req = Digit_Walker_srvRequest()
        self.cmd_req = Digit_Commands_srvRequest()

    def get_observation(self):
        # rospy.wait_for_service("observation_service") 
        # channel = rospy.ServiceProxy("observation_service", Digit_Observation_srv)
        resp = self.observation_channel()
        return resp.obs  
    
    def send_torque_command(self, fallback_opmode, apply_command, motor_torque, motor_velocity, motor_damping):
        # channel = rospy.ServiceProxy("command_service", Digit_Commands_srv)
        self.cmd_req.cmd.fallback_opmode = fallback_opmode
        self.cmd_req.cmd.apply_command = apply_command
        self.cmd_req.cmd.motor_torque = motor_torque
        self.cmd_req.cmd.motor_velocity = motor_velocity
        self.cmd_req.cmd.motor_damping = motor_damping
        response = self.command_channel(self.cmd_req)

    def send_velocity_command(self, vx, vy, w, obs):
        # channel = rospy.ServiceProxy("walker_server/walking_service", Digit_Walker_srv)
        # req = Digit_Walker_srvRequest()
        self.vel_req.target.ctrl_mode = "walking"
        self.vel_req.target.fp_type = ""
        self.vel_req.target.vel_x_des = vx
        self.vel_req.target.vel_y_des = vy
        self.vel_req.target.turn_rps = w
        self.vel_req.target.mass_inc = 0.0
        self.vel_req.target.zH_inc = 0.0
        self.vel_req.target.Ts_inc = 0.0
        self.vel_req.target.step_width_inc = 0.0
        self.vel_req.target.ufp_x_max_inc = 0.0
        self.vel_req.target.ufp_y_min_inc = 0.0
        self.vel_req.target.ufp_y_max_inc = 0.0
        self.vel_req.observation = obs
        response = self.velocity_command_channel(self.vel_req)
        command = response.cmd
        return command
    
    def transition_to_stand(self, obs):
        # channel = rospy.ServiceProxy("walker_server/walking_service", Digit_Walker_srv)
        # self.vel_req = Digit_Walker_srvRequest()
        self.vel_req.target.ctrl_mode = "standing_numeric"
        self.vel_req.target.fp_type = ""
        self.vel_req.target.vel_x_des = 0.0
        self.vel_req.target.vel_y_des = 0.0
        self.vel_req.target.turn_rps = 0.0
        self.vel_req.target.mass_inc = 0.0
        self.vel_req.target.zH_inc = 0.0
        self.vel_req.target.Ts_inc = 0.0
        self.vel_req.target.step_width_inc = 0.0
        self.vel_req.target.ufp_x_max_inc = 0.0
        self.vel_req.target.ufp_y_min_inc = 0.0
        self.vel_req.target.ufp_y_max_inc = 0.0
        self.vel_req.observation = obs
        response = self.velocity_command_channel(self.vel_req)
        command = response.cmd
        return command
    
    def get_tag_positions(self):
        channel = rospy.ServiceProxy("tag_service", Tag_Server_srv)
        resp = channel()
        return resp.tag_array

