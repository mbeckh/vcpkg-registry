# Copyright 2023 Michael Beckh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

project("vcpkg-registry-test" VERSION 0.0.1 LANGUAGES NONE)

file(WRITE "${CMAKE_BINARY_DIR}/CMakeLists.txt" [[
cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

project("vcpkg-registry" VERSION 0.0.1
        DESCRIPTION "Project to use all vcpkg packages"
        HOMEPAGE_URL "https://github.com/mbeckh/vcpkg-registry"
        LANGUAGES CXX)
]])

enable_testing()

add_test(NAME "Create vcpkg manifest"
         COMMAND "${CMAKE_COMMAND}"
                 -D "DIR=${CMAKE_BINARY_DIR}"
                 -P "${CMAKE_CURRENT_LIST_DIR}/vcpkg-manifest.cmake")
set_tests_properties("Create vcpkg manifest" PROPERTIES FIXTURES_SETUP "vcpkg_config")

if(CMAKE_TOOLCHAIN_FILE)
    set(toolchain_file -D "CMAKE_TOOLCHAIN_FILE:FILEPATH=${CMAKE_TOOLCHAIN_FILE}")
endif()

if(VCPKG_BINARY_SOURCES)
    list(APPEND vcpkg_binary_sources -D "${VCPKG_BINARY_SOURCES}")
endif()

add_test(NAME "Build ports"
         COMMAND "${CMAKE_COMMAND}"
                 -G Ninja
                 -D "BUILD_ROOT:FILEPATH=${BUILD_ROOT}"
                 ${toolchain_file}
                 -D "CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
                 -D "CMU_DISABLE_CLANG_TOOLS:BOOL=ON"
                 ${vcpkg_binary_sources}
                 -S "${CMAKE_BINARY_DIR}" -B "${CMAKE_BINARY_DIR}/ports")
set_tests_properties("Build ports" PROPERTIES FIXTURES_REQUIRED "vcpkg_config")
