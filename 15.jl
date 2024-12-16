filename = "input15.txt"
function read_map()
    width = 0;
    rows = []
    for line in readlines(filename)
        if isempty(line)
            break
        end
        width = length(line)
        push!(rows, collect(line))
    end
    height = length(rows)
    
    m = Matrix{Char}(undef, height, width)
    for i in eachindex(rows)
        m[i, :] = rows[i]
    end
    m
end

function read_moves()
    moves = []
    dir_change = Dict(
        '>' => (1, 0),
        'v' => (0, 1),
        '<' => (-1, 0),
        '^' => (0, -1)
    )
    for line in readlines(filename)
        if occursin("#", line) || isempty(line)
            continue
        end
        append!(moves, map(c -> dir_change[c], collect(line)))
    end
    moves
end

function make_move(m, x, y, dx, dy)
    ox, oy = x, y
    
    x, y = x + dx, y + dy
    while m[y, x] != '.'
        if m[y, x] == '#'
            return (ox,oy)
        end
        x, y = x + dx, y + dy
    end
    
    m[y,x] = 'O'
    m[oy,ox] = '.'
    m[oy + dy,ox + dx] = '@'
    return (ox + dx, oy + dy)
end


function main()
    m = read_map()
    y,x = Tuple(findfirst(isequal('@'), m))
    
    moves = read_moves()
    for (dx, dy) in moves
        x,y = make_move(m, x, y, dx, dy)
        #println("move $x $y $dx $dy")
        #print_m(m)
    end
    
    gps = 0
    for y in 1:size(m, 1)
        for x in 1:size(m, 2)
            if m[y,x] == 'O'
                gps += (x - 1) + (y - 1) * 100
            end
        end
    end
    gps
end

function print_m(m)
    for y in 1:size(m, 1)
       println(join(m[y, :]))
    end    
end

println(main())

