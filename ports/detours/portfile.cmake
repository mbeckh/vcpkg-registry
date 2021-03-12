vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO microsoft/Detours
    REF ba2c4ec872c2802cd4c3c23af79d4ed9313877f7
    SHA512 1ebf6c75393a13629ce2f7850adf5c25e70684c9e13f2375015995446db169577dba651b145fc41aa17555f10cd851c781fdd600b1907915362b8f2ffbfcc4c3
    HEAD_REF master
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt ${CMAKE_CURRENT_LIST_DIR}/detours-config.cmake.in
     DESTINATION ${SOURCE_PATH})

vcpkg_cmake_configure(SOURCE_PATH ${SOURCE_PATH}
                      OPTIONS -DPROCESSOR_ARCHITECTURE=${VCPKG_TARGET_ARCHITECTURE})
vcpkg_cmake_install()

file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

vcpkg_cmake_config_fixup()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)
