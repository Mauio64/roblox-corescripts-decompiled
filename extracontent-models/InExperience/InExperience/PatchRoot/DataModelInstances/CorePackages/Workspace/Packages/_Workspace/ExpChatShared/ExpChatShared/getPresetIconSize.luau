local function ceilToEven(p: number) -- 1 equivalent call inferred from this helper
	local v = math.ceil(p)

	if v % 2 == 1 then
		v += 1
	end

	return (math.max(0, v))
end

return function(p: number)
	return ceilToEven(p * 3 / 4) -- inferred equivalent call
end
