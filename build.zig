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

    // Use stb_image for loading JPEG and PNG files. Native alternatives such as
    // Windows Imaging Component and Apple's Image I/O framework are not yet
    // supported by this build script.
    lib.defineCMacro("USE_STBIMAGE", null);

    // The following are options for supported file formats. AVIF, JXL, TIFF,
    // and WebP are not yet supported by this build script, as they require
    // additional dependencies.
    if (b.option(bool, "enable-bmp", "Support loading BMP images") orelse true)
        lib.defineCMacro("LOAD_BMP", null);
    if (b.option(bool, "enable-gif", "Support loading GIF images") orelse true)
        lib.defineCMacro("LOAD_GIF", null);
    if (b.option(bool, "enable-jpg", "Support loading JPEG images") orelse true)
        lib.defineCMacro("LOAD_JPG", null);
    if (b.option(bool, "enable-lbm", "Support loading LBM images") orelse true)
        lib.defineCMacro("LOAD_LBM", null);
    if (b.option(bool, "enable-pcx", "Support loading PCX images") orelse true)
        lib.defineCMacro("LOAD_PCX", null);
    if (b.option(bool, "enable-png", "Support loading PNG images") orelse true)
        lib.defineCMacro("LOAD_PNG", null);
    if (b.option(bool, "enable-pnm", "Support loading PNM images") orelse true)
        lib.defineCMacro("LOAD_PNM", null);
    if (b.option(bool, "enable-qoi", "Support loading QOI images") orelse true)
        lib.defineCMacro("LOAD_QOI", null);
    if (b.option(bool, "enable-svg", "Support loading SVG images") orelse true)
        lib.defineCMacro("LOAD_SVG", null);
    if (b.option(bool, "enable-tga", "Support loading TGA images") orelse true)
        lib.defineCMacro("LOAD_TGA", null);
    if (b.option(bool, "enable-xcf", "Support loading XCF images") orelse true)
        lib.defineCMacro("LOAD_XCF", null);
    if (b.option(bool, "enable-xpm", "Support loading XPM images") orelse true)
        lib.defineCMacro("LOAD_XPM", null);
    if (b.option(bool, "enable-xv", "Support loading XV images") orelse true)
        lib.defineCMacro("LOAD_XV", null);

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
