################################################################################
#
# Copyright (c) 2011-2022  Made to Order Software Corp.  All Rights Reserved
#
# http://snapwebsites.org/
# contact@m2osw.com
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
################################################################################
#
# Source: https://github.com/adobe/webkit/blob/master/Source/cmake/FindICU.cmake
#
# Finds the International Components for Unicode (ICU) Library
#
# ICU_FOUND          - True if ICU found.
# ICU_I18N_FOUND     - True if ICU's internationalization library found.
# ICU_INCLUDE_DIRS   - Directory to include to get ICU headers
#
# Note: always include ICU headers including path, e.g.,
#
#       #include <unicode/utypes.h>
#
# ICU_LIBRARIES      - Libraries to link against for the common ICU
# ICU_I18N_LIBRARIES - Libraries to link against for ICU internationaliation
#                      (note: in addition to ICU_LIBRARIES)
#

# Look for the header file.
FIND_PATH(
    ICU_INCLUDE_DIR
    NAMES unicode/utypes.h
    DOC "Include directory for the ICU library")
MARK_AS_ADVANCED(ICU_INCLUDE_DIR)

# Look for the library.
FIND_LIBRARY(
    ICU_LIBRARY
    NAMES icuuc cygicuuc cygicuuc32
    DOC "Libraries to link against for the common parts of ICU")
MARK_AS_ADVANCED(ICU_LIBRARY)

# Copy the results to the output variables.
IF (ICU_INCLUDE_DIR AND ICU_LIBRARY)
    SET(ICU_FOUND 1)
    SET(ICU_LIBRARIES ${ICU_LIBRARY})
    SET(ICU_INCLUDE_DIRS ${ICU_INCLUDE_DIR})

    SET(ICU_VERSION 0)
    SET(ICU_MAJOR_VERSION 0)
    SET(ICU_MINOR_VERSION 0)
    FILE(READ "${ICU_INCLUDE_DIR}/unicode/uversion.h" _ICU_VERSION_CONENTS)
    STRING(REGEX REPLACE ".*#define U_ICU_VERSION_MAJOR_NUM ([0-9]+).*" "\\1" ICU_MAJOR_VERSION "${_ICU_VERSION_CONENTS}")
    STRING(REGEX REPLACE ".*#define U_ICU_VERSION_MINOR_NUM ([0-9]+).*" "\\1" ICU_MINOR_VERSION "${_ICU_VERSION_CONENTS}")

    SET(ICU_VERSION "${ICU_MAJOR_VERSION}.${ICU_MINOR_VERSION}")

    # Look for the ICU internationalization libraries
    FIND_LIBRARY(
        ICU_I18N_LIBRARY
        NAMES icuin icui18n cygicuin cygicuin32
        DOC "Libraries to link against for ICU internationalization")
    MARK_AS_ADVANCED(ICU_I18N_LIBRARY)
    IF (ICU_I18N_LIBRARY)
        SET(ICU_I18N_FOUND 1)
        SET(ICU_I18N_LIBRARIES ${ICU_I18N_LIBRARY})
    ELSE ()
        SET(ICU_I18N_FOUND 0)
        SET(ICU_I18N_LIBRARIES)
    ENDIF ()
ELSE ()
    SET(ICU_FOUND 0)
    SET(ICU_I18N_FOUND 0)
    SET(ICU_LIBRARIES)
    SET(ICU_I18N_LIBRARIES)
    SET(ICU_INCLUDE_DIRS)
    SET(ICU_VERSION)
    SET(ICU_MAJOR_VERSION)
    SET(ICU_MINOR_VERSION)
ENDIF ()

IF (ICU_FOUND)
    IF (NOT ICU_FIND_QUIETLY)
        MESSAGE(STATUS "Found ICU header files in ${ICU_INCLUDE_DIRS}")
        MESSAGE(STATUS "Found ICU libraries: ${ICU_LIBRARIES}")
    ENDIF ()
ELSE ()
    IF (ICU_FIND_REQUIRED)
        MESSAGE(FATAL_ERROR "Could not find ICU")
    ELSE ()
        MESSAGE(STATUS "Optional package ICU was not found")
    ENDIF ()
ENDIF ()

