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

mutable struct llapi_limits_t 
    torque_limit::NTuple{20, Cdouble}
    damping_limit::NTuple{20, Cdouble}
    velocity_limit::NTuple{20, Cdouble}
    llapi_limits_t() = new(Tuple(zeros(NUM_MOTORS)), Tuple(zeros(NUM_MOTORS)), Tuple(zeros(NUM_MOTORS)))
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

Base.@kwdef struct DIGIT_Q_COORD 
    qbase_pos_x::Int64 = 1 
    qbase_pos_y::Int64 = 2
    qbase_pos_z::Int64 = 3
    qbase_yaw::Int64 = 4
    qbase_pitch::Int64 = 5
    qbase_roll::Int64 = 6
    qleftHipRoll::Int64 = 7
    qleftHipYaw::Int64 = 8
    qleftHipPitch::Int64 = 9
    qleftKnee::Int64 = 10
    qleftKneeToShin::Int64 = 11
    qleftShinToTarsus::Int64 = 12
    qleftToePitch::Int64 = 13
    qleftToeRoll::Int64 = 14
    qleftShoulderRoll::Int64 = 15
    qleftShoulderPitch::Int64 = 16
    qleftShoulderYaw::Int64 = 17
    qleftElbow::Int64 = 18
    qrightHipRoll::Int64 = 19
    qrightHipYaw::Int64 = 20
    qrightHipPitch::Int64 = 21
    qrightKnee::Int64 = 22
    qrightKneeToShin::Int64 = 23
    qrightShinToTarsus::Int64 = 24
    qrightToePitch::Int64 = 25
    qrightToeRoll::Int64 = 26
    qrightShoulderRoll::Int64 = 27
    qrightShoulderPitch::Int64 = 28
    qrightShoulderYaw::Int64 = 29
    qrightElbow::Int64 = 30
end

qindex = DIGIT_Q_COORD()