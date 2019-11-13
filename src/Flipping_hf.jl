module Flipping_hf

using Reexport
@reexport using MAT
@reexport using DataFrames
using ShiftedArrays
using FileIO

include("constants.jl")
include("utilities.jl")
include("search_files.jl")
include("get_values.jl")
include("processed_vars.jl")
include("calendars.jl")
include("process_streaks.jl")
include("process_data.jl")
include("my_fun.jl")

export variable_types, create_DataIndex


end
