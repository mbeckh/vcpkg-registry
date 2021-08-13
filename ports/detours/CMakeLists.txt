cmake_minimum_required(VERSION 3.19 FATAL_ERROR)

project(detours LANGUAGES CXX)

find_file(header_file "detours.h" PATHS "${CMAKE_CURRENT_SOURCE_DIR}/src" REQUIRED NO_DEFAULT_PATH)
if(header_file)
    file(READ "${header_file}" detours_h)
    if(detours_h MATCHES "DETOURS_VERSION[ ]+0x([0-9a-f]+)c([0-9a-f]+)c([0-9a-f]+)")
        math(EXPR major_version "0x${CMAKE_MATCH_1}")
        math(EXPR minor_version "0x${CMAKE_MATCH_2}")
        math(EXPR patch_version "0x${CMAKE_MATCH_3}")
        set(version "${major_version}.${minor_version}.${patch_version}")
        unset(major_version)
        unset(minor_version)
        unset(patch_version)
    endif()
endif()
unset(header_file)

add_library(detours STATIC
    src/creatwth.cpp
    src/detours.cpp
    src/detours.h
    src/detver.h
    src/disasm.cpp
    src/disolarm.cpp
    src/disolarm64.cpp
    src/disolia64.cpp
    src/disolx64.cpp
    src/disolx86.cpp
    src/image.cpp
    src/modules.cpp
    src/uimports.cpp
 )

 set_property(SOURCE src/uimports.cpp APPEND PROPERTY HEADER_FILE_ONLY TRUE)

 set_target_properties(detours PROPERTIES
    COMPILE_PDB_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    COMPILE_PDB_NAME "detours"
    COMPILE_PDB_NAME_DEBUG "detoursd"
    VERSION "${version}" SOVERSION "${major_version}"
    DEBUG_POSTFIX "d")

if(MSVC)
	target_compile_options(detours PRIVATE /W4 /WX /we4777 /we4800 /Gy /Od)
endif()
target_compile_definitions(detours PRIVATE $<$<CONFIG:DEBUG>:DETOUR_DEBUG=0> WIN32_LEAN_AND_MEAN _WIN32_WINNT=0x501)

target_include_directories(detours
    PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>" "$<INSTALL_INTERFACE:include>")


include(CMakePackageConfigHelpers)

configure_package_config_file("detours-config.cmake.in" "detours-config.cmake"
    INSTALL_DESTINATION "share/detours")

write_basic_package_version_file("detours-config-version.cmake"
    VERSION "${version}" COMPATIBILITY SameMajorVersion)


install(TARGETS detours
        EXPORT detours-targets
        RUNTIME
        LIBRARY
        ARCHIVE)

install(FILES src/detours.h src/detver.h
        TYPE INCLUDE)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/detours-config.cmake" "${CMAKE_CURRENT_BINARY_DIR}/detours-config-version.cmake"
        DESTINATION "share/detours")

install(EXPORT detours-targets
        DESTINATION "share/detours" NAMESPACE "detours::")
