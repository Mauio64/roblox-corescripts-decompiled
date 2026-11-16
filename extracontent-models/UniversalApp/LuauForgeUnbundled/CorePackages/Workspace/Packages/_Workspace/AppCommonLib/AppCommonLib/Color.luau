local v5 = {}

function v5.RgbFromHex(p2)
	local v6 = p2 >= 0 and p2 <= 16777215
	assert(v6, "RgbFromHex: Out of range")

	local v7 = p2 % 256
	local v8 = (p2 - v7) / 256
	local v9 = v8 % 256
	return (v8 - v9) / 256, v9, v7
end

function v5.Color3FromHex(p2)
	return Color3.fromRGB(v5.RgbFromHex(p2))
end

return v5
