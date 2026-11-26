local function getFormatTime(p2)
	local v5 = math.max(0, (math.floor(p2)))
	local v6 = math.floor(v5 / 60)
	local v7 = v5 % 60
	return string.format("%d:%02d", v6, v7)
end

return getFormatTime
