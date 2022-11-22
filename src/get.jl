function quat_to_rpy(q::Vector{Float64})
    quat = QuatRotation(q)
    zyx = RotZYX(quat)
    ypr = [zyx.theta1, zyx.theta2, zyx.theta3]
    return ypr
end 

function convert_to_euler_rates(quat, ω)
    R = RotMatrix(QuatRotation(quat...))
    t2 = R[1]^2
    t3 = R[2]^2
    t4 = R[6]^2
    t5 = R[9]^2
    t6 = t2 + t3
    t7 = 1.0 / t6
    yaw_dot = -R[2] * t7 * (R[4] * ω[3] - R[7] * ω[2]) + R[1] * t7 * (R[5] * ω[3] - R[8] * ω[2])
    pitch_dot = -1.0 / sqrt(-R[3]^2 + 1.0) * (R[6] * ω[3] - R[9] * ω[2])
    roll_dot = (t4 * ω[1] + t5 * ω[1] - R[3] * R[6] * ω[2] - R[3] * R[9] * ω[3]) / (t4 + t5)

    return [yaw_dot, pitch_dot, roll_dot]
end

function get_generalized_coordinates(comms) 
    observation = comms.get_observation()
    q_pos = [pyconvert(Float64, q) for q in [observation.base_translation...]]
    qdot_pos = [pyconvert(Float64, q) for q in[observation.base_linear_velocity...]] 
    q_angvel = [pyconvert(Float64, q) for q in [observation.base_angular_velocity...]] 
    quat = [pyconvert(Float64, observation.base_orientation.w), 
            pyconvert(Float64, observation.base_orientation.x), 
            pyconvert(Float64, observation.base_orientation.y), 
            pyconvert(Float64, observation.base_orientation.z)]  

    q_joints = [pyconvert(Float64, q) for q in [observation.joint_position...]]
    q_motors = [pyconvert(Float64, q) for q in [observation.motor_position...]] 
    qdot_joints = [pyconvert(Float64, q) for q in [observation.joint_velocity...]]
    qdot_motors = [pyconvert(Float64, q) for q in [observation.motor_velocity...]]

    q_euler = quat_to_rpy(quat)
    qdot_euler = convert_to_euler_rates(quat, q_angvel) 

    Rz = RotZ(q_euler[1])
    qdot_pos = Rz * qdot_pos

    q_base = [q_pos..., q_euler...]
    qdot_base = [qdot_pos..., qdot_euler...]

    q_leg_left = [q_motors[LeftHipRoll],
                  q_motors[LeftHipYaw],
                  q_motors[LeftHipPitch],
                  q_motors[LeftKnee],
                  q_joints[LeftShin],
                  q_joints[LeftTarsus],
                  q_joints[LeftToePitch],
                  q_joints[LeftToeRoll]]
    qdot_leg_left = [qdot_motors[LeftHipRoll],
                  qdot_motors[LeftHipYaw],
                  qdot_motors[LeftHipPitch],
                  qdot_motors[LeftKnee],
                  qdot_joints[LeftShin],
                  qdot_joints[LeftTarsus],
                  qdot_joints[LeftToePitch],
                  qdot_joints[LeftToeRoll]]
    q_leg_right = [q_motors[RightHipRoll],
                  q_motors[RightHipYaw],
                  q_motors[RightHipPitch],
                  q_motors[RightKnee],
                  q_joints[RightShin],
                  q_joints[RightTarsus],
                  q_joints[RightToePitch],
                  q_joints[RightToeRoll]]
    qdot_leg_right = [qdot_motors[RightHipRoll],
                  qdot_motors[RightHipYaw],
                  qdot_motors[RightHipPitch],
                  qdot_motors[RightKnee],
                  qdot_joints[RightShin],
                  qdot_joints[RightTarsus],
                  qdot_joints[RightToePitch],
                  qdot_joints[RightToeRoll]]
    
    q_arm_left = [q_motors[LeftShoulderRoll],
                  q_motors[LeftShoulderPitch],
                  q_motors[LeftShoulderYaw],
                  q_motors[LeftElbow]]
    qdot_arm_left = [qdot_motors[LeftShoulderRoll],
                  qdot_motors[LeftShoulderPitch],
                  qdot_motors[LeftShoulderYaw],
                  qdot_motors[LeftElbow]]
    q_arm_right = [q_motors[RightShoulderRoll],
                   q_motors[RightShoulderPitch],
                   q_motors[RightShoulderYaw],
                   q_motors[RightElbow]]
    qdot_arm_right = [qdot_motors[RightShoulderRoll],
                      qdot_motors[RightShoulderPitch],
                      qdot_motors[RightShoulderYaw],
                      qdot_motors[RightElbow]]
    
    q_body = [q_leg_left..., q_arm_left..., q_leg_right..., q_arm_right...]
    qdot_body = [qdot_leg_left..., qdot_arm_left..., qdot_leg_right..., qdot_arm_right...]

    q_all = [q_base..., q_body...]
    qdot_all = [qdot_base..., qdot_body...]

    return (q_all, qdot_all, q_motors)
end

