local Color = {}

function Color.RgbFromHex(p)
	local v = p >= 0 and p <= 16777215
	assert(v, "RgbFromHex: Out of range")

	local v2 = p % 256
	local v3 = (p - v2) / 256
	local v4 = v3 % 256
	return (v3 - v4) / 256, v4, v2
end

function Color.Color3FromHex(p)
	return Color3.fromRGB(Color.RgbFromHex(p))
end

return Color
