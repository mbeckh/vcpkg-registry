vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/common-cpp-testing
    REF 4a8b515691ccefb0eeb0cf851c7c0b287946322d
    SHA512 1912d6e0e1804344d9013ef375783cb9aeaa935a1e03fa584e37dacdc95022fcb6d1c898f4abe196146dfe7d5353f4f46658f249eb5b08e2bc5947a61a896098
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup(PACKAGE_NAME m4t)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
