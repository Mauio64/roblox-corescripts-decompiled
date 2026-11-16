local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local function blendColors(p, p2)
	local v = 1 - (p2.Transparency or 0)
	local v2 = 1 - (p.Transparency or 0)

	if v == 1 or v2 == 0 or p.Color3 == nil then
		return p2
	end

	if v == 0 then
		return p
	end

	local v3 = 1 - v

	local v4 = v + v2 * v3

	local v5 = v4 > 0 and 1 / v4 or 0

	local v6 = (p2.Color3.R * v + p.Color3.R * (v2 * v3)) * v5

	local v7 = (p2.Color3.G * v + p.Color3.G * (v2 * v3)) * v5

	local v8 = (p2.Color3.B * v + p.Color3.B * (v2 * v3)) * v5

	return {
		Color3 = Color3.new(v6, v7, v8),
		Transparency = 1 - v4
	}
end

return blendColors
