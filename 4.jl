
width = 0;
rows = []
for line in readlines("input4.txt")
    global width = length(line)
    push!(rows, collect(line))
end
height = length(rows)

function in_boud(x, y)
    x > 0 && y > 0 && x <= width && y <= height
end

word = ['X', 'M', 'A', 'S']
result = 0

directions = [ (1,0), (1,1), (0,1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1) ]
for y in 1:height
    for x in 1:width

        for (dx, dy) in directions
            nx = x
            ny = y
    
            for letter in word
                if !in_boud(nx,ny) || letter != rows[ny][nx]
                    break
                end
                nx += dx
                ny += dy

                if letter == 'S'
                    global result += 1
                end
            end
        end
    end
end

println(result)