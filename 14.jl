mutable struct Bot
    x::Int32
    y::Int32
    dx::Int32
    dy::Int32
end

function read_input()
    bots = []
    for line in readlines("input14.txt")
        let m = match(r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)", line)
            push!(bots, Bot(parse(Int, m.captures[1]), 
                            parse(Int, m.captures[2]), 
                            parse(Int, m.captures[3]), 
                            parse(Int, m.captures[4])))
        end

    end
    bots
end

height = 103
width = 101
function move(bots)
    for b in bots
        b.x = mod(b.x + b.dx , width)
        b.y = mod(b.y + b.dy , height)
    end
end

function safety(bots)
    tl = count(b -> b.x < 50 && b.y < 51, bots)
    tr = count(b -> b.x > 50 && b.y < 51, bots)
    bl = count(b -> b.x < 50 && b.y > 51, bots)
    br = count(b -> b.x > 50 && b.y > 51, bots)
    tl * tr * bl * br
end

function distance(bots)
    cx = ceil(sum(b -> b.x, bots) / length(bots))
    cy = ceil(sum(b -> b.y, bots) / length(bots))
    sum(b -> sqrt((b.x - cx)^2 + (b.y - cy)^2), bots) / length(bots)
end

function print_map(bots)
    screen = fill(' ', (height, width))
    for b in bots
        if screen[b.y + 1, b.x + 1] == ' '
            screen[b.y + 1, b.x + 1] = '*'
        end
    end 
    for row in eachrow(screen)
        println((join(row)))
    end
end

bots = read_input()
for i in 1:10000
    move(bots)
    d = distance(bots)
    if i == 100
        println("safety: ", safety(bots))
    end
    if d > 30
        continue
    end
    println("time: $i $(d) =============================================================")
    print_map(bots)
end

