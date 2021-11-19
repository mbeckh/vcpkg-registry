vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/common-cpp-testing
    REF 98bc032edfeb24426fe7834f719a33a2854fcc1d
    SHA512 36e548eb8c117c35fbb73bf23a2302f3163d5556827e09f2a681213d8003ca340e93db3e83cba7fb927b2cd461702ab9f3965e5da4d6209e32ab47e638fb5e1f
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup(PACKAGE_NAME common-cpp-testing)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
