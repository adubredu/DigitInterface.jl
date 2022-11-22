function compile_nodes()
    wspath = joinpath(@__DIR__, "ws") 
    wssource = joinpath(wspath, "devel/setup.bash")
    run(`catkin_make -C $wspath`)
    run(`bash -c 'source '$wssource''`)
end