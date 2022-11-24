cmake_minimum_required(VERSION 3.10.2)
project(LOWLEVELAPI)

include_directories("libartl")

set(CMAKE_POSITION_INDEPENDENT_CODE ON)


add_library(artl STATIC IMPORTED) 
add_library(lowlevelapi SHARED lowlevelapi.c)
set_property(TARGET artl PROPERTY IMPORTED_LOCATION "/home/alphonsus/research/projects/DigitInterface.jl/test/ccall_debug/libartl/libartl.a") 
target_link_libraries(lowlevelapi artl )

install(TARGETS
    lowlevelapi
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION lib)
