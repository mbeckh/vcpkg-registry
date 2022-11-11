vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mbeckh/common-cpp
    REF 96c86a918d4a2ef68e690b8b388aa26bb12dd289
    SHA512 46263117102dd5a025db94385b39c6791b430f48de6965dcce2bf8632e81ca759ab92bcb13d12636018cc69bb828b43c945c45bd07b4eb228621ae4b766a5972
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")

vcpkg_cmake_config_fixup(PACKAGE_NAME common-cpp)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
