function main()
    lines = readlines("input19.txt")
    towel_patterns = split(lines[1], ", ")
    designs = lines[3:end]

    function count_ways(design, patterns)
        n = length(design)
        dp = fill(0, n + 1)
        dp[1] = 1

        for i in 2:n+1
            for pattern in patterns
                len = length(pattern)
                if i - len >= 1 && design[i-len:i-1] == pattern
                    dp[i] += dp[i-len]
                end
            end
        end
        return dp[n+1]
    end

    total_ways = 0
    for design in designs
        ways = count_ways(design, towel_patterns)
        if ways > 0
            total_ways += ways
        end
    end

    total_ways
end

println(main())