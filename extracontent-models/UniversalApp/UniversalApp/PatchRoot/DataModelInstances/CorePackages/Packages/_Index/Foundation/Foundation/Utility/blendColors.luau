local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local function blendColors(p1, t1: {[any]: any}) -- line: 14
	local v5 = 1 - (t1.Transparency or 0)
	local v6 = 1 - (p1.Transparency or 0)

	if v5 == 1 or (v6 == 0 or p1.Color3 == nil) then
		return t1
	end

	if v5 == 0 then
		return p1
	end

	local v7 = 1 - v5
	local v8 = v5 + v6 * v7
	local v9 = v8 > 0 and 1 / v8 or 0
	local v10 = (t1.Color3.R * v5 + p1.Color3.R * (v6 * v7)) * v9
	local v11 = (t1.Color3.G * v5 + p1.Color3.G * (v6 * v7)) * v9
	local v12 = (t1.Color3.B * v5 + p1.Color3.B * (v6 * v7)) * v9

	return {
		Color3 = Color3.new(v10, v11, v12),
		Transparency = 1 - v8
	}
end

return blendColors
