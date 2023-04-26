target("libBGFX")
    set_kind("static")

    add_deps(
        "libBX",
        "libBImg"
    )

    local BGFX_DIR = "$(projectdir)/Vendor/bgfx/"
    local BX_DIR = "$(projectdir)/Vendor/bx/"
    local BIMG_DIR = "$(projectdir)/Vendor/bimg/"

    add_includedirs(BGFX_DIR .. "include")
    add_includedirs(BGFX_DIR .. "3rdparty")
    add_includedirs(BX_DIR .. "include")
    add_includedirs(BIMG_DIR .. "include")
    add_includedirs(BGFX_DIR .. "3rdparty/khronos")
    
    if is_plat("windows") then
        add_defines("__STDC_LIMIT_MACROS"
                , "__STDC_FORMAT_MACROS"
                , "__STDC_CONSTANT_MACROS"
                , "NDEBUG"
                , "WIN32"
                , "_WIN32"
                , "_HAS_EXCEPTIONS=0"
                , "_HAS_ITERATOR_DEBUGGING=0"
                , "_ITERATOR_DEBUG_LEVEL=0"
                , "_SCL_SECURE=0"
                , "_SECURE_SCL=0"
                , "_SCL_SECURE_NO_WARNINGS"
                , "_CRT_SECURE_NO_WARNINGS"
                , "_CRT_SECURE_NO_DEPRECATE"
                , "BX_CONFIG_DEBUG")

        add_includedirs(BGFX_DIR .. "3rdparty/directx-headers/include/directx")
        add_includedirs(BX_DIR .. "include/compat/msvc")

        add_syslinks("user32", "gdi32")

        -- default cl complier
        add_files(BGFX_DIR .. "src/**.cpp|amalgamated.cpp") --|glcontext_glx.cpp|glcontext_egl.cpp

    elseif is_plat("macosx") then
        add_defines("NDEBUG")
        add_cxxflags("-Wno-microsoft-enum-value", "-Wno-microsoft-const-init", "-x objective-c++")
        --add_mxxflags("-Wno-microsoft-enum-value", "-Wno-microsoft-const-init", "-x objective-c++")

        add_mxxflags("-weak_framework Metal", "-weak_framework MetalKit")
        add_ldflags("-weak_framework Metal", "-weak_framework MetalKit")

        add_frameworks("CoreVideo","IOKit","Cocoa","QuartzCore","OpenGL")
        add_includedirs(BX_DIR .. "include/compat/osx")

        add_files(BGFX_DIR .. "src/glcontext_**.mm")
        add_files(BGFX_DIR .. "src/renderer_**.mm")
        add_files(BGFX_DIR .. "src/**.cpp|amalgamated.cpp")
    end