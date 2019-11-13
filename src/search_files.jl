function create_DataIndex(;Directory_path = "/Users/kcenia/Desktop/HFF_KB_Results/")
    files1 = readdir(Directory_path)
    correct_files = files1[occursin.(r".mat",files1)]
    DataIndex = DataFrame(Bhv_files = correct_files)
    DataIndex.Bhv_path = @. joinpath(Directory_path,DataIndex.Bhv_files)
    DataIndex.MouseID = Flipping_hf.get_MouseID.(DataIndex.Bhv_path)
    DataIndex.Day = Flipping_hf.get_Date.(DataIndex.Bhv_path)
    DataIndex.Dayly_session = Flipping_hf.get_SessionCounter.(DataIndex.Bhv_path)
    DataIndex.Session = @. DataIndex.MouseID * "_" * string(DataIndex.Day)
    saving_path = joinpath(Directory_path,"Bhv")
    if !ispath(saving_path)
        mkdir(saving_path)
    end
    DataIndex[!,:Saving_path] .= saving_path
    DataIndex.Preprocessed_path = joinpath.(DataIndex.Saving_path,DataIndex.Session)
    return DataIndex
end
