local Parent = script:FindFirstAncestor("Moments").Parent

require(Parent.Foundation)

local function getColorStyleWithTransparency(p1, n1: number) -- line: 10
	return {
		Color3 = p1.Color3,
		Transparency = 1 - (1 - (p1.Transparency or 0)) * (1 - n1)
	}
end

return getColorStyleWithTransparency
