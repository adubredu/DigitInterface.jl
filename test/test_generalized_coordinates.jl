using Revise
using DigitInterface

#=
comms =  LLComms.Comms() 

for i=1:100
    @time begin
        obs = comms.get_observation()
        DigitInterface.get_generalized_coordinates2(obs)
    end
end
=#

if !@isdefined publisher_address
    publisher_address = sim_ip
    llapi_init(publisher_address)    
    observation = llapi_observation_t()
    command = llapi_command_t()  
    observation = llapi_observation_t() 
    command.apply_command = false 
    # connect_to_robot(observation, command)  
end
connect_to_robot(observation, command)  
for i=1:100
    @time begin
        q, qdot, qmotors = get_generalized_coordinates(Ref(observation))
    end
    @show q[1]
end