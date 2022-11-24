using DigitInterface
 

if !@isdefined publisher_address
    publisher_address = sim_ip
    llapi_init(publisher_address)    
    observation = llapi_observation_t()
    command = llapi_command_t()  
    observation = llapi_observation_t()   
end

connect_to_robot(observation, command)  

q, qdot, qmotors = get_generalized_coordinates(observation)

# q => generalized positions 
# qdot => generalized velocities 
# qmotors => motor positions