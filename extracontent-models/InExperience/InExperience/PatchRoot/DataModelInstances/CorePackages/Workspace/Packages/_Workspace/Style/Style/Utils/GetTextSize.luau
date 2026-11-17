local parent = script:FindFirstAncestor("Style").Parent

local UIBlox = require(parent.UIBlox)
local getTextSize = UIBlox.Core.Text.GetTextSize

local vector2 = Vector2.new(2, 2)

local function getTextSize2(p: string, p2: number, p3, vector2_2: Vector2, p4)
	local textSize = getTextSize(p, p2, p3, vector2_2)

	if p4 == nil or p4.addTemporaryPadding ~= false then
		return textSize
	end

	return textSize - vector2
end

return getTextSize2
