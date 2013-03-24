project(GLSL_GeneralProject)
cmake_minimum_required(VERSION 2.8)

include_directories("/home/vitor/glm-0.9.4.3/") #TODO: Change this hardcoded path

set(SOURCES
main.cpp
basic.vert
basic.frag
)

add_executable(${PROJECT_NAME} ${SOURCES})
target_link_libraries(${PROJECT_NAME} GLEW GL SDL SDL_image)

