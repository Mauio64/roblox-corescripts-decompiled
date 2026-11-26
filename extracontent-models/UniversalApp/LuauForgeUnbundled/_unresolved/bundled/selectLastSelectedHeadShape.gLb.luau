require("@luauforge/bundled/dPt")

require("@luauforge/bundled/dKT")

local function selectLastSelectedHeadShape(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.LastTryOnClassicHeadShape
end

return selectLastSelectedHeadShape
