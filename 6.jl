width = 0;
rows = []
for line in readlines("input6.txt")
    global width = length(line)
    push!(rows, collect(line))
end
height = length(rows)

m = Matrix{Char}(undef, height, width)
for i in eachindex(rows)
    m[i, :] = rows[i]
end

dir_change = Dict(
    (0, -1) => (1, 0),
    (1, 0) => (0, 1),
    (0, 1) => (-1, 0),
    (-1, 0) => (0, -1)
)

function main()
    y,x = Tuple(findfirst(isequal('^'), m))
    dx = 0
    dy = -1
    path = Set()
    function is_in(x, y)
        x > 0 && y > 0 && x <= width && y <= height
    end
    function obstacle(x, y)
        is_in(x, y) && m[y,x] == '#'
    end

    while is_in(x, y)
        push!(path, (x,y))
        nx, ny = x + dx, y + dy
        while obstacle(nx, ny)
            dx, dy = dir_change[(dx,dy)]
            nx, ny = x + dx, y + dy
        end
        x,y = nx,ny
    end
    path
end

print(length(main()))