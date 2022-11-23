#!/bin/bash
catkin_make -C ../ros_lowlevel/sim/ws
source ../ros_lowlevel/sim/ws/devel/setup.bash 
roslaunch perception pointcloud_server_launch.launch