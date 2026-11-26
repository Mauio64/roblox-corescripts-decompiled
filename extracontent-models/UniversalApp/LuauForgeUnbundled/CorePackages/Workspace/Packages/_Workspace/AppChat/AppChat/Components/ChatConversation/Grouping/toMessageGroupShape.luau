local MessageGroupShape = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/MessageGroupShape")

local function toMessageGroupShape(p2, p3, p4, p5)
	local v5

	if p2 and p3 or p4 then
		v5 = MessageGroupShape.Position.Only
	elseif p2 then
		v5 = MessageGroupShape.Position.First
	else
		v5 = if p3 then MessageGroupShape.Position.Last else MessageGroupShape.Position.Middle
	end

	local v6 = if p5 then MessageGroupShape.Direction.Incoming else MessageGroupShape.Direction.Outgoing
	return { direction = v6, position = v5 }
end

return toMessageGroupShape
