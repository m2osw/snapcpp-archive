#
# Text:
#      src/CMakeLists.txt
#
# Description:
#      Defines the source files in the libQtSerialization library.
#
# Documentation:
#      See the CMake documentation.
#
# License:
#      Copyright (c) 2012-2022  Made to Order Software Corp.  All Rights Reserved
#
#      https://snapwebsites.org/
#      contact@m2osw.com
#
#      Permission is hereby granted, free of charge, to any person obtaining a
#      copy of this software and associated documentation files (the
#      "Software"), to deal in the Software without restriction, including
#      without limitation the rights to use, copy, modify, merge, publish,
#      distribute, sublicense, and/or sell copies of the Software, and to
#      permit persons to whom the Software is furnished to do so, subject to
#      the following conditions:
#
#      The above copyright notice and this permission notice shall be included
#      in all copies or substantial portions of the Software.
#
#      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
#      OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#      MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#      IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#      CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#      TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#      SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

project( QtSerialization )

add_library(${PROJECT_NAME} SHARED
    QSerialization.cpp
    QSerializationField.cpp
    QSerializationComposite.cpp
    QSerializationFieldString.cpp
    QSerializationFieldTag.cpp
    QSerializationReader.cpp
    QSerializationWriter.cpp
)

target_link_libraries(${PROJECT_NAME}
    Qt5::Core
    ${LIBEXCEPT_LIBRARIES}
)

set_target_properties( ${PROJECT_NAME} PROPERTIES
    VERSION ${LIBQTSERIALIZATION_VERSION_MAJOR}.${LIBQTSERIALIZATION_VERSION_MINOR}
    SOVERSION ${LIBQTSERIALIZATION_VERSION_MAJOR}
)

install(
    TARGETS
        QtSerialization

    LIBRARY DESTINATION
        lib
)
install(
    DIRECTORY
        ${libQtSerialization_SOURCE_DIR}/include/QtSerialization

    DESTINATION
        include

    FILES_MATCHING PATTERN
        *.h

    PATTERN
        .svn EXCLUDE
)
install(
    FILES
        ${libQtSerialization_BINARY_DIR}/include/QtSerialization/QSerialization.h

    DESTINATION
        include/QtSerialization/
)

# vim: ts=4 sw=4 et
