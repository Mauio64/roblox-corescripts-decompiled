local ChatBubbleEnum = require(script.Parent.ChatBubbleEnum)
local MessageGroupShape = require(script.Parent.Parent.Grouping.MessageGroupShape)
local getGroupCornerRadii = require(script.Parent.Parent.Grouping.getGroupCornerRadii)

local v = {
	[ChatBubbleEnum.BUBBLE_VARIANTS.SINGLE] = MessageGroupShape.Position.Only,
	[ChatBubbleEnum.BUBBLE_VARIANTS.TOP] = MessageGroupShape.Position.First,
	[ChatBubbleEnum.BUBBLE_VARIANTS.MIDDLE] = MessageGroupShape.Position.Middle,
	[ChatBubbleEnum.BUBBLE_VARIANTS.BOTTOM] = MessageGroupShape.Position.Last
}

local function getChatBubbleCornerRadii(p, flag: boolean, p2: number)
	local direction

	if flag then
		direction = MessageGroupShape.Direction.Incoming
	else
		direction = MessageGroupShape.Direction.Outgoing
	end

	return getGroupCornerRadii({ direction = direction, position = v[p] }, p2)
end

return getChatBubbleCornerRadii
