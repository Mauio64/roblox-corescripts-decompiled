return {
	convertSecondsToTimeStr = function(p: number)
		local v = math.round(p) % 60
		local v2 = math.round(p) // 60 % 60
		local v3 = math.round(p) // 60 // 60 // 24
		return string.format("%02d", v3) .. ":" .. string.format("%02d", v2) .. ":" .. string.format("%02d", v)
	end
}
