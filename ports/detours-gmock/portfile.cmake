vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/detours-gmock
    REF a9df9672b9ebef6d56d27ad16a3946ccdd3264e5
    SHA512 0ced3a0592ea921e2348a944c947241e9b0e784d444b66a8279b2816fa3824509c6db81c311e762ea9e224b7618b851fa05d8498b357cc4cf2ff3ac00f64dc03
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
