load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

################################ Python Setup ################################
http_archive(
    name = "rules_python",
    sha256 = "8c8fe44ef0a9afc256d1e75ad5f448bb59b81aba149b8958f02f7b3a98f5d9b4",
    strip_prefix = "rules_python-0.13.0",
    url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.13.0.tar.gz",
)

load("@rules_python//python:repositories.bzl", "python_register_toolchains")

python_register_toolchains(
    name = "python3_9",
    ignore_root_user_error = True,
    python_version = "3.9",
    register_toolchains = False,
)

################################ TensorFlow Setup ################################

# To update TensorFlow to a new revision,
# a) update URL and strip_prefix to the new git commit hash
# b) get the sha256 hash of the commit by running:
#    curl -L https://github.com/tensorflow/tensorflow/archive/<git hash>.tar.gz | sha256sum
#    and update the sha256 with the result.
http_archive(
    name = "org_tensorflow",
    patch_args = ["-p1"],
    patch_tool = "patch",
    patches = [
        "//tf_patches:f16_abi_clang.diff",
        "//tf_patches:stream_executor.diff",
        "//tf_patches:thread_local_random.diff",
        "//tf_patches:xplane.diff",
        "//tf_patches:bazel.diff",
    ],
    sha256 = "a056b236c032a86ea0f361d6a7f97319e43e33144d8aaf44e42f0d154fde5c0a",
    strip_prefix = "tensorflow-29f29e5874ec25b5f26c990c3981dcd56288fd0c",
    urls = [
        "https://github.com/tensorflow/tensorflow/archive/29f29e5874ec25b5f26c990c3981dcd56288fd0c.tar.gz",
    ],
)

# For development, one often wants to make changes to the TF repository as well
# as the PyTorch/XLA repository. You can override the pinned repository above with a
# local checkout by either:
# a) overriding the TF repository on the build.py command line by passing a flag
#    like:
#    bazel --override_repository=org_tensorflow=/path/to/tensorflow
#    or
# b) by commenting out the http_archive above and uncommenting the following:
# local_repository(
#    name = "org_tensorflow",
#    path = "/path/to/tensorflow",
# )

# Initialize TensorFlow's external dependencies.
load("@org_tensorflow//tensorflow:workspace3.bzl", "tf_workspace3")

tf_workspace3()

load("@org_tensorflow//tensorflow:workspace2.bzl", "tf_workspace2")

tf_workspace2()

load("@org_tensorflow//tensorflow:workspace1.bzl", "tf_workspace1")

tf_workspace1()

load("@org_tensorflow//tensorflow:workspace0.bzl", "tf_workspace0")

tf_workspace0()

################################ PyTorch Setup ################################

load("//bazel:dependencies.bzl", "PYTORCH_LOCAL_DIR")

new_local_repository(
    name = "torch",
    build_file_content = """
package(
    default_visibility = [
        "//visibility:public",
    ],
)

filegroup(
    name = "srcs",
    srcs = glob(["**/*.h", "**/*.cpp", "**/*.yaml", "**/*.ini"]),
)

cc_library(
    name = "headers",
    srcs = glob(
      ["torch/include/**/*.h"],
      ["torch/include/google/protobuf/**/*.h"],
    ),
)
""",
    path = PYTORCH_LOCAL_DIR,
)

new_local_repository(
    name = "libtorch",
    build_file_content = """
cc_import(
    name = "libtorch",
    shared_library = "libtorch.so",
    visibility = ["//visibility:public"],
)
cc_import(
    name = "libtorch_cpu",
    shared_library = "libtorch_cpu.so",
    visibility = ["//visibility:public"],
)
cc_import(
    name = "libtorch_python",
    shared_library = "libtorch_python.so",
    visibility = ["//visibility:public"],
)
""",
    path = "%s/build/lib/" % PYTORCH_LOCAL_DIR,
)