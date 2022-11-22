from perception.srv import *
import rospy

class Perception:
    def __init__(self):
        rospy.init_node("perception_node")
        rospy.wait_for_service("cloud_service")
        self.pointcloud_channel = rospy.ServiceProxy("cloud_service", PointCloud_srv)
    
    def get_pointcloud(self):
        resp = self.pointcloud_channel()
        return resp.cloud
    