vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/detours-gmock
    REF 9bb411a829c735caf281a1a23c40958814194eac
    SHA512 c51abb742a8a5a9593fc4af56615dee5ecadfeb37db44481e887b71c033e475142cfc74dc5fd1130683b5b745e307475c507bc1493aaff1966dd7d134080b93e
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
