local function getFormatTime(n1: number) -- line: 1
	local v3 = math.floor(n1 / 60)
	local v4 = math.floor(n1 % 60)

	return string.format("%01d:%02d", v3, v4)
end

return getFormatTime
