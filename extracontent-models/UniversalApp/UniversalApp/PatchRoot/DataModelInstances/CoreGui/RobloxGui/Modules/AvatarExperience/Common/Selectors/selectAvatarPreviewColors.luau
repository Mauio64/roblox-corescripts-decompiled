local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local selectHasBodyTryOn = require(script.Parent.selectHasBodyTryOn)

local function selectAvatarPreviewColors(p1) -- line: 6
	-- upvalues: selectHasBodyTryOn (copy), Cryo (copy)
	local OutfitTryOn = p1.AvatarExperience.AvatarScene.OutfitTryOn
	local AvatarEditor = p1.AvatarExperience.AvatarEditor
	local v8 = selectHasBodyTryOn(p1)
	local BodyColor3s = AvatarEditor.Character.BodyColor3s
	local v10 = if OutfitTryOn.DefaultTryOnBodyColorsToggled then nil else OutfitTryOn.BodyColor3s

	if v8 and (BodyColor3s and v10) then
		return (Cryo.Dictionary.join(BodyColor3s, v10))
	end

	return BodyColor3s
end

return selectAvatarPreviewColors
