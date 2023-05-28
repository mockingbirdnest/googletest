// Copyright 2008, Google Inc.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//     * Neither the name of Google Inc. nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#include <iostream>
#include "glog/logging.h"
#include "gmock/gmock.h"
#include "gtest/gtest.h"

#if GTEST_OS_ESP8266 || GTEST_OS_ESP32
#if GTEST_OS_ESP8266
extern "C" {
#endif
void setup() {
  // Since Google Mock depends on Google Test, InitGoogleMock() is
  // also responsible for initializing Google Test.  Therefore there's
  // no need for calling testing::InitGoogleTest() separately.
  testing::InitGoogleMock();
}
void loop() { RUN_ALL_TESTS(); }
#if GTEST_OS_ESP8266
}
#endif

#else

#if GTEST_OS_WINDOWS

#include <windows.h>

char* NewUTF8(const wchar_t* utf_16) {
  int const size =
      WideCharToMultiByte(CP_UTF8, /*dwFlags=*/0, utf_16, /*cchWideChar=*/-1,
                          /*lpMultiByteStr=*/nullptr, /*cbMultiByte=*/0,
                          /*lpDefaultChar=*/nullptr,
                          /*lpUsedDefaultChar=*/nullptr);
  char* result = new char[size];
  WideCharToMultiByte(CP_UTF8, /*dwFlags=*/0, utf_16, /*cchWideChar=*/-1,
                      /*lpMultiByteStr=*/result, /*cbMultiByte=*/size,
                      /*lpDefaultChar=*/nullptr,
                      /*lpUsedDefaultChar=*/nullptr);
  return result;
}

void __cdecl HandleCRTInvalidParameter(const wchar_t* expression,
                                       const wchar_t* function,
                                       const wchar_t* file, unsigned int line,
                                       uintptr_t pReserved) {
  google::LogMessageFatal(NewUTF8(file), line).stream()
      << NewUTF8(function) << ": " << NewUTF8(expression);
}
#endif

// MS C++ compiler/linker has a bug on Windows (not on Windows CE), which
// causes a link error when _tmain is defined in a static library and UNICODE
// is enabled. For this reason instead of _tmain, main function is used on
// Windows. See the following link to track the current status of this bug:
// https://web.archive.org/web/20170912203238/connect.microsoft.com/VisualStudio/feedback/details/394464/wmain-link-error-in-the-static-library
// // NOLINT
#if GTEST_OS_WINDOWS_MOBILE
# include <tchar.h>  // NOLINT

GTEST_API_ int _tmain(int argc, TCHAR** argv) {
#else
GTEST_API_ int __cdecl main(int argc, char** argv) {
#endif  // GTEST_OS_WINDOWS_MOBILE
  std::cout << "Running main() from gmock_main.cc\n";
  google::InitGoogleLogging(argv[0]);
#if GTEST_OS_WINDOWS
  _set_invalid_parameter_handler(&HandleCRTInvalidParameter);
#endif
  // Since Google Mock depends on Google Test, InitGoogleMock() is
  // also responsible for initializing Google Test.  Therefore there's
  // no need for calling testing::InitGoogleTest() separately.
  testing::InitGoogleMock(&argc, argv);
  return RUN_ALL_TESTS();
}
#endif
