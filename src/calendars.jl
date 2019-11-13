"""
`create_exp_calendar`
Method1: recount days of experiment
Method2: recount days according to changes in a manipulation
days is a Symbol  for the column that stores the actual days
"""
function create_exp_calendar(df::AbstractDataFrame,days::Symbol)
    lista = sort!(union(df[:,days]))
    Exp_day = Array{Int64,1}()
    Day = []
    for (n,d) in enumerate(lista)
        push!(Exp_day,Int64(n))
        push!(Day,d)
    end
    x = DataFrame(Exp_Day = Exp_day, Day = Day)
    #x[!,days] = Day
    return x
end

function create_exp_calendar(df::AbstractDataFrame,days::Symbol,manipulation::Symbol)
    x = by(df,days) do dd
        DataFrame(Manipulation = join(unique(dd[:, :Protocol]),"*"),
        Flexi = length(union(dd[:,:Protocol])) == 2)
    end
    what = string(manipulation)
    new_name = Symbol(what*"_Day")
    reordered = sortperm(x,(days))
    x = x[reordered,:]
    x[!,new_name] = Flipping_hf.count_series(x[:,:Manipulation])
    return x
end
