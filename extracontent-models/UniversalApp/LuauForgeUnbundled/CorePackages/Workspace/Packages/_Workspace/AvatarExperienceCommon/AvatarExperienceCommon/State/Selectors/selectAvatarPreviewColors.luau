local join = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Dash").join

local selectHasBodyTryOn = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectHasBodyTryOn")
local selectDefaultTryOnBodyColors = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectDefaultTryOnBodyColors")

local function selectAvatarPreviewColors(p2)
	local outfitTryOn = p2.AvatarExperience.AvatarScene.OutfitTryOn
	local avatarEditor = p2.AvatarExperience.AvatarEditor
	local v5 = selectHasBodyTryOn(p2)
	local bodyColor3s = avatarEditor.Character.BodyColor3s
	local v6 = if outfitTryOn.DefaultTryOnBodyColorsToggled then selectDefaultTryOnBodyColors(p2) else outfitTryOn.BodyColor3s

	if v5 and bodyColor3s and v6 then
		return (join(bodyColor3s, v6))
	end

	return bodyColor3s
end

return selectAvatarPreviewColors
