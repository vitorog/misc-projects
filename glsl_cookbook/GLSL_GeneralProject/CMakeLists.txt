project(GLSL_GeneralProject)
cmake_minimum_required(VERSION 2.8)

set(SOURCES
main.cpp
basic.vert
)

add_executable(${PROJECT_NAME} ${SOURCES})
target_link_libraries(${PROJECT_NAME} GLEW GL SDL SDL_image)

