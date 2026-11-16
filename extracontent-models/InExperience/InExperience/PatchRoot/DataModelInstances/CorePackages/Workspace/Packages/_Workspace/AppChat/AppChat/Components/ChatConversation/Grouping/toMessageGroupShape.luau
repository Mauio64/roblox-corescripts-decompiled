local AppChat = script:FindFirstAncestor("AppChat")

local MessageGroupShape = require(AppChat.Components.ChatConversation.Grouping.MessageGroupShape)

local function toMessageGroupShape(flag: boolean?, flag2: boolean?, flag3: boolean?, flag4: boolean?)
	local position

	if flag and flag2 or flag3 then
		position = MessageGroupShape.Position.Only
	elseif flag then
		position = MessageGroupShape.Position.First
	elseif flag2 then
		position = MessageGroupShape.Position.Last
	else
		position = MessageGroupShape.Position.Middle
	end

	local direction

	if flag4 then
		direction = MessageGroupShape.Direction.Incoming
	else
		direction = MessageGroupShape.Direction.Outgoing
	end

	return { direction = direction, position = position }
end

return toMessageGroupShape
