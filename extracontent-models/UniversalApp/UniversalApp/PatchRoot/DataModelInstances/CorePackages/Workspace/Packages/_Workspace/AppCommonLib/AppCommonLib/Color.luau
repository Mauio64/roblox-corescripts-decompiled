local t1 = {
	RgbFromHex = function(p1) -- line: 3
		assert(p1 >= 0 and p1 <= 16777215, "RgbFromHex: Out of range")

		local v3 = p1 % 256
		local v4 = (p1 - v3) / 256
		local v5 = v4 % 256

		return (v4 - v5) / 256, v5, v3
	end
}

function t1.Color3FromHex(p2) -- line: 15
	-- upvalues: t1 (copy)
	return Color3.fromRGB(t1.RgbFromHex(p2))
end

return t1
