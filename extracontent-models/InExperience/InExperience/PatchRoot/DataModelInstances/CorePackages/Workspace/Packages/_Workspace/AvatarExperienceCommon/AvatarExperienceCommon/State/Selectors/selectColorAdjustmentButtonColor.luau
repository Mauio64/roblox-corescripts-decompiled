local selectAvatarPreviewColors = require(script.Parent.selectAvatarPreviewColors)

local function selectColorAdjustmentButtonColor(p)
	local v = selectAvatarPreviewColors(p)

	if not v then
		return Color3.new()
	end

	local headColor3 = v.headColor3
	local torsoColor3 = v.torsoColor3
	return headColor3 or torsoColor3 or Color3.new()
end

return selectColorAdjustmentButtonColor
