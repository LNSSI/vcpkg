include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO chromiumembedded/cef-project
    REF 427d9e61f25a266a77f511d7c5ee6dba71c6f9b1
    SHA512 5cfeb3057b9456dce46c2579f50ef1ea58081ab585f47033087ccf9db852ea8e1e56728db8f99c7878e077ddb3e05e30a11388211d38db28a13c816a5c5c7e1d
    HEAD_REF master
)

file(MAKE_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)
vcpkg_execute_required_process(
    COMMAND cmake "${SOURCE_PATH}" -A x64 -DCEF_RUNTIME_LIBRARY_FLAG=/MDd
    WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg
    LOGNAME configure-${TARGET_TRIPLET}-dbg
)
vcpkg_execute_required_process(
    COMMAND cmake --build . --target libcef_dll_wrapper --config Debug
    WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg
    LOGNAME build-${TARGET_TRIPLET}-dbg
)

file(MAKE_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)
vcpkg_execute_required_process(
    COMMAND cmake "${SOURCE_PATH}" -A x64 -DCEF_RUNTIME_LIBRARY_FLAG=/MD
    WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel
    LOGNAME configure-${TARGET_TRIPLET}-rel
)
vcpkg_execute_required_process(
    COMMAND cmake --build . --target libcef_dll_wrapper --config Release
    WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel
    LOGNAME build-${TARGET_TRIPLET}-rel
)

file(GLOB CEF_SEARCH_PATHS "${SOURCE_PATH}/third_party/cef/*")
find_path(CEF_ROOT_DIR 
    NAMES include/cef_client.h
    PATHS ${CEF_SEARCH_PATHS}
)

file(INSTALL ${CEF_ROOT_DIR}/include DESTINATION ${CURRENT_PACKAGES_DIR}/include/cef-project)
#file(INSTALL ${CEF_ROOT_DIR}/Debug/libcef.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
#file(INSTALL ${CEF_ROOT_DIR}/Release/libcef.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
#file(INSTALL ${CEF_ROOT_DIR}/Debug/libcef.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
#file(INSTALL ${CEF_ROOT_DIR}/Release/libcef.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/libcef_dll_wrapper/Debug/libcef_dll_wrapper.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/libcef_dll_wrapper/Release/libcef_dll_wrapper.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/cef-project RENAME copyright)
