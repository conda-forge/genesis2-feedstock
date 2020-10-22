mkdir build
cd build

cmake -G "MinGW Makefiles" ^
    -D CMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"
    ..
if errorlevel 1 exit 1

cmake --build .
if errorlevel 1 exit 1
cmake --install
if errorlevel 1 exit 1

exit 0
