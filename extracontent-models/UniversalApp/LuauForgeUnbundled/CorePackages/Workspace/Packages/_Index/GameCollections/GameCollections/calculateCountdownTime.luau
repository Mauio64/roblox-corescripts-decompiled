local function calculateCountdownTime(p2)
	local v5 = p2 + 59

	local v6 = 0
	local v7 = 0
	local v8

	if v5 >= 86400 then
		v8 = math.floor(v5 / 86400)
		v5 -= v8 * 86400
	else
		v8 = 0
	end

	if v5 >= 3600 then
		v6 = math.floor(v5 / 3600)
		v5 -= v6 * 3600
	end

	if v5 > 0 then
		v7 = math.floor(v5 / 60)
	end

	return { days = v8, hours = v6, minutes = v7 }
end

return calculateCountdownTime
