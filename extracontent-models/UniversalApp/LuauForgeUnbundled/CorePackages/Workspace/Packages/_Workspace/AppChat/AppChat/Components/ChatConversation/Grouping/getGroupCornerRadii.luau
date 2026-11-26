local MessageGroupShape = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/MessageGroupShape")

local direction = MessageGroupShape.Direction
local position = MessageGroupShape.Position

local function getGroupCornerRadii(p2, p3)
	if p2.position == position.Only then
		return { topLeft = p3, topRight = p3, bottomLeft = p3, bottomRight = p3 }
	end

	local v5 = p2.position ~= position.First and 0 or p3
	local v6 = p2.position ~= position.Last and 0 or p3

	if p2.direction == direction.Incoming then
		return { topLeft = v5, topRight = p3, bottomLeft = v6, bottomRight = p3 }
	end

	return { topLeft = p3, topRight = v5, bottomLeft = p3, bottomRight = v6 }
end

return getGroupCornerRadii
