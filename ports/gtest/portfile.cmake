if (EXISTS "${CURRENT_BUILDTREES_DIR}/src/.git")
    file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/src)
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/googletest
    REF e7e591764baba0a0c3c9ad0014430e7a27331d16
    SHA512 8453fad4393f091ea3e700ee8c77ca40fdcb2ab5c63bfeabf870d44d2d62b8e06c5e26908b3060391a6f128b3ff07fd6f1d51a52ddc055f5abcc8dcc6459757e
    HEAD_REF master
    PATCHES
        0002-Fix-z7-override.patch
        fix-main-lib-path.patch
)

string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "dynamic" GTEST_FORCE_SHARED_CRT)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DBUILD_GMOCK=ON
        -DBUILD_GTEST=ON
        -DCMAKE_DEBUG_POSTFIX=d
        -Dgtest_force_shared_crt=${GTEST_FORCE_SHARED_CRT}
		-DCMAKE_DISABLE_FIND_PACKAGE_Python:BOOL=TRUE
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/GTest)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)

if(EXISTS ${CURRENT_PACKAGES_DIR}/debug/lib/gtest_maind.lib)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/lib/manual-link)
    file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/gtest_maind.lib ${CURRENT_PACKAGES_DIR}/debug/lib/manual-link/gtest_maind.lib)
    file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/gmock_maind.lib ${CURRENT_PACKAGES_DIR}/debug/lib/manual-link/gmock_maind.lib)

    file(READ ${CURRENT_PACKAGES_DIR}/share/gtest/GTestTargets-debug.cmake DEBUG_CONFIG)
    string(REPLACE "\${_IMPORT_PREFIX}/debug/lib/gtest_maind.lib"
                   "\${_IMPORT_PREFIX}/debug/lib/manual-link/gtest_maind.lib" DEBUG_CONFIG "${DEBUG_CONFIG}")
    string(REPLACE "\${_IMPORT_PREFIX}/debug/lib/gmock_maind.lib"
                   "\${_IMPORT_PREFIX}/debug/lib/manual-link/gmock_maind.lib" DEBUG_CONFIG "${DEBUG_CONFIG}")
    file(WRITE ${CURRENT_PACKAGES_DIR}/share/gtest/GTestTargets-debug.cmake "${DEBUG_CONFIG}")
endif()

if(EXISTS ${CURRENT_PACKAGES_DIR}/lib/gtest_main.lib)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/lib/manual-link)
    file(RENAME ${CURRENT_PACKAGES_DIR}/lib/gtest_main.lib ${CURRENT_PACKAGES_DIR}/lib/manual-link/gtest_main.lib)
    file(RENAME ${CURRENT_PACKAGES_DIR}/lib/gmock_main.lib ${CURRENT_PACKAGES_DIR}/lib/manual-link/gmock_main.lib)

    file(READ ${CURRENT_PACKAGES_DIR}/share/gtest/GTestTargets-release.cmake RELEASE_CONFIG)
    string(REPLACE "\${_IMPORT_PREFIX}/lib/gtest_main.lib"
                   "\${_IMPORT_PREFIX}/lib/manual-link/gtest_main.lib" RELEASE_CONFIG "${RELEASE_CONFIG}")
    string(REPLACE "\${_IMPORT_PREFIX}/lib/gmock_main.lib"
                   "\${_IMPORT_PREFIX}/lib/manual-link/gmock_main.lib" RELEASE_CONFIG "${RELEASE_CONFIG}")
    file(WRITE ${CURRENT_PACKAGES_DIR}/share/gtest/GTestTargets-release.cmake "${RELEASE_CONFIG}")
endif()

vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
