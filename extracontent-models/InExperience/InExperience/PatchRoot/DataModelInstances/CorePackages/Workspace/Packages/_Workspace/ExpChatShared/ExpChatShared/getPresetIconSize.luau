local function ceilToEven(n1: number) -- line: 1
	local v3 = math.ceil(n1)

	if v3 % 2 == 1 then
		v3 += 1
	end

	return (math.max(0, v3))
end

return function(n2: number) -- line: 9
	local v5 = math.ceil(n2 * 3 / 4)

	if v5 % 2 == 1 then
		v5 += 1
	end

	return (math.max(0, v5))
end
