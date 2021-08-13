vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/common-cpp-testing
    REF 66455b4c8b3fb7f348b938e7079073b381c56412
    SHA512 3f9fc5240e69f5df7c8140e57b1cb47c3f7ef7cdb6ca162c3c166a16addb38d6311d0277fb0f546a9fe6a9c9115fe7c35cc6ab6cec1f25fd66406be157e9ab70
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup(PACKAGE_NAME m4t)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
