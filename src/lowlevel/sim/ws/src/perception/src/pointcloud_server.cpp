#include <string>
#include <iostream>

#include "ros/ros.h"
#include "sensor_msgs/PointCloud2.h"
#include "perception/PointCloud_srv.h"

sensor_msgs::PointCloud2 cloud;

void pointcloud_callback(const sensor_msgs::PointCloud2ConstPtr& input)
{
    cloud = *input;
}

bool cloud_server(perception::PointCloud_srv::Request &req, 
                            perception::PointCloud_srv::Response &res)
{
    res.cloud = cloud;
    return true;
}


int main(int argc, char* argv[])
{
    ros::init(argc, argv, "pointcloud_server_node");
    ros::NodeHandle n;
    ros::Subscriber sub = n.subscribe("/camera/depth/color/points", 1, pointcloud_callback);
    ros::ServiceServer cloud_service = n.advertiseService("cloud_service", cloud_server);
    ROS_INFO("Cloud server is ready");
    ros::spin();
    return EXIT_SUCCESS;
}