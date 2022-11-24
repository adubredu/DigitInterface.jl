using DigitInterface

device = Camera.Perception()
cloud = device.get_pointcloud()

# uncomment to print pointcloud data in terminal
# @show cloud