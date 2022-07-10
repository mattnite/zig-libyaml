const std = @import("std");
const Builder = std.build.Builder;
const LibExeObjStep = std.build.LibExeObjStep;

fn root() []const u8 {
    return (std.fs.path.dirname(@src().file) orelse ".") ++ "/";
}

pub const include_dir = root() ++ "libyaml/include";

pub const Options = struct {};

pub const Library = struct {
    step: *std.build.LibExeObjStep,

    pub fn link(self: Library, other: *std.build.LibExeObjStep, opts: Options) void {
        _ = opts;

        other.addIncludeDir(include_dir);
        other.linkLibrary(self.step);
    }
};

pub fn create(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) Library {
    var ret = b.addStaticLibrary("yaml", null);
    ret.setTarget(target);
    ret.setBuildMode(mode);
    ret.linkLibC();
    ret.addCSourceFiles(srcs, &.{});
    ret.addIncludeDir(include_dir);

    ret.defineCMacro("YAML_VERSION_MAJOR", "0");
    ret.defineCMacro("YAML_VERSION_MINOR", "2");
    ret.defineCMacro("YAML_VERSION_PATCH", "5");
    ret.defineCMacro("YAML_VERSION_STRING", "\"0.2.5\"");
    ret.defineCMacro("YAML_DECLARE_STATIC", "1");

    return Library{ .step = ret };
}

const srcs = &.{
    root() ++ "libyaml/src/api.c",
    root() ++ "libyaml/src/dumper.c",
    root() ++ "libyaml/src/emitter.c",
    root() ++ "libyaml/src/loader.c",
    root() ++ "libyaml/src/parser.c",
    root() ++ "libyaml/src/reader.c",
    root() ++ "libyaml/src/scanner.c",
    root() ++ "libyaml/src/writer.c",
};
