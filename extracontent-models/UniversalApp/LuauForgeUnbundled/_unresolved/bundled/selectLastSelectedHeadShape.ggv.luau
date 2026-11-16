require("@luauforge/bundled/dMd")

require("@luauforge/bundled/dHK")

local function selectLastSelectedHeadShape(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.LastTryOnClassicHeadShape
end

return selectLastSelectedHeadShape
