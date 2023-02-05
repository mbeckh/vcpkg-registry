# Copyright (c) 2023 Michael Beckh
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

project("vcpkg-registry-test" VERSION 0.0.1 LANGUAGES NONE)

file(WRITE "${CMAKE_BINARY_DIR}/CMakeLists.txt" [[
cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

project("vcpkg-registry" VERSION 0.0.1
        DESCRIPTION "Project to use all vcpkg packages"
        HOMEPAGE_URL "https://github.com/mbeckh/vcpkg-registry"
        LANGUAGES CXX)
]])

if(vcpkg_ROOT)
    set(vcpkg_root -D "vcpkg_ROOT=${vcpkg_ROOT}")
endif()

if(CMAKE_TOOLCHAIN_FILE)
    set(toolchain_file -D "CMAKE_TOOLCHAIN_FILE:FILEPATH=${CMAKE_TOOLCHAIN_FILE}")
endif()

if(VCPKG_BINARY_SOURCES)
    string(REPLACE ";" "\\;" VCPKG_BINARY_SOURCES "${VCPKG_BINARY_SOURCES}")
    set(vcpkg_binary_sources -D "VCPKG_BINARY_SOURCES=${VCPKG_BINARY_SOURCES}")
endif()

enable_testing()

add_test(NAME "Create vcpkg manifest"
         COMMAND "${CMAKE_COMMAND}"
                 ${vcpkg_root}
                 -D "DIR=${CMAKE_BINARY_DIR}"
                 -P "${CMAKE_CURRENT_LIST_DIR}/vcpkg-manifest.cmake")
set_tests_properties("Create vcpkg manifest" PROPERTIES FIXTURES_SETUP "vcpkg_config")

add_test(NAME "Build ports"
         COMMAND "${CMAKE_COMMAND}"
                 -G Ninja
                 -D "BUILD_ROOT:FILEPATH=${BUILD_ROOT}"
                 ${toolchain_file}
                 -D "CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
                 -D "CMU_DISABLE_CLANG_TOOLS:BOOL=ON"
                 ${vcpkg_root}
                 ${vcpkg_binary_sources}
                 -S "${CMAKE_BINARY_DIR}" -B "${CMAKE_BINARY_DIR}/ports")
set_tests_properties("Build ports" PROPERTIES FIXTURES_REQUIRED "vcpkg_config")
