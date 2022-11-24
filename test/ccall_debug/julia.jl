const ll = "test/ccall_debug/build/liblowlevelapi.so"
NUM_JOINTS = 10
NUM_MOTORS = 20
struct llapi_quaternion_t
    w::Cdouble
    x::Cdouble
    y::Cdouble 
    z::Cdouble 
    llapi_quaternion_t() = new(0.0, 0.0, 0.0, 0.0)
end

struct motor_obs_t 
    position::NTuple{20, Cdouble}
    velocity::NTuple{20, Cdouble}
    torque::NTuple{20, Cdouble}
    motor_obs_t() = new(zeros(20), zeros(20), zeros(20))
end

struct BaseLink 
    translation::NTuple{3, Cdouble}
    orientation::llapi_quaternion_t
    linear_velocity::NTuple{3, Cdouble}
    angular_velocity::NTuple{3, Cdouble}
    BaseLink() = new((0.0, 0.0, 0.0), llapi_quaternion_t(), (0.0, 0.0, 0.0), (0.0, 0.0, 0.0))
end 

struct Imu 
    orientation::llapi_quaternion_t
    angular_velocity::NTuple{3, Cdouble}
    linear_acceleration::NTuple{3, Cdouble}
    magnetic_field::NTuple{3, Cdouble}
    Imu() = new(llapi_quaternion_t(), (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), (0.0, 0.0, 0.0))
end

struct Motor 
    position::NTuple{20, Cdouble}
    velocity::NTuple{20, Cdouble}
    torque::NTuple{20, Cdouble}
    Motor() = new(Tuple(zeros(NUM_MOTORS)), Tuple(zeros(NUM_MOTORS)), Tuple(zeros(NUM_MOTORS)))
end

struct Joint 
    position::NTuple{10, Cdouble}
    velocity::NTuple{10, Cdouble}
    Joint() = new(Tuple(zeros(NUM_JOINTS)), Tuple(zeros(NUM_JOINTS)))
end

mutable struct llapi_observation_t 
    time::Cdouble 
    error::Bool 
    base::BaseLink 
    imu::Imu 
    motor::Motor 
    joint::Joint 
    battery_charge::Cint
    llapi_observation_t() = new(0.0, false, BaseLink(), Imu(), Motor(), Joint(), 0)
end

struct llapi_motor_t
    torque::Cdouble 
    velocity::Cdouble 
    damping::Cdouble 
    llapi_motor_t() = new(0.0, 0.0, 0.0)
    llapi_motor_t(t, v, d) = new(t, v, d)
end

struct llapi_command_t 
    motors::NTuple{20, llapi_motor_t} 
    fallback_opmode::Cint 
    apply_command::Bool 
    llapi_command_t() = new(Tuple([llapi_motor_t() for i=1:NUM_MOTORS]), 3, false)
    llapi_command_t(m, f, a) = new(m, f, a)
end

function llapi_get_observation(obs::Ref{llapi_observation_t})
    t = @ccall ll.llapi_get_observation(obs::Ref{llapi_observation_t})::Cint 
    return t 
end

function llapi_init(pub_addr::String)
    @ccall ll.llapi_init(pub_addr::Cstring)::Cvoid
end

function llapi_send_command(cmd::Ref{llapi_command_t})
    @ccall ll.llapi_send_command(cmd::Ref{llapi_command_t})::Cvoid 
end

function connect_to_robot(observation, command)
    val = 0
    printstyled("connecting...\n"; color=:blue)
    while !(val == 1) 
        val = llapi_get_observation(Ref(observation)) 
        llapi_send_command(Ref(command))  
    end
    printstyled("connected"; color=:green)
end

function get_damping_limits()
    val = @ccall ll.get_damping_limits()::Ptr{Cdouble}
    return unsafe_wrap(Array, val, NUM_MOTORS) 
end

#=
# observation 


if !@isdefined publisher_address
    publisher_address = "127.0.0.1"
    llapi_init(publisher_address)    
    observation = llapi_observation_t()
    command = llapi_command_t()  
    observation = llapi_observation_t() 
    # command.apply_command = false 
    # connect_to_robot(observation, command)  
end
connect_to_robot(observation, command)  
for i=1:100
    val = llapi_get_observation(Ref(observation)) 
    trans = observation.base.translation
    @show val, trans
end
=#

# standing controller
ref = [0.32869133647921467, 
        -0.02792180592249217, 
        0.3187324455828634, 
        0.36118057019763633, 
        -0.14684031092035302, 
        0.11311574329868718, 
        -0.32875125760374146, 
        0.02783743697915846, 
        -0.31868450868324194, 
        -0.3611086648482042, 
        0.14674060216914045, 
        -0.11315409281838432, 
        -0.15050988058637318, 
        1.0921200187801636, 
        0.00017832526659170586, 
        -0.13909131109654943, 
        0.15051467427633533, 
        -1.0921631619898227, 
        -0.00017832526659170586, 
        0.13910089847647372]

  
  Kp = 1050.0
  Kd = 0.5

    if !@isdefined publisher_address
        publisher_address = "127.0.0.1"
        llapi_init(publisher_address)    
        observation = llapi_observation_t()
        command = llapi_command_t()  
        observation = llapi_observation_t()  
    end
connect_to_robot(observation, command) 
limits = get_damping_limits()

# set_lowlevel_mode()
for i=1:10e5
    # q, qdot, qmotors = get_generalized_coordinates(Ref(observation))
    val = llapi_get_observation(Ref(observation))
    qmotors = observation.motor.position
    torques, velocities, dampings = Float64[], Float64[], Float64[]
    for i=1:NUM_MOTORS
        push!(torques, Kp * (ref[i]-qmotors[i]))
        push!(velocities, 0.0)
        push!(dampings, Kd * limits[i])
    end
    fallback_opmode = 3
    apply_command = true

    motors = Tuple([llapi_motor_t(t, v, d) for (t, v, d) in zip(torques, velocities, dampings)])
    cmd = llapi_command_t(motors, fallback_opmode, apply_command)
    llapi_send_command(Ref(cmd))
    println("running")
    sleep(1e-6)
end

