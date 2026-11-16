local function getElapsedTimeMs(p2)
	local v5 = (os.clock() - p2) * 1000

	if v5 <= 0 then
		return 0
	end

	return math.round(v5 * 100) / 100
end

return getElapsedTimeMs
