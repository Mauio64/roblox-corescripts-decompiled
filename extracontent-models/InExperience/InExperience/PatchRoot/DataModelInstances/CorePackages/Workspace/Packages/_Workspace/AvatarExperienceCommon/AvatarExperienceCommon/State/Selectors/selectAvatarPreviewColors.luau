local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Dash = require(parent.Dash)
local join = Dash.join

local selectHasBodyTryOn = require(script.Parent.selectHasBodyTryOn)
local selectDefaultTryOnBodyColors = require(script.Parent.selectDefaultTryOnBodyColors)

local function selectAvatarPreviewColors(p)
	local outfitTryOn = p.AvatarExperience.AvatarScene.OutfitTryOn
	local avatarEditor = p.AvatarExperience.AvatarEditor
	local v = selectHasBodyTryOn(p)
	local bodyColor3s = avatarEditor.Character.BodyColor3s
	local v2

	if outfitTryOn.DefaultTryOnBodyColorsToggled then
		v2 = selectDefaultTryOnBodyColors(p)
	else
		v2 = outfitTryOn.BodyColor3s
	end

	if v and bodyColor3s and v2 then
		return (join(bodyColor3s, v2))
	end

	return bodyColor3s
end

return selectAvatarPreviewColors
