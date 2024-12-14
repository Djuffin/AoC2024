function read_rules()
    rules = []
    for line in readlines("input5.txt")
        let m = match(r"(\d+)\|(\d+)", line)
            if isnothing(m)
                return rules
            end
            push!(rules, (parse(Int, m.captures[1]), parse(Int, m.captures[2])))
        end

    end
    rules
end

function read_updates()
    updates = []
    for line in readlines("input5.txt")
        if occursin("|", line) || isempty(line)
            continue
        end
        push!(updates, parse.(Int, split(line, ",")))
    end
    updates
end

rules = Set(read_rules())

function before(a, b)
    (a,b) in rules
end

function abide(update)
    for i in eachindex(update)
        for j in (i+1):length(update)
            if before(update[j], update[i]) 
                return false
            end
        end
    end
    true
end

updates = read_updates()
updates = filter(u -> !abide(u), updates)
updates = map(u -> sort(u, lt = before), updates)
result = sum(u -> u[1 + div(length(u), 2)], updates)
println(result)