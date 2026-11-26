local selectAvatarPreviewColors = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectAvatarPreviewColors")

local function selectColorAdjustmentButtonColor(p2)
	local v5 = selectAvatarPreviewColors(p2)

	if not v5 then
		return Color3.new()
	end

	local headColor3 = v5.headColor3
	local torsoColor3 = v5.torsoColor3
	return headColor3 or torsoColor3 or Color3.new()
end

return selectColorAdjustmentButtonColor
