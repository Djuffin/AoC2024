using DelimitedFiles

input = readdlm("input1.txt", Int64)
left = []
right = Dict()

for row in eachrow(input)
    push!(left, row[1])
    right[row[2]] = get(right, row[2], 0) + 1
end

total = sum(k -> k * get(right, k, 0), left);

println(total);