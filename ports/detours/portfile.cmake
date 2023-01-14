vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO microsoft/Detours
    REF 734ac64899c44933151c1335f6ef54a590219221
    SHA512 f4f4d85d805e4ca854e756c89fe94371a140525aae82769ade15acc2a0ab7b06d6315b1a9366da4071d38eebfa9b4a1513477f050a679096b393736ecce9aeba
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
