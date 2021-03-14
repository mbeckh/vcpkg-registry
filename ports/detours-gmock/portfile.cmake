vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/detours-gmock
    REF 191073cd043061d1bd1c20fb3548547a7e94f582
    SHA512 2d7dc4c8ea1df2802a7470baf1033f0ff8d64fc18f45e544bc2c196a95d55c8034833132242d9c5c8c14743ae9563470d1aed4a56a0e99f5459cf86724f78895
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
