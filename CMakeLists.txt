cmake_minimum_required(VERSION 3.20)
project(c_pedal C)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

find_package(PkgConfig REQUIRED)
pkg_check_modules(ALSA REQUIRED IMPORTED_TARGET alsa)
pkg_check_modules(LILV REQUIRED IMPORTED_TARGET lilv-0)
pkg_check_modules(JSONC REQUIRED IMPORTED_TARGET json-c)

add_library(pedal_core STATIC src/dsp.c src/lv2.c)
target_include_directories(pedal_core PUBLIC include)
target_link_libraries(pedal_core PUBLIC PkgConfig::LILV m)
target_compile_options(pedal_core PRIVATE -Wall -Wextra -Wpedantic)

add_library(pedal_socket STATIC src/socket_client.c)
target_include_directories(pedal_socket PUBLIC include)
target_compile_options(pedal_socket PRIVATE -Wall -Wextra -Wpedantic)

add_executable(pedal-engine src/engine.c)
target_link_libraries(pedal-engine PRIVATE pedal_core PkgConfig::ALSA PkgConfig::JSONC)
add_executable(pedalctl src/control.c)
target_link_libraries(pedalctl PRIVATE pedal_socket)
add_executable(pedal-web src/web.c)
target_link_libraries(pedal-web PRIVATE pedal_socket PkgConfig::JSONC m)
add_executable(pedal-footswitch src/footswitch.c)
target_link_libraries(pedal-footswitch PRIVATE pedal_socket)
foreach(target pedal-engine pedalctl pedal-web pedal-footswitch)
    target_compile_options(${target} PRIVATE -Wall -Wextra -Wpedantic)
endforeach()

configure_file(web/index.html web/index.html COPYONLY)

include(CTest)
if(BUILD_TESTING)
    add_executable(pedal-core-test tests/test_core.c)
    target_link_libraries(pedal-core-test PRIVATE pedal_core)
    add_test(NAME pedal-core COMMAND pedal-core-test)
    add_test(NAME pedal-protocol COMMAND bash ${PROJECT_SOURCE_DIR}/tests/test_protocol.sh
        $<TARGET_FILE:pedal-engine> $<TARGET_FILE:pedalctl> $<TARGET_FILE:pedal-web>)
endif()

install(TARGETS pedal-engine pedalctl pedal-web pedal-footswitch RUNTIME DESTINATION bin)
install(FILES web/index.html DESTINATION share/c-pedal/web)
