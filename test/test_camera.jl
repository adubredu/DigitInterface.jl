using Revise 
using DigitInterface

device = Camera.Perception()
@time cloud = device.get_pointcloud()

# @show cloud