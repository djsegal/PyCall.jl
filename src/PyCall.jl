__precompile__()

module PyCall

export pycall, pyimport, pybuiltin, PyObject, PyReverseDims,
       PyPtr, pyincref, pydecref, pyversion, PyArray, PyArray_Info,
       pyerr_check, pyerr_clear, pytype_query, PyAny, @pyimport, PyDict,
       pyisinstance, pywrap, pytypeof, pyeval, PyVector, pystring, pystr, pyrepr,
       pyraise, pytype_mapping, pygui, pygui_start, pygui_stop,
       pygui_stop_all, @pylab, set!, PyTextIO, @pysym, PyNULL, @pydef,
       pyimport_conda, @py_str, @pywith, @pycall, pybytes

import Base: size, ndims, similar, copy, getindex, setindex!, stride,
       convert, pointer, summary, convert, show, haskey, keys, values,
       eltype, get, delete!, empty!, length, isempty, start, done,
       next, filter!, hash, splice!, pop!, ==, isequal, push!,
       unshift!, shift!, append!, insert!, prepend!, mimewritable

# Python C API is not interrupt-save.  In principle, we should
# use sigatomic for every ccall to the Python library, but this
# should really be fixed in Julia (#2622).  However, we will
# use the sigatomic_begin/end functions to protect pycall and
# similar long-running (or potentially long-running) code.
import Base: sigatomic_begin, sigatomic_end

## Compatibility import for v0.5
using Compat
import Conda
import Base.unsafe_convert
import MacroTools   # because of issue #270

if isdefined(Base, :Iterators)
    import Base.Iterators: filter
end

#########################################################################

include(joinpath(dirname(@__FILE__), "..", "deps","depsutils.jl"))

using Boot

Boot.include_folder(PyCall, @__FILE__, verbose=true)

#########################################################################
# Precompilation: just an optimization to speed up initialization.
# Here, we precompile functions that are passed to cfunction by __init__,
# for the reasons described in JuliaLang/julia#12256.

precompile(pyjlwrap_call, (PyPtr,PyPtr,PyPtr))
precompile(pyjlwrap_dealloc, (PyPtr,))
precompile(pyjlwrap_repr, (PyPtr,))
precompile(pyjlwrap_hash, (PyPtr,))
precompile(pyjlwrap_hash32, (PyPtr,))

# TODO: precompilation of the io.jl functions

end # module PyCall
