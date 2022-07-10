const std = @import("std");
const libyaml = @import("libyaml.zig");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const yaml = libyaml.create(b, target, mode);
    yaml.step.install();
}
