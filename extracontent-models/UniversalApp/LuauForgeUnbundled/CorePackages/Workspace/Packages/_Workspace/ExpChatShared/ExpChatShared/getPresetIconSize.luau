local function ceilToEven(p2)
	local v5 = math.ceil(p2)

	if v5 % 2 == 1 then
		v5 += 1
	end

	return (math.max(0, v5))
end

return function(p2)
	local v5 = math.ceil(p2 * 3 / 4)

	if v5 % 2 == 1 then
		v5 += 1
	end

	return (math.max(0, v5))
end
