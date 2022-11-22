using Revise
using DigitInterface

comms =  LLComms.Comms()

# for i=1:100
#     @time get_generalized_coordinates(comms)
# end


for i=1:100
    @time begin
        obs = comms.get_observation()
        DigitInterface.get_generalized_coordinates2(obs)
    end
end