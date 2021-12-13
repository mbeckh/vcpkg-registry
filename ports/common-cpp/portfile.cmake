vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/common-cpp
    REF 9bb111caef5df1c2a00d1026621296441b427fc1
    SHA512 ebfb101e9a900d6a8d5af90e7d5b1765b8c72cb2decf8364e7a6f5b18977c1418b0bd2932e5e62f0e0453b01e4366ea827f98ffa635224bd021a10d549b7c9c7
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup(PACKAGE_NAME common-cpp)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
