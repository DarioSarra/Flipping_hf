function process_streak_old(t::Dict{String,Any})
    df = DataFrame()
    for n in variable_types[:values_per_streak]
        df[Symbol(n)] = t[n][:,1]
    end
    df
    #Adding Variables ##########################################################
    df.MouseID = t["Subject"]
    df.Session = t["Session"][1:6]
    n_licks_array = t["SubtrialNumber"] #every subtrial number is equal to 1 lick
    df.Lick_Number = [length(n_licks_array[i]) for i in 1:length(n_licks_array)]
    df.Reward_Number = Flipping_hf.count_reward_number(t["Reward"])
    df.Last_Reward  = Flipping_hf.find_last_rew(t["Reward"])
    df.AfterLast =  df[:,:Lick_Number] .- df[:,:Last_Reward]
    df[end,:timeEnd] = df[end,:timeStart]+1
    df.timeDif = df[:,:timeEnd] .- df[:,:timeStart]
    df.Dur_LastValidLick = df[:,:timeLastValidLickOut] .- df[:,:timeLastValidLick]
    df.Dur_LickingTime = df[:,:timeLastValidLickOut] .- df[:,:timeFirstValidLick]
    df[1,:timeStartTravel] = 0
    return df
end

function process_streak(filename::String)
    t = Flipping_hf.matread(filename)
    t = t["dataParsed"] #this way we reduce the typing

    df = DataFrame()
    for n in variable_types[:values_per_streak]
        df[!,Symbol(n)] = t[n][:,1]
    end

    removable = []
    for n in variable_types[:removable_per_streak]
        if length(union(df[:,Symbol(n)])) == 1
            push!(removable,Symbol(n))
        end
    end
    select!(df,Not(removable))
    df.Protocol = @. string(Int64(df.LeftHighRewardProb)) * "-" * string(Int64(df.FlippingGamma))
    df[!,:MouseID] .= t["Subject"]
    df[!,:Day] .= t["Session"][1:6]
    df.Session = @. df.MouseID * "_" * string(df.Day)
    df.Licks = [length(x) for x in Flipping_hf.reshape_vars(t,"SubtrialNumber")]
    df.Rewards = [Flipping_hf.get_reward(x) for x in Flipping_hf.reshape_vars(t,"Reward")]
    provisory = [findlast(skipmissing(x).>0) for x in Flipping_hf.reshape_clean(t,"Reward")]
    df.LastReward = [x == nothing ? 0 : x for x in provisory]
    df.AfterLast = df.Licks .- df.LastReward
    df.Trial_duration = df. timeLastValidLick .- df.timeFirstValidLick
    df[!,:StimDay] .= length(union(df.Stim)) > 1
    pre_Post_Interpoke = [maximum(Flipping_hf.get_interlick(x)) for x in Flipping_hf.reshape_vars(t,"timeLickIn")]
    df.Post_Interpoke = [x < 0 ? missing : x for x in pre_Post_Interpoke]
    pre_Travel = (df.timeEndTravel .- df.timeStartTravel) ./1000
    df.Travel = [isnan(x) ? missing : x for x in pre_Travel]
    return df
end
