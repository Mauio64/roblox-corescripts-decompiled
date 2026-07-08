local function getFormatTime(n1: number) -- line: 7
	local v3 = math.max(0, (math.floor(n1)))
	local v4 = math.floor(v3 / 60)
	local v5 = v3 % 60

	return string.format("%d:%02d", v4, v5)
end

return getFormatTime
