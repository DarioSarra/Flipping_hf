using Revise
using Flipping_hf
##
dir         = "/Users/kcenia/Desktop/HFF_Results/"
files1      = readdir(dir)
Select_file = files1[occursin.(r"FC0..................STIM",files1)][3]
MatLab_path = joinpath(dir,Select_file)
##
t = Flipping_hf.read_headfix_mat(MatLab_path)
#Creating a DataFrame
ongoing = Flipping_hf.process_streak(t)

#Correcting NaNs and missings regarding time Variables



#this is to delete 1st row, where timeEndTravel is NaN
All_data = deleterows!(df,1)
