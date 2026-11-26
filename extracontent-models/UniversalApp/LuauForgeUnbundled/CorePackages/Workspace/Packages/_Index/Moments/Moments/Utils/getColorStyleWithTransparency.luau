require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")

local function getColorStyleWithTransparency(p2, p3)
	return {
		Color3 = p2.Color3,
		Transparency = 1 - (1 - (p2.Transparency or 0)) * (1 - p3)
	}
end

return getColorStyleWithTransparency
