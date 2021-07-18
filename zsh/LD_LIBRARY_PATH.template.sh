# intel mkl begin
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/opt/intel/oneapi/mkl/latest/lib/intel64"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/opt/intel/oneapi/compiler/latest/linux/compiler/lib/intel64_lin"
# intel mkl end
# hdf5 begin ## 因为conda使用了更高版本的hdf5
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/x86_64-linux-gnu/hdf5/serial"
# hdf5 end