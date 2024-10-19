const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("sdl_image", .{});

    const lib = b.addStaticLibrary(.{
        .name = "SDL2_image",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();

    const sdl_dep = b.dependency("sdl", .{
        .target = target,
        .optimize = optimize,
    });
    const sdl_lib = sdl_dep.artifact("SDL2");
    lib.linkLibrary(sdl_lib);
    if (sdl_lib.installed_headers_include_tree) |tree|
        lib.addIncludePath(tree.getDirectory().path(b, "SDL2"));

    for (file_types) |file_type|
        lib.defineCMacro(file_type, null);
    lib.defineCMacro("USE_STBIMAGE", null);
    lib.addIncludePath(upstream.path("include"));
    lib.addIncludePath(upstream.path("src"));

    lib.addCSourceFiles(.{
        .root = upstream.path("src"),
        .files = srcs,
    });

    lib.installHeader(upstream.path("include/SDL_image.h"), "SDL2/SDL_image.h");

    b.installArtifact(lib);
}

const srcs: []const []const u8 = &.{
    "IMG.c",
    "IMG_WIC.c",
    "IMG_avif.c",
    "IMG_bmp.c",
    "IMG_gif.c",
    "IMG_jpg.c",
    "IMG_jxl.c",
    "IMG_lbm.c",
    "IMG_pcx.c",
    "IMG_png.c",
    "IMG_pnm.c",
    "IMG_qoi.c",
    "IMG_stb.c",
    "IMG_svg.c",
    "IMG_tga.c",
    "IMG_tif.c",
    "IMG_webp.c",
    "IMG_xcf.c",
    "IMG_xpm.c",
    "IMG_xv.c",
};

const file_types: []const []const u8 = &.{
    "LOAD_BMP",
    "LOAD_GIF",
    "LOAD_LBM",
    "LOAD_PCX",
    "LOAD_PNG",
    "LOAD_SVG",
    "LOAD_TGA",
    "LOAD_QOI",
};
