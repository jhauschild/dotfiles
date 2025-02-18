"""Random stuff I needed quick+dirty implemented as macros.

You probably don't need these plugins - this is just some random stuff I needed at some point.

This file needs to be placed as rplugin/python3/*.py in some nvim runtime directory.
If you add nvim commands etc, call `:UpdateRemotePlugins` from nvim.
"""
import pynvim
import re


@pynvim.plugin
class MyCustomPlugin(object):
    def __init__(self, nvim):
        self.nvim = nvim

        # matching    "    virtual bool func(int a, str b) const =0;\n"
        # to groups   "    "      "bool func(int a, str b) const "
        #                       "bool" "func" "int a, str b"    "=0"
        self.re_virtual_func = re.compile(r"(\s+)virtual ((.*)\s+(\S+)\((.*)\)[^=;]*)(=\s*0)?;$")

    @pynvim.command('MyPyb11Override', range='', nargs='1', sync=True)
    def command_handler(self, args, range):
        """call from nvim as :MyPb11Override Baseclassname

        on lines declaring virtual functions to expand line with PYBIND11_OVERRIDE[_PURE] macro.
        """
        base_class = args[0]  #  takes Base class name as argument
        line = self.nvim.current.line
        m = self.re_virtual_func.match(line)
        if not m:
            self.nvim.out_write("line doesn't match virtual function definition")
            return
        pre_ws, func_decl, ret_type, func_name, func_args, pure = m.groups()
        if func_args:
            arg_names = [type_arg.split()[-1] for type_arg in func_args.split(',')]
            arg_names = ", ".join(arg_names)
        else:
            arg_names = ""
        macro = "PYBIND11_OVERRIDE_PURE" if pure else "PYBIND11_OVERRIDE"
        replace_line = (f"{pre_ws}{func_decl} {{ {macro}("
                        f"{ret_type}, {base_class}, {func_name}, {arg_names}); }}")
        self.nvim.current.line = replace_line

