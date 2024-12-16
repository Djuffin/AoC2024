filename = "input16.txt"
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

struct State
    x::Int32
    y::Int32
    dx::Int32
    dy::Int32
    distance::Int32
    parent::Any
end

Base.:(==)(p1::State, p2::State) = (p1.x == p2.x) && (p1.y == p2.y) && (p1.dx == p2.dx) && (p1.dy == p2.dy)
Base.hash(p::State, h::UInt) = hash(p.y, hash(p.x, hash(p.dx, hash(p.dy, h))))

cw = Dict(
    (0, -1) => (1, 0),
    (1, 0) => (0, 1),
    (0, 1) => (-1, 0),
    (-1, 0) => (0, -1)
)
ccw = Dict(
     (1, 0) => (0, -1),
     (0, 1) => (1, 0),
     (-1, 0) => (0, 1),
     (0, -1) => (-1, 0)
)

dir_to_sign = Dict(
    (1, 0) => '>',
    (0, 1) => 'v',
    (-1, 0) => '<',
    (0, -1) => '^'
)

function get_next_states(s)
    states = []

    push!(states, State(s.x + s.dx, s.y + s.dy, s.dx, s.dy, s.distance + 1, s))

    d = cw[(s.dx, s.dy)]
    push!(states, State(s.x, s.y, d[1], d[2], s.distance + 1000, s))

    d = ccw[(s.dx, s.dy)]
    push!(states, State(s.x, s.y, d[1], d[2], s.distance + 1000, s))

    states
end

function is_valid_state(m, s)
    m[s.y, s.x] != '#'
end

function print_m(m)
    for y in 1:size(m, 1)
       println(join(m[y, :]))
    end
end

function search(m, start_state, ex, ey)
    visited_states = Dict()
    visited_states[start_state] = start_state.distance
    candidates = []
    solutions = []
    best_distance = nothing

    append!(candidates, get_next_states(start_state))
    while !isempty(candidates)
        s = popfirst!(candidates)
        if !is_valid_state(m, s)
            continue
        end

        existing_distance = get!(visited_states, s, nothing)
        if !isnothing(existing_distance) && existing_distance < s.distance
            continue
        end

        if s.x == ex && s.y == ey
            push!(solutions, s)
            if isnothing(best_distance) || best_distance > s.distance
                best_distance = s.distance
            end
            continue
        end
        visited_states[s] = s.distance
        if isnothing(best_distance) || best_distance > s.distance
            append!(candidates, get_next_states(s))
        end
    end

    filter!(s -> s.distance == best_distance, solutions)
    locations = Set()
    for s in solutions
        l = s
        while !isnothing(l)
          push!(locations, (l.x, l.y))
          l = l.parent
        end
    end
    for l in locations
        m[l[2], l[1]] = 'O'
    end
    print_m(m)

    return (best_distance, length(locations))
end

function main()
    m = read_map()
    sy,sx = Tuple(findfirst(isequal('S'), m))
    ey,ex = Tuple(findfirst(isequal('E'), m))
    start_state = State(sx, sy, 1, 0, 0, nothing)
    search(m,start_state, ex, ey)
end

println(main())