local function getFormatTime(p: number)
	local v = math.max(0, (math.floor(p)))
	local v2 = math.floor(v / 60)
	local v3 = v % 60
	return string.format("%d:%02d", v2, v3)
end

return getFormatTime
