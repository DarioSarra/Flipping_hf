function process_streak(t::Dict{String,Any})
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
