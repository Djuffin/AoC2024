filename = "input17.txt"
function read_input()
    instructions = []
    a = 0
    b = 0
    c = 0
    for line in readlines(filename)
        if isempty(line)
            continue
        end
        if occursin("Register A", line)
            a = parse(Int, line[13:end])
            continue
        end
        if occursin("Register B", line)
            b = parse(Int, line[13:end])
            continue
        end
        if occursin("Register C", line)
            c = parse(Int, line[13:end])
            continue
        end
        if occursin("Program", line)
            instructions = parse.(Int, split(line[10:end],','))
            continue
        end
    end
    (a, b, c, instructions)
end

function execute(a,b,c, instructions)
    output = []
    ip = 0
    function load_combo_op(o)
        values = [0, 1, 2, 3, a, b, c]
        values[o + 1]
    end

    function adv(op) # 0
        a = a >>> load_combo_op(op)
    end

    function bxl(op) # 1
        b = xor(b, op)
    end

    function bst(op) # 2
        b = load_combo_op(op) & 7
    end

    function jnz(op) # 3
        if a != 0
            ip = op - 2
        end
    end

    function bxc(op) # 4
        b = xor(b, c)
    end

    function out(op) # 5
        push!(output, load_combo_op(op) % 8)
    end

    function bdv(op) # 6
        b = a >>> load_combo_op(op)
    end

    function cdv(op) # 7
        c = a >>> load_combo_op(op)
    end

    opcodes = Dict(
        0 => adv,
        1 => bxl,
        2 => bst,
        3 => jnz,
        4 => bxc,
        5 => out,
        6 => bdv,
        7 => cdv
    )

    while ip < length(instructions)
        opcode = instructions[ip + 1]
        operand = instructions[ip + 2]
        f = opcodes[opcode]
        f(operand)
        ip += 2
    end

    output
end

function make_a(octets)
    a = 0
    for (i,v) in enumerate(reverse(octets))
        a += v << (3 * (i - 1))
    end
    a
end

# Program: 2,4,  1,2,  7,5,  4,3,  0,3,  1,7,  5,5,  3,0
# b = a % 8      -- 2,4
# b = b xor 2    -- 1,2
# c = a >> b     -- 7,5
# b = b xor c    -- 4,3
# a = a >> 3     -- 0,3
# b = b xor 7    -- 1,7
# out B          -- 5,5
# jnz 0          -- 3,0

function search(instructions)
    octets = []
    program = reverse(instructions)

    function step(depth)
        if length(octets) > 16
            return nothing
        end
        for v in 0:7
            push!(octets, v)
            a = make_a(octets)

            result = execute(a, 0, 0, instructions)
            reverse!(result)
            match_count = 0
            for (x,y) in zip(program, result)
                if x != y
                    break
                end
                match_count += 1
            end
            if (match_count == 16)
                return a
            end
            if match_count == depth
                best_a = step(depth + 1)
                if !isnothing(best_a)
                    return best_a
                end
            end
            pop!(octets)
        end
    end

    step(1)
end

ins = read_input()[4]
guessed_a = search(ins)
println(guessed_a)
println(execute(guessed_a, 0, 0, ins))