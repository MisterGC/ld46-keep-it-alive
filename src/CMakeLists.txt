cmake_minimum_required (VERSION 3.5.0 FATAL_ERROR)
project (keeper-of-the-garden)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt5 COMPONENTS Core Quick REQUIRED)

add_executable (${PROJECT_NAME}
main.cpp
res.qrc
sound/sound.qrc
visual/visual.qrc
)

set_target_properties (${PROJECT_NAME} PROPERTIES
    CXX_STANDARD 11
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS NO
    )

target_link_libraries(${PROJECT_NAME}
PRIVATE
  Qt5::Core
  Qt5::Quick
)
