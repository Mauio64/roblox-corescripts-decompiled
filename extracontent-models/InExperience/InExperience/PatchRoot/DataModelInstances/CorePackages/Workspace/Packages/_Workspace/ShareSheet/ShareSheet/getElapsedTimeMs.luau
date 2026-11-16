local function getElapsedTimeMs(p: number)
	local v = (os.clock() - p) * 1000

	if v <= 0 then
		return 0
	end

	return math.round(v * 100) / 100
end

return getElapsedTimeMs
