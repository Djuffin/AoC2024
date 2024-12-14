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

function abide(rules_set, update)
    for i in 1:length(update)
        for j in (i+1):length(update)
            if (update[j], update[i]) in rules_set
                return false
            end
        end
    end
    true
end

rules = Set(read_rules())
updates = read_updates()
updates = filter(u -> abide(rules, u), updates)
result = sum(u -> u[1 + div(length(u), 2)], updates)
println(result)