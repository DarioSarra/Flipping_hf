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
"""
`flatten`
"""
function flatten(df, datavar)
	# prepare an empty Vector to store the lengths of the vectors in the rows to flatten
	N = nrow(df)
	lengths = Vector{Int64}(undef, nrow(df))
	#fill the vector with the length of the vectors in the rows to flatten
	for i in 1:N
	    lengths[i] = length(df[i, datavar])
	end
	#calculate the length of the new DataFrame
	new_N = sum(lengths)

	# Create a new DataFrame with the same column names and column element types as df with the extended number of rows
	new_df = similar(df[!, Not(datavar)], new_N)
	n = names(new_df)


	counter = 1 #a variable that keep increasing at each loop to ensure that rows are edited sequentially
	for i in 1:N #loop in each row of the original dataframe
		for j in 1:lengths[i] #loop in the vector of lengths of the vectors in the rows to flatten
			for name in n
				new_df[counter, name] = df[i, name]
			end
			new_df
			counter += 1 #increasing counter make sure you are not re-editing the first rows
		end
	end

	new_df[!, datavar] = reduce(vcat, df[!, datavar])

	return new_df
end

function flatten2(df, datavar)
	N = nrow(df)
	lengths = Array{Int64}(undef, nrow(df),length(datavar))

	for (n,c) in enumerate(datavar)
	    for i in 1:N
	        lengths[i,n] = length(df[i, c])
	    end
	end

	for i in 1:size(lengths,1)
	    if !Flipping_hf.allequal(lengths[i,:])
	        error("vectors dimensions not mathing, row $i")
	    end
	end

	new_N = sum(lengths[:,1])
	new_df = similar(df[!, Not(datavar)], new_N)
	n = names(new_df)

	counter = 1 #a variable that keep increasing at each loop to ensure that rows are edited sequentially
	for i in 1:N #loop in each row of the original dataframe
		for j in 1:lengths[i] #loop in the vector of lengths of the vectors in the rows to flatten
			for name in n
				new_df[counter, name] = df[i, name]
			end
			new_df
			counter += 1 #increasing counter make sure you are not re-editing the first rows
		end
	end

	for x in datavar
		println(x)
		new_df[!, x] = reduce(vcat, df[!, x])
	end

	return new_df
end
# function flatten2(df,datavar) # not functional
# 	df2 =  similar(df[!, Not(datavar)], new_N)
# 	for i in Iterators.flatten(Iterators.product.(Ref.(df.cat), df.vec))
#     	push!(df2, i)
# 	end
# end
#
# function flatten3(df) # not functional
# 	df2 = @from i in df begin
# 	    @from j in i.vec
# 	    @select {cat=i.cat, vec=j}
# 	    @collect DataFrame
# 	end
# end
"""
´all_equal´
"""
function allequal(x)
    length(x) < 2 && return true
    e1 = first(x)
    i = 2
    @inbounds for i=2:length(x)
        x[i] == e1 || return false
    end
    return true
end
