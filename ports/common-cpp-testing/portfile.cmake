vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/common-cpp-testing
    REF 0e51d1b699dfd27f088d24355b3d6d12f4820b78
    SHA512 e67f3f8dba1928411473f456dde199966c04d8ef2e111313fd8df2759978ad115120302e0351cde039d2df48756e13fd537417387d2471e207a280230b7c638d
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/m4t" RENAME "copyright")

vcpkg_cmake_config_fixup(PACKAGE_NAME m4t)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
