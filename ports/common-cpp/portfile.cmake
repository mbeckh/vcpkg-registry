vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/common-cpp
    REF 8f10f5d80e8eaa5ccb837e12aef704c41193f728
    SHA512 911be03d3beb28c492092d6847dfa5b16f179c652373353dc55625dc07c6954acefb04099b9913f4e22ca59c80b2fc9e19c4e107d77932d1e58ef066721e6932
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup(PACKAGE_NAME common-cpp)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
