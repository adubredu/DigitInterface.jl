module DigitInterface

wspath = joinpath(@__DIR__, "ros_lowlevel/sim/ws") 
llapipath = joinpath(wspath, "src/digit_llapi/libs/libartl")
run(`make -C $llapipath`)
wssource = joinpath(wspath, "devel/setup.bash")
run(`catkin_make -C $wspath`)
run(`bash -c 'source '$wssource''`)

using PythonCall
using WebSockets
using JSON
using Rotations

include("highlevel/hlcomms.jl")
include("compile.jl")
include("lowlevel/types.jl")
include("lowlevel/constants.jl")
include("lowlevel/utils.jl")
include("lowlevel/initialize.jl")
include("lowlevel/get.jl")
include("lowlevel/set.jl")

const Gripper = PythonCall.pynew()
#const LLComms = PythonCall.pynew()
const Camera = PythonCall.pynew()

function __init__() 
    packagepath = dirname(@__DIR__)
    gripperpath = joinpath(packagepath, "src/gripper")
    llcomspath = joinpath(packagepath, "src/ros_lowlevel") 
    camerapath = joinpath(packagepath, "src/camera")
    rospath = joinpath(llcomspath, "sim/ws/devel/lib/python2.7/dist-packages")
    sys = pyimport("sys")
    sys.path.append(gripperpath)
    #sys.path.append(llcomspath) 
    sys.path.append(rospath)
    sys.path.append(camerapath)
    PythonCall.pycopy!(Gripper, pyimport("gripper"))
    #PythonCall.pycopy!(LLComms, pyimport("ll_comms"))
    PythonCall.pycopy!(Camera, pyimport("pointcloud_server"))
end  

export Gripper,
        #LLComms,
        Camera,
        set_locomotion_mode,
        set_lowlevel_mode

export compile

export send_torque_command,
       get_generalized_coordinates

# lowlevel
# inits
export llapi_init,
       lapi_init_custom,  
       llapi_get_error_shutdown_delay, 
       llapi_connected,
       connect_to_robot

# types 
export llapi_observation_t,
       llapi_command_t,
       llapi_limits_t,
       motor_obs_t,
       llapi_motor_t

# getters 
# primary getters
export get_generalized_coordinates,
       get_generalized_coordinates2

# secondary getters
export  llapi_get_observation,
        get_motor_positions,
        get_motor_velocities,
        get_motor_torques,
        get_base_translation,
        get_base_orientation,
        get_base_linear_velocity,
        get_base_angular_velocity,
        get_imu_magnetic_field,
        get_imu_linear_acceleration,
        get_imu_angular_velocity,
        get_joint_positions,
        get_joint_velocities,
        get_torque_limits,
        get_damping_limits,
        get_velocity_limits

# setters
export send_command,
       llapi_send_command

# constants
export sim_ip,
	robot_ip

end # module
