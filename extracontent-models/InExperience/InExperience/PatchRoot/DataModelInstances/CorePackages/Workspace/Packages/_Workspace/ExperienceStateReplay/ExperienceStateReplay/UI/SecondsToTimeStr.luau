return {
	convertSecondsToTimeStr = function(n1: number) -- line: 3
		local v2 = math.round(n1) % 60
		local v3 = math.round(n1) // 60 % 60
		local v4 = math.round(n1) // 60 // 60 // 24

		return string.format("%02d", v4) .. ":" .. string.format("%02d", v3) .. ":" .. string.format("%02d", v2)
	end
}
