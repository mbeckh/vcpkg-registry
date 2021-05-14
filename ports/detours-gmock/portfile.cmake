vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/detours-gmock
    REF 93b7afa960c63d4e3952365caca6dda6ca424599
    SHA512 75394dbc45163086fd07c59dacd53e158a5c4afba997e6ba545a41ad368ef2c7bd3b89e19bfd8f8a15194a728843b48fab8ec695b8e5f8845aaa1ddb064876eb
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
