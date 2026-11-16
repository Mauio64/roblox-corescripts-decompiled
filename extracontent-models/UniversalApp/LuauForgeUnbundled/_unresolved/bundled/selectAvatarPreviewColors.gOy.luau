local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/gOz")

local function selectAvatarPreviewColors(p2)
	local outfitTryOn = p2.AvatarExperience.AvatarScene.OutfitTryOn
	local avatarEditor = p2.AvatarExperience.AvatarEditor
	local v5 = module(p2)
	local bodyColor3s = avatarEditor.Character.BodyColor3s
	local bodyColor3s2 = if not outfitTryOn.DefaultTryOnBodyColorsToggled then outfitTryOn.BodyColor3s else nil

	if v5 and bodyColor3s and bodyColor3s2 then
		return (Cryo.Dictionary.join(bodyColor3s, bodyColor3s2))
	end

	return bodyColor3s
end

return selectAvatarPreviewColors
