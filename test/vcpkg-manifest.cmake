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

#
# Create vcpkg.json for current repositry. IF VCPKG_ROOT is not provided,
# environment variables VCPKG_ROOT and VCPKG_INSTALLATION_ROOT are checked.
# Usage: cmake
#        [ -D DIR=<path> ]
#        [ -D vcpkg_ROOT=<path> ]
#        -P build-all.cmake
#
cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

find_package(Git REQUIRED)

# Get ref of a git repository
function(get_ref name dir var)
    execute_process(COMMAND "${GIT_EXECUTABLE}" rev-parse HEAD
                    WORKING_DIRECTORY "${dir}"
                    RESULT_VARIABLE result
                    ERROR_VARIABLE ${var}
                    OUTPUT_VARIABLE ${var}
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    ERROR_STRIP_TRAILING_WHITESPACE)
    if(result)
        message(FATAL_ERROR "Get commit for ${name}: Error ${result}: ${${var}}")
    endif()
    return(PROPAGATE ${var})
endfunction()

# Get ref of vcpkg folder
if(DEFINED ENV{VCPKG_ROOT})
    set(vcpkg_ROOT "$ENV{VCPKG_ROOT}")
elseif(DEFINED ENV{VCPKG_INSTALLATION_ROOT})
    set(vcpkg_ROOT "$ENV{VCPKG_INSTALLATION_ROOT}")
endif()
if(NOT vcpkg_ROOT)
    message(FATAL_ERROR "No vcpkg root folder, run with -D vcpkg_ROOT.")
endif()
get_ref("vcpkg" "${vcpkg_ROOT}" vcpkg-ref)

# Get ref of current folder
get_ref("registry" "${CMAKE_CURRENT_LIST_DIR}/.." ref)
if("$ENV{GIT_REF}" AND NOT "$ENV{GIT_REF}" STREQUAL "${ref}")
    message(FATAL_ERROR "GIT_REF $ENV{GIT_REF} does not equal `git rev-parse HEAD`")
endif()

# Use local git
cmake_path(CONVERT "${CMAKE_CURRENT_LIST_DIR}/.." TO_NATIVE_PATH_LIST path NORMALIZE)
string(REPLACE [[\]] [[\\]] path "${path}")

# Template for vcpkg.json
string(CONFIGURE
[[{
    "name": "vcpkg-registry",
    "dependencies": [],
    "overrides": [],
    "builtin-baseline": "@vcpkg-ref@"
}]] vcpkg_json @ONLY ESCAPE_QUOTES)

string(CONFIGURE
[[{
    "registries": [
        {
          "kind": "git",
          "repository": "@path@",
          "reference": "@ref@",
          "baseline": "@ref@",
          "packages": []
        }
    ]
}]] vcpkg_configuration_json @ONLY ESCAPE_QUOTES)

# Parse all packages in ports folder
file(GLOB_RECURSE  ports "${CMAKE_CURRENT_LIST_DIR}/../ports/vcpkg.json")
set(index 0)
foreach(port IN LISTS ports)
    file(READ "${port}" port_json)

    string(JSON name GET "${port_json}" "name")
    foreach(version_name ITEMS "version" "version-semver" "version-date" "version-string")
        string(JSON version ERROR_VARIABLE error GET "${port_json}" "${version_name}")
        if(NOT error)
            break()
        endif()
    endforeach()
    if(NOT version)
        message(FATAL_ERROR "${name}: No version information")
    endif()

    string(JSON port_version ERROR_VARIABLE error GET "${port_json}" "port-version")
    if(error)
        unset(port_version)
    endif()

    # Add as dependency
    string(JSON vcpkg_json SET "${vcpkg_json}" "dependencies" ${index} "\"${name}\"")
    # Tie to fixed version
    string(JSON vcpkg_json SET "${vcpkg_json}" "overrides" ${index} "{}")
    string(JSON vcpkg_json SET "${vcpkg_json}" "overrides" ${index} "name" "\"${name}\"")
    string(JSON vcpkg_json SET "${vcpkg_json}" "overrides" ${index} "version" "\"${version}\"")
    if(port_version)
        string(JSON vcpkg_json SET "${vcpkg_json}" "overrides" ${index} "port-version" "${port_version}")
    endif()

    # Specify current registry is authoritative for package
    string(JSON vcpkg_configuration_json SET "${vcpkg_configuration_json}" "registries" 0 "packages" ${index} "\"${name}\"")

    math(EXPR index "${index} + 1")
endforeach()

if(NOT DIR)
    string(JSON vcpkg_json SET "${vcpkg_json}" "vcpkg-configuration" "${vcpkg_configuration_json}")
endif()

# Write output
if(DIR)
    file(WRITE "${DIR}/vcpkg.json" "${vcpkg_json}")
    file(WRITE "${DIR}/vcpkg-configuration.json" "${vcpkg_configuration_json}")
else()
    message("${vcpkg_json}")
endif()
