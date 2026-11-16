local parent = script:FindFirstAncestor("Moments").Parent

require(parent.Foundation)

local function getColorStyleWithTransparency(p, p2: number)
	return {
		Color3 = p.Color3,
		Transparency = 1 - (1 - (p.Transparency or 0)) * (1 - p2)
	}
end

return getColorStyleWithTransparency
