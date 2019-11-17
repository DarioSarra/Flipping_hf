function process_data(DataIndex)
    streaks = DataFrame()
    for idx=1:size(DataIndex,1)
        try
            streaks_data = Flipping_hf.process_streak(DataIndex[idx,:Bhv_path])
            if isempty(streaks)
                streaks = streaks_data
            else
                try
                    append!(streaks, streaks_data)
                catch
                    append!(streaks, streaks_data[:, names(streaks)])
                end
            end
        catch
            println(DataIndex[idx,:Session])
            continue
        end
    end
    exp_calendar = by(streaks,:MouseID) do dd
        Flipping_hf.create_exp_calendar(dd,:Day)
    end
    protocol_calendar = by(streaks,:MouseID) do dd
        Flipping_hf.create_exp_calendar(dd,:Day,:Protocol)
    end
    if !any(protocol_calendar[:,:Flexi])
        select!(protocol_calendar,DataFrames.Not([:Manipulation,:Flexi]))
    end
    streaks = join(streaks, exp_calendar, on = [:MouseID,:Day], kind = :inner,makeunique=true);
    streaks = join(streaks, protocol_calendar, on = [:MouseID,:Day], kind = :inner,makeunique=true);
    mask = occursin.(String.(names(streaks)),"_1")
    for x in[names(streaks)[mask]]
        DataFrames.select!(streaks,DataFrames.Not(x))
    end
    filetosave = joinpath(DataIndex.Saving_path[1],"streaks.csv")
    FileIO.save(filetosave,streaks)
    licks = Flipping_hf.flatten2(streaks,Symbol.(variable_types[:array_within_streak]))
    filetosave = joinpath(DataIndex.Saving_path[1],"licks.csv")
    FileIO.save(filetosave,licks)
    return DataIndex, streaks, licks
end
