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

function is_in(x, y)
    x > 0 && y > 0 && x <= width && y <= height
end
function obstacle(x, y)
    is_in(x, y) && m[y,x] == '#'
end

function find_way_out(x, y, dx, dy)
    path = Set()
    while is_in(x, y)
        if (x,y, dx, dy) in path
            return nothing
        end
        push!(path, (x,y, dx, dy))
        nx, ny = x + dx, y + dy
        while obstacle(nx, ny)
            dx, dy = dir_change[(dx,dy)]
            nx, ny = x + dx, y + dy
        end
        x,y = nx,ny
    end
    path
end

function main()
    y,x = Tuple(findfirst(isequal('^'), m))
    sx, sy = x,y
    path = find_way_out(sx, sy, 0, -1)
    obstacles = Set()
    for (x, y, dx, dy) in path
        if !obstacle(x, y) && is_in(x, y) && (x,y) != (sx, sy)
            m[y, x] = '#'
            if isnothing(find_way_out(sx, sy, 0, -1))
                push!(obstacles, (x, y))
            end
            m[y, x] = '.'
        end
    end
    obstacles
end

print(length(main()))