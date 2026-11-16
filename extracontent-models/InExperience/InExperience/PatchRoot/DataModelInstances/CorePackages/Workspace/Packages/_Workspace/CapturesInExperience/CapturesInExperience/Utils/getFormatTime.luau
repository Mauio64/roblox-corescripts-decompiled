local function getFormatTime(p: number)
	local v = math.floor(p / 60)
	local v2 = math.floor(p % 60)
	return string.format("%01d:%02d", v, v2)
end

return getFormatTime
