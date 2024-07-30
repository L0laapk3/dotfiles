python
# append PYTHONPATH with path to:
# - `wget https://raw.githubusercontent.com/llvm/llvm-project/release/18.x/libcxx/utils/gdb/libcxx/printers.py`
# - gcc-*.*.*/python/libstdcxx/v*

# LLVM
try:
    from printers import register_libcxx_printer_loader
    register_libcxx_printer_loader()
except:
    pass

# GCC
try:
    from printers import register_libstdcxx_printers
    register_libstdcxx_printers(None)
except:
    pass

from gdb import execute
execute("set disassembly-flavor intel")

end