vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/common-cpp
    REF b82f2175f9cd36a4fb07833a8ee71f23478f3a4d
    SHA512 06b076586194f7c08daf6bd180d14e874e84d48d6e4b2047fe29177fcad6989cac76e14497a048f1536a6426630f853f5b3bda5de4d250f11f8dda3cf1de0e99
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup(PACKAGE_NAME common-cpp)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
