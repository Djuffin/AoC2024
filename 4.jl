
width = 0;
rows = []
for line in readlines("input4.txt")
    global width = length(line)
    push!(rows, collect(line))
end
height = length(rows)

function is_x(x, y)
    rows[y][x] == 'A' && 
        (
            (rows[y - 1][x - 1] == 'M' && rows[y + 1][x + 1] == 'S') ||
            (rows[y - 1][x - 1] == 'S' && rows[y + 1][x + 1] == 'M')
        ) &&
        (
            (rows[y - 1][x + 1] == 'M' && rows[y + 1][x - 1] == 'S') ||
            (rows[y - 1][x + 1] == 'S' && rows[y + 1][x - 1] == 'M')
        )
    
end

word = ['X', 'M', 'A', 'S']
result = 0

for y in 2:(height - 1)
    for x in 2:(width - 1)
        if is_x(x, y)
            global result += 1
        end
    end
end

println(result)