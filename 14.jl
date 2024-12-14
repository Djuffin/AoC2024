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

function move(bots, seconds)
    for b in bots
        b.x = mod(b.x + b.dx * seconds, 101)
        b.y = mod(b.y + b.dy * seconds, 103)
    end
end

function safety(bots)
    tl = count(b -> b.x < 50 && b.y < 51, bots)
    tr = count(b -> b.x > 50 && b.y < 51, bots)
    bl = count(b -> b.x < 50 && b.y > 51, bots)
    br = count(b -> b.x > 50 && b.y > 51, bots)
    tl * tr * bl * br
end

bots = read_input()
move(bots, 100)

print(safety(bots))