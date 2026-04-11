cmake \
    -DCMAKE_C_COMPILER:FILEPATH=`which clang` \
    -DCMAKE_CXX_COMPILER:FILEPATH=`which clang++` \
    -DCMAKE_C_FLAGS="${C_FLAGS?}" \
    -DCMAKE_CXX_FLAGS="${CXX_FLAGS?}" \
    -DCMAKE_OSX_ARCHITECTURES="x86_64" \
    -DCMAKE_OSX_DEPLOYMENT_TARGET="${OSX_DEPLOYMENT_TARGET}" \
    -DCMAKE_LD_FLAGS="${LD_FLAGS?}" \
    -DCMAKE_INSTALL_PREFIX=install
cmake --build . --target install --parallel 8
