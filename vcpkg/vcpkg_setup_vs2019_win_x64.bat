@echo off

REM Build FLINT dependencies from vcpkg manifest using Visual Studio 2022.
REM Run using VS2019 x64 native tools command prompt.

REM Ensure git is on the path.
set GIT_PATH="C:\Program Files\Microsoft Visual Studio\2019\Professional\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd"
set PATH=%PATH%;%GIT_PATH%

if not exist vcpkg (
    git clone https://github.com/microsoft/vcpkg.git
    pushd vcpkg
    call bootstrap-vcpkg.bat
    popd
)

REM Build all dependencies and configure CMake.
if not exist ..\source\build md ..\source\build
pushd ..\source\build

REM If OpenSSL fails to build, just keep retrying until it does.
cmake -S .. ^
    -G "Visual Studio 16 2019" ^
    -DCMAKE_INSTALL_PREFIX=bin ^
    -DVCPKG_TARGET_TRIPLET=moja-x64-windows ^
    -DVCPKG_INSTALL_OPTIONS="--x-abi-tools-use-exact-versions" ^
    -DCMAKE_TOOLCHAIN_FILE=..\..\vcpkg\vcpkg\scripts\buildsystems\vcpkg.cmake ^
    -DENABLE_TESTS:BOOL=OFF ^
    -DENABLE_MOJA.MODULES.ZIPPER:BOOL=ON ^
    -DENABLE_MOJA.MODULES.GDAL:BOOL=ON ^
    -DENABLE_MOJA.MODULES.LIBPQ:BOOL=ON ^
    -DENABLE_MOJA.MODULES.POCO:BOOL=ON

popd
