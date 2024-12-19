function main()
    lines = readlines("input18.txt")
    coordinates = map(lines) do line
        x, y = parse.(Int, split(line, ","))
        return (x, y)
    end

    width = 71
    height = 71

    function path_exists(grid)
        queue = [(1, 1)]
        visited = Set([(1, 1)])

        while !isempty(queue)
            x, y = popfirst!(queue)

            if x == width && y == height
                return true
            end

            moves = [(-1, 0), (1, 0), (0, -1), (0, 1)]

            for (dx, dy) in moves
                nx, ny = x + dx, y + dy

                if 1 <= nx <= width && 1 <= ny <= height && grid[nx, ny] == '.' && !((nx, ny) in visited)
                    push!(queue, (nx, ny))
                    push!(visited, (nx, ny))
                end
            end
        end

        return false
    end

    grid = fill('.', width, height)
    for (i, (x, y)) in enumerate(coordinates)
        grid[x+1, y+1] = '#'

        if !path_exists(grid)
            println("$x,$y")
            break
        end
    end
end

main()