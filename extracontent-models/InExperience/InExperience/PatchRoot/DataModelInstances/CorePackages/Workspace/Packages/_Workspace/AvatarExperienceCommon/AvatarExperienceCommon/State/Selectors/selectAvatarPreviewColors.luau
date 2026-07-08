local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local join = require(Parent.Dash).join
local selectHasBodyTryOn = require(script.Parent.selectHasBodyTryOn)
local selectDefaultTryOnBodyColors = require(script.Parent.selectDefaultTryOnBodyColors)

local function selectAvatarPreviewColors(p1) -- line: 9
	-- upvalues: selectHasBodyTryOn (copy), selectDefaultTryOnBodyColors (copy), join (copy)
	local OutfitTryOn = p1.AvatarExperience.AvatarScene.OutfitTryOn
	local AvatarEditor = p1.AvatarExperience.AvatarEditor
	local v9 = selectHasBodyTryOn(p1)
	local BodyColor3s = AvatarEditor.Character.BodyColor3s
	local v11 = if not OutfitTryOn.DefaultTryOnBodyColorsToggled then OutfitTryOn.BodyColor3s else selectDefaultTryOnBodyColors(p1)

	if v9 and (BodyColor3s and v11) then
		return (join(BodyColor3s, v11))
	end

	return BodyColor3s
end

return selectAvatarPreviewColors
