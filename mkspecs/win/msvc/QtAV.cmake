set(QtAv_ENABLED off CACHE BOOL "Build qtav.")

if(QtAv_ENABLED)
    include(ExternalProject)

    set(QtAv_BRANCH v1.12.0 CACHE STRING "The git branch to use.")

    string(REPLACE ";" " -L" EXTERNAL_LIB_PATH_STRING "${EXTERNAL_LIB_PATH}")
    string(REPLACE ";" " " EXTERNAL_INCLUDE_PATH_STRING "${EXTERNAL_INCLUDE_PATH}")
    file(WRITE ${EXTERNAL_PROJECT_BINARY_DIR}/configure.bat
    "
    call \"${CMAKE_BINARY_DIR}/setMsvcEnv.bat\"
    call \"${CMAKE_BINARY_DIR}/setSearchEnv.bat\"
    cd /D \"${EXTERNAL_PROJECT_BINARY_DIR}/src/QtAV\"
    qmake -r -tp vc \"LIBS+=${EXTERNAL_LIB_PATH_STRING}\" \"INCLUDEPATH+=${EXTERNAL_INCLUDE_PATH_STRING}\" QtAV.pro
    "
    )

    file(WRITE ${EXTERNAL_PROJECT_BINARY_DIR}/build.bat
    "
    call \"${CMAKE_BINARY_DIR}/setMsvcEnv.bat\"
    call \"${CMAKE_BINARY_DIR}/setSearchEnv.bat\"
    cd /D \"${EXTERNAL_PROJECT_BINARY_DIR}/src/QtAV\"
    msbuild /p:Configuration=${EXTERNAL_PROJECT_BUILD_TYPE}
    "
    )

    string(REPLACE "/" "\\" EXTERNAL_PROJECT_BINARY_DIR_BACK "${EXTERNAL_PROJECT_BINARY_DIR}")
    string(REPLACE "/" "\\" EXTERNAL_PROJECT_INSTALL_DIR_BACK "${EXTERNAL_PROJECT_INSTALL_DIR}")
    file(WRITE ${EXTERNAL_PROJECT_BINARY_DIR}/install.bat
    "
    \"${CMAKE_COMMAND}\" -E make_directory \"${EXTERNAL_PROJECT_INSTALL_DIR}\"
    \"${CMAKE_COMMAND}\" -E make_directory \"${EXTERNAL_PROJECT_INSTALL_DIR}/bin\"
    \"${CMAKE_COMMAND}\" -E make_directory \"${EXTERNAL_PROJECT_INSTALL_DIR}/lib\"
    \"${CMAKE_COMMAND}\" -E make_directory \"${EXTERNAL_PROJECT_INSTALL_DIR}/lib/qml\"
    \"${CMAKE_COMMAND}\" -E make_directory \"${EXTERNAL_PROJECT_INSTALL_DIR}/lib/qml/QtAV\"
    \"${CMAKE_COMMAND}\" -E make_directory \"${EXTERNAL_PROJECT_INSTALL_DIR}/include\"
    \"${CMAKE_COMMAND}\" -E make_directory \"${EXTERNAL_PROJECT_INSTALL_DIR}/include/QtAV\"
    \"${CMAKE_COMMAND}\" -E make_directory \"${EXTERNAL_PROJECT_INSTALL_DIR}/include/QtAVWidgets\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\lib_win_x86_64\\*Qt*AV*.lib*\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\lib\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\lib_win_x86_64\\QtAV1.lib\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\lib\\Qt5AV.lib\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\lib_win_x86_64\\QtAVd1.lib\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\lib\\Qt5AVd.lib\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\bin\\Qt*AV*.dll\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\bin\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\lib_win_x86_64\\*QmlAV*.lib\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\lib\\qml\\QtAV\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\bin\\QtAV\\*QmlAV*.dll\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\lib\\qml\\QtAV\"

    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\lib_win_x86_64\\QtAVWidgets1.lib\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\lib\\Qt5AVWidgets.lib\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\lib_win_x86_64\\QtAVWidgetsd1.lib\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\lib\\Qt5AVWidgetsd.lib\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\src\\QtAV\\*.h\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\include\\QtAV\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\src\\QtAV\\QtAV\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\include\\QtAV\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\widgets\\QtAVWidgets\\*.h\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\include\\QtAVWidgets\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\widgets\\QtAVWidgets\\QtAVWidgets\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\include\\QtAVWidgets\"

    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\qml\\qmldir\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\lib\\qml\\QtAV\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\qml\\Video.qml\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\lib\\qml\\QtAV\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\qml\\plugins.qmltypes\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\lib\\qml\\QtAV\"
    copy /Y \"${EXTERNAL_PROJECT_BINARY_DIR_BACK}\\src\\QtAV\\bin\\QtAV\\QmlAVd.dll\" \"${EXTERNAL_PROJECT_INSTALL_DIR_BACK}\\lib\\qml\\QtAV\"
    "
    )

    ExternalProject_Add(${EXTERNAL_PROJECT_NAME}
        DEPENDS FFmpeg Qt5
        PREFIX ${EXTERNAL_PROJECT_NAME}
        STAMP_DIR ${CMAKE_BINARY_DIR}/logs
        GIT_REPOSITORY https://github.com/wang-bin/QtAV.git
        GIT_TAG ${QtAv_BRANCH}
        CONFIGURE_COMMAND ${EXTERNAL_PROJECT_BINARY_DIR}/configure.bat
        BUILD_COMMAND ${EXTERNAL_PROJECT_BINARY_DIR}/build.bat
        INSTALL_COMMAND ${EXTERNAL_PROJECT_BINARY_DIR}/install.bat
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
    )

    set(EXTERNAL_QML2_IMPORT_PATH_REL "${EXTERNAL_QML2_IMPORT_PATH_REL};${EXTERNAL_PROJECT_PREFIX}/lib/qml")
endif()