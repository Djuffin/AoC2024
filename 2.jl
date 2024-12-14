function safe(vec)
    direction = nothing
    for (prev, curr) in zip(vec, Iterators.rest(vec, 2))
        diff = prev - curr
        if abs(diff) > 3 || abs(diff) < 1
            println(prev, " ", curr)
            return false
        end
        if !isnothing(direction) && direction != signbit(diff)
            println("#", prev, " ", curr)
            return false
        end
        direction = signbit(diff)
    end
    true
end

function supersafe(vec)
    if safe(vec)
        return true
    end
    for i in 1:length(vec)
        v = copy(vec)
        deleteat!(v, i)
        if safe(v)
            return true
        end
    end
    return false
end


reports = []
for line in readlines("input2.txt")
    report = parse.(Int, split(line, " "))
    push!(reports, report)
end

result = count(supersafe, reports)
println(result)
