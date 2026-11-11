cmake_minimum_required(VERSION 3.20)
project(pedal_lvgl_ui C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

include(FetchContent)
set(LV_CONF_SKIP ON CACHE BOOL "Use LVGL defaults with desktop overrides" FORCE)
set(CONFIG_LV_BUILD_DEMOS OFF CACHE BOOL "" FORCE)
set(CONFIG_LV_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(CONFIG_LV_USE_THORVG OFF CACHE BOOL "" FORCE)
set(CONFIG_LV_USE_SDL ON CACHE BOOL "" FORCE)
add_compile_definitions(
    LV_USE_SDL=1
    LV_FONT_MONTSERRAT_20=1
    LV_FONT_MONTSERRAT_18=1
    LV_FONT_MONTSERRAT_16=1
    LV_FONT_MONTSERRAT_28=1
    LV_FONT_MONTSERRAT_36=1
)

FetchContent_Declare(lvgl
    GIT_REPOSITORY https://github.com/lvgl/lvgl.git
    GIT_TAG v9.6.0
    GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(lvgl)

find_package(SDL2 REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_check_modules(JSONC REQUIRED IMPORTED_TARGET json-c)
pkg_check_modules(ALSA REQUIRED IMPORTED_TARGET alsa)

add_executable(pedal-lvgl main.c ../src/audio_settings.c)
target_include_directories(pedal-lvgl PRIVATE ../include)
target_link_libraries(pedal-lvgl PRIVATE lvgl::lvgl SDL2::SDL2 PkgConfig::JSONC PkgConfig::ALSA m)
target_compile_options(pedal-lvgl PRIVATE -Wall -Wextra -Wpedantic)
