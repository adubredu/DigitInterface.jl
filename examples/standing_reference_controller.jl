using DigitInterface

# reference motor positions
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

# PD parameters
  Kp = 1050.0
  Kd = 0.5

# connection parameters
# replace sim_ip with robot_ip to connect to physical Digit
if !@isdefined publisher_address
    publisher_address = sim_ip
    llapi_init(publisher_address)    
    observation = llapi_observation_t()
    command = llapi_command_t()  
    observation = llapi_observation_t() 
    command.apply_command = false 
end

# connecting to digit
connect_to_robot(observation, command) 
limits = get_damping_limits()
 
# run controller for 10e5 iterations
for i=1:10e5
    _, _, qmotors = get_generalized_coordinates(observation)

    torques, velocities, dampings = Float64[], Float64[], Float64[]
    
    for i=1:DigitInterface.NUM_MOTORS
        push!(torques, Kp * (ref[i]-qmotors[i]))
        push!(velocities, 0.0)
        push!(dampings, Kd * limits[i])
    end

    fallback_opmode = DigitInterface.Locomotion
    apply_command = true
     send_command(torques, velocities, dampings, fallback_opmode,
        apply_command)  
    sleep(1e-6)  
end
 
    
