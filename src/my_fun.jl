function read_headfix_mat(file::String)
    #read MATLAB file
    t           = matread(file)
    #make it simpler to call the table
    t           = t["dataParsed"]
end


function find_last_rew(rew_array::AbstractArray)
    provisory = []
    for (idx,ar) in enumerate(rew_array)
        if typeof(ar) <: AbstractArray
            push!(provisory,findlast(x-> x==1,ar[:,1]))
        else
            push!(provisory,ar)
        end
    end
    #is x nothing? if yes, then 0; if no, then x
    [x == nothing ? 0 : x for x in provisory]
end

function count_reward_number(ar_rew)
    r       = []
    for i   = 1:length(ar_rew)
        mask    = .!isnan.(ar_rew[i])
        #if it is false, gives a 0
        #and also if it is a 1-element row
        if length(findall(mask))<1
            #write element 0 in array r
            push!(r,0)
        else
            ongoing = sum(ar_rew[i][mask])
            push!(r,ongoing)
        end
    end
    return r
end
