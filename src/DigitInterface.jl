module DigitInterface

using PythonCall
using WebSockets
using JSON
using Rotations

include("lowlevel/constants.jl")
include("highlevel/hlcomms.jl")
include("compile.jl")
include("get.jl")
include("set.jl")

const Gripper = PythonCall.pynew()
const LLComms = PythonCall.pynew()
const Camera = PythonCall.pynew()

function __init__() 
    packagepath = dirname(@__DIR__)
    gripperpath = joinpath(packagepath, "src/lowlevel")
    llcomspath = joinpath(packagepath, "src/lowlevel") 
    camerapath = joinpath(packagepath, "src/camera")
    rospath = joinpath(llcomspath, "sim/ws/devel/lib/python2.7/dist-packages")
    sys = pyimport("sys")
    sys.path.append(gripperpath)
    sys.path.append(llcomspath) 
    sys.path.append(rospath)
    sys.path.append(camerapath)
    PythonCall.pycopy!(Gripper, pyimport("gripper"))
    PythonCall.pycopy!(LLComms, pyimport("ll_comms"))
    PythonCall.pycopy!(Camera, pyimport("pointcloud_server"))
end  

export Gripper,
        LLComms,
        Camera,
        set_locomotion_mode,
        set_lowlevel_mode

export compile

export send_torque_command,
       get_generalized_coordinates

# llcomms = LLComms.Comms()
# export llcomms

end
