filename = "input15.txt"
function read_map()
    width = 0;
    rows = []
    for line in readlines(filename)
        if isempty(line)
            break
        end
        width = length(line) * 2
        push!(rows, collect(line))
    end
    height = length(rows)

    m = Matrix{Char}(undef, height, width)
    for i in eachindex(rows)
        j = 1
        for c in rows[i]
            if c == '.' || c == '#'
                m[i,j] = m[i,j + 1] = c
            elseif c == 'O'
                m[i,j] = '['
                m[i,j + 1] = ']'
            elseif c == '@'
                m[i,j] = '@'
                m[i,j + 1] = '.'
            end
            j += 2
        end
    end
    print_m(m)
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

function push_x(m, x, y, dx)
    ox, oy = x, y
    saved_m = copy(m)
    prev = m[y,x]
    x += dx
    while m[y, x] != '.'
        if m[y, x] == '#'
            copy!(m, saved_m)
            return (ox,oy)
        end
        m[y, x], prev = prev, m[y,x]
        x += dx
    end

    m[y, x] = prev
    m[oy, ox] = '.'
    return (ox + dx, oy)
end

function push_y(m, lx, rx, y, dy)
    if all(i -> m[y, i] == '.', lx:rx)
        return true
    end
    if any(i -> m[y, i] == '#', lx:rx)
        return false
    end

    if m[y, lx] == ']'
        lx -= 1
    end
    if m[y, rx] == '['
        rx += 1
    end
    saved_m = copy(m)
    for x in lx:rx
        if m[y, x] == '['
            if !push_y(m, x, x + 1, y + dy, dy)
                copy!(m, saved_m)
                return false
            end
        elseif m[y, x] == '@'
            if !push_y(m, x, x, y + dy, dy)
                return false
            end
        end
    end

    for x in lx:rx
        if m[y,x] != '.'
            m[y + dy, x] = m[y, x]
        end
         m[y, x] = '.'
    end

    return true
end

function make_move(m, x, y, dx, dy)
    if dx != 0
        return push_x(m, x, y, dx)
    end
    if push_y(m, x, x, y, dy)
        return (x, y + dy)
    end
    (x,y)
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
            if m[y,x] == '['
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

