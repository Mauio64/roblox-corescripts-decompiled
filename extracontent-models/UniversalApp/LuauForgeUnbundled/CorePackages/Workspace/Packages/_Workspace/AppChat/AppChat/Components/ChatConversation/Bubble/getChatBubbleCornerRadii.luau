local ChatBubbleEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Bubble/ChatBubbleEnum")
local MessageGroupShape = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/MessageGroupShape")
local getGroupCornerRadii = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/getGroupCornerRadii")

local v5 = {
	[ChatBubbleEnum.BUBBLE_VARIANTS.SINGLE] = MessageGroupShape.Position.Only,
	[ChatBubbleEnum.BUBBLE_VARIANTS.TOP] = MessageGroupShape.Position.First,
	[ChatBubbleEnum.BUBBLE_VARIANTS.MIDDLE] = MessageGroupShape.Position.Middle,
	[ChatBubbleEnum.BUBBLE_VARIANTS.BOTTOM] = MessageGroupShape.Position.Last
}

local function getChatBubbleCornerRadii(p2, p3, p4)
	local v8 = if p3 then MessageGroupShape.Direction.Incoming else MessageGroupShape.Direction.Outgoing
	return getGroupCornerRadii({ direction = v8, position = v5[p2] }, p4)
end

return getChatBubbleCornerRadii
