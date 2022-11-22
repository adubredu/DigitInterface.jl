cmake_minimum_required(VERSION 3.0.2)
project(perception)
 
find_package(catkin REQUIRED COMPONENTS
  message_generation
  realsense2_camera
  roscpp
  rospy
  sensor_msgs
  std_msgs
  tf
)
  
add_service_files(
  FILES
  PointCloud_srv.srv 
)

## Generate added messages and services with any dependencies listed here
generate_messages(
  DEPENDENCIES
  sensor_msgs#   std_msgs
)
 
catkin_package(
 INCLUDE_DIRS include
 LIBRARIES perception
 CATKIN_DEPENDS realsense2_camera roscpp rospy sensor_msgs std_msgs tf
#  DEPENDS system_lib
)

###########
## Build ##
########### 
include_directories(
  include
  ${catkin_INCLUDE_DIRS}
)
 
add_executable(pointcloud_server 
          src/pointcloud_server.cpp) 
target_link_libraries(pointcloud_server
  ${catkin_LIBRARIES}
)
