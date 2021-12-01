vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/detours-gmock
    REF f12438637f0e87de7d722ef9a34b342174729941
    SHA512 2a8c4caaf6c1cb4a17cb5bc95cc7e64e09e0922de83d0d926cd1054520de9a2231c60c4f95ba446eaa59168a3b5915478e3afc7660ec1b9e29b8cf3f2831c3f1
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
