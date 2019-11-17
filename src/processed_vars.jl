function reshape_vars(t,name::String)
    m = t[name]
    v = m[:,1]
    reshaped = []
    for i in 1:length(v)
        if v[i] isa Real
            push!(reshaped,v[i])
        elseif v[i] isa AbstractArray{<:Real,2}
            push!(reshaped, v[i][:,1])
        else
            println("Array shape not implemented in reshape_vars check row $i")
        end
    end
    return reshaped
end

function reshape_clean(t,name)
    m = reshape_vars(t,name)
    [[isnan(x) ? missing : x for x in v] for v in m]
end

function get_reward(rew_array)
    mask = .!isnan.(rew_array)
    sum(mask)
end

function get_interlick(lick_array)
    if length(lick_array) < 2
        return NaN
    else
        return lead(lick_array; default = 0.0) .- lick_array
    end
end
