vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/common-cpp-testing
    REF 3351d92e30ded769f1bda8f263a8d4fc4a9475e9
    SHA512 4d71f8c574143003ecb0be0a5425225c956197903baec33b77634613e58c4d6e7a8bb3b7253ae56667c106f42e9e02f030cd24d3a2dd89ca7f7f0b291f247215
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup(PACKAGE_NAME common-cpp-testing)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
