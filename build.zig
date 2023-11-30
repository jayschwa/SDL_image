const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "SDL2_image",
        .target = target,
        .optimize = optimize,
    });

    if (@hasDecl(std.Build.LibExeObjStep, "AddCSourceFilesOptions"))
        lib.addCSourceFiles(.{ .files = &generic_src_files })
    else
        lib.addCSourceFiles(&generic_src_files, &.{});
    for (supported_file_types) |file_type| lib.defineCMacro(file_type, null);
    lib.defineCMacro("USE_STBIMAGE", null);
    if (lib.target.isNativeOs() and lib.target.getOsTag() == .linux) {
        // The SDL package doesn't work for Linux yet, so we rely on system packages for now.
        lib.linkSystemLibrary("SDL2");
    } else {
        const sdl = b.dependency("sdl", .{
            .target = target,
            .optimize = optimize,
        });
        lib.linkLibrary(sdl.artifact("SDL2"));
    }
    lib.installHeader("SDL_image.h", "SDL2/SDL_image.h");
    b.installArtifact(lib);
}

const generic_src_files = [_][]const u8{
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

const supported_file_types = [_][]const u8{
    "LOAD_BMP",
    "LOAD_GIF",
    "LOAD_LBM",
    "LOAD_PCX",
    "LOAD_PNG",
    "LOAD_SVG",
    "LOAD_TGA",
    "LOAD_QOI",
};
