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

    function adv(op)
        a = a >>> load_combo_op(op)
    end

    function bxl(op)
        b = xor(b, op)
    end

    function bst(op)
        b = load_combo_op(op) % 8
    end

    function jnz(op)
        if a != 0
            ip = op - 2
        end
    end

    function bxc(op)
        b = xor(b, c)
    end

    function out(op)
        push!(output, load_combo_op(op) % 8)
    end

    function bdv(op)
        b = a >>> load_combo_op(op)
    end

    function cdv(op)
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

output = execute(read_input()...)
println(join(output, ','))