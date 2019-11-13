function reshape_vars(t,name::String)
    m = t[name]
    v = m[:,1]
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
