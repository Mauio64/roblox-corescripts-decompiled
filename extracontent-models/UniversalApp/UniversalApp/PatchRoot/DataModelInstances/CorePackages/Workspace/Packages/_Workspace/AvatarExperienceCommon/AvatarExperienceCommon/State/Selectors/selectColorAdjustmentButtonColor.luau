local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local FFlagAXColorAdjustmentButtonShouldAccountForTryOns = require(Parent.AvatarExperienceFlags).FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local selectAvatarPreviewColors = require(script.Parent.selectAvatarPreviewColors)

local function selectColorAdjustmentButtonColor(p1) -- line: 8
	-- upvalues: FFlagAXColorAdjustmentButtonShouldAccountForTryOns (copy), selectAvatarPreviewColors (copy)
	local v6 = if not FFlagAXColorAdjustmentButtonShouldAccountForTryOns then p1.AvatarExperience.AvatarEditor.Character.BodyColor3s else selectAvatarPreviewColors(p1)

	if v6 then
		local headColor3 = v6.headColor3
		local torsoColor3 = v6.torsoColor3

		return headColor3 or (torsoColor3 or Color3.new())
	end

	return Color3.new()
end

return selectColorAdjustmentButtonColor
