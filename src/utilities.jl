"""
"count_series"
useful to count an ordered series of categorical values, wheter they are the same or
they change
"""
function count_trues(count::T, same) where {T <: Number}
    if same
        count+1
    else
        1
    end
end

function check_series(x)
    Vector = [false]
    for i = 2:size(x,1)
        push!(Vector,x[i] == x[i-1] ? true : false)
    end
    return Vector
end

function count_series(vector)
    x = check_series(vector)
    res = accumulate(count_trues,x;init=0)
    return res
end
