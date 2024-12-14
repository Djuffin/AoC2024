
cmd = r"(do\(\))|(don't\(\))|mul\((\d{1,3}),(\d{1,3})\)"

total = 0
process = true
for line in readlines("input3.txt")
    for m in eachmatch(cmd, line)
        println(m)
        if !isnothing(m.captures[1])
            global process = true
        elseif !isnothing(m.captures[2])
            global process = false
        elseif process
            result = parse(Int, m.captures[3]) * parse(Int, m.captures[4])
            global total += result
        end
    end
end

println(total)