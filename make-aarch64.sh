#!/bin/bash

# if [ ! -f "samples/rust/rust_module_parameters_builtin_default.rs" ]; then
#     cp samples/rust/rust_module_parameters.rs samples/rust/rust_module_parameters_builtin_default.rs
#     cp samples/rust/rust_module_parameters.rs samples/rust/rust_module_parameters_builtin_custom.rs
#     cp samples/rust/rust_module_parameters.rs samples/rust/rust_module_parameters_loadable_default.rs
#     cp samples/rust/rust_module_parameters.rs samples/rust/rust_module_parameters_loadable_custom.rs

#     sed -i 's:rust_module_parameters:rust_module_parameters_builtin_default:g'  samples/rust/rust_module_parameters_builtin_default.rs
#     sed -i 's:rust_module_parameters:rust_module_parameters_builtin_custom:g'   samples/rust/rust_module_parameters_builtin_custom.rs
#     sed -i 's:rust_module_parameters:rust_module_parameters_loadable_default:g' samples/rust/rust_module_parameters_loadable_default.rs
#     sed -i 's:rust_module_parameters:rust_module_parameters_loadable_custom:g'  samples/rust/rust_module_parameters_loadable_custom.rs

#     echo 'obj-m	+= rust_module_parameters_builtin_default.o'  >> samples/rust/Makefile
#     echo 'obj-m	+= rust_module_parameters_builtin_custom.o'   >> samples/rust/Makefile
#     echo 'obj-m	+= rust_module_parameters_loadable_default.o' >> samples/rust/Makefile
#     echo 'obj-m	+= rust_module_parameters_loadable_custom.o'  >> samples/rust/Makefile
# fi

time make ARCH=arm64 LLVM=1 O=build LOG=info -j16
