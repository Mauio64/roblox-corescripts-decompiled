local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/UIBlox").Core.Text.GetTextSize

local vector2 = Vector2.new(2, 2)

local function getTextSize2(p2, p3, p4, p5, p6)
	local textSize = getTextSize(p2, p3, p4, p5)

	if p6 == nil or p6.addTemporaryPadding ~= false then
		return textSize
	end

	return textSize - vector2
end

return getTextSize2
