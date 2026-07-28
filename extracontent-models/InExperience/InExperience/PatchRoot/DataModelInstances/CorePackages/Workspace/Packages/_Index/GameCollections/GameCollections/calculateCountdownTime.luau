local function calculateCountdownTime(n1: number) -- line: 11
	local v3 = n1 + 59
	local n2 = 0
	local n3 = 0
	local n4 = 0

	if v3 >= 86400 then
		n2 = math.floor(v3 / 86400)
		v3 -= n2 * 86400
	end

	if v3 >= 3600 then
		n3 = math.floor(v3 / 3600)
		v3 -= n3 * 3600
	end

	if v3 > 0 then
		n4 = math.floor(v3 / 60)
	end

	return {
		days = n2,
		hours = n3,
		minutes = n4
	}
end

return calculateCountdownTime
