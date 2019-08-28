dir         = "/Users/kcenia/Desktop/HFF_Results/"
files1      = readdir(dir)
Select_file = files1[occursin.(r"FC0..................STIM",files1)][3]
MatLab_path = joinpath(dir,Select_file)

t = read_headfix_mat(MatLab_path)

#Creating a DataFrame
df = DataFrame()
for n in variable_types[:values_per_streak]
    df[Symbol(n)] = t[n][:,1]
end
df

#Adding Variables ##########################################################
df[:MouseID]                = t["Subject"]
df[:Session]                = t["Session"][1:6]
n_licks_array               = t["SubtrialNumber"] #every subtrial number is equal to 1 lick
df[:Lick_Number]            = [length(n_licks_array[i]) for i in 1:length(n_licks_array)]
n_licks_array
#Reward Number
# r       = []
# for i   = 1:length(df[:MouseID])
#     mask    = .!isnan.(t["Reward"][i])
#     #if it is false, gives a 0
#     #and also if it is a 1-element row
#     if length(findall(mask))<1
#         #write element 0 in array r
#         push!(r,0)
#     else
#         println(i)
#         ongoing = sum(t["Reward"][i][mask])
#         push!(r,ongoing)
#     end
# end
df[:Reward_Number] = count_reward_number(t["Reward"])
length(t["Reward"])
ar_rew = t["Reward"]
typeof(ar_rew)

#Finding Last Reward
rew_array = t["Reward"]
length(rew_array)
##Using a function
df[:Last_Reward]            = find_last_rew(rew_array)


#After Last
df[:number_afterlast]       =  df[:Lick_Number] .- df[:Last_Reward]


#Correcting NaNs and missings regarding time Variables
df[end,:timeEnd]            = df[end,:timeStart]+1
df[:timeDif]                = df[:timeEnd] .- df[:timeStart]

df[:Dur_LastValidLick]      = df[:timeLastValidLickOut] .- df[:timeLastValidLick]

df[:Dur_LickingTime]        = df[:timeLastValidLickOut] .- df[:timeFirstValidLick]

df[:timeStartTravel][1]     = 0


#this is to delete 1st row, where timeEndTravel is NaN
All_data = deleterows!(df,1)
