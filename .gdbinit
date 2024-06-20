python
# append PYTHONPATH with path to `wget https://raw.githubusercontent.com/llvm/llvm-project/release/18.x/libcxx/utils/gdb/libcxx/printers.py`
from printers import register_libcxx_printer_loader
register_libcxx_printer_loader()
end
