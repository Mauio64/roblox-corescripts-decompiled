local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)
local ArgCheck = require(parent.ArgCheck)

return function(p, p2)
	ArgCheck.isType(p, "table", "formatMessages.messages")
	ArgCheck.isType(p2, "table", "formatMessages.messageData")

	return Cryo.List.map(p, function(p3)
		if p3.placeId or p3.shareLink then
			return Cryo.Dictionary.join(p2, p3, {
				messageType = EnumMessageTypes.Link,
				content = Cryo.None
			})
		end

		return Cryo.Dictionary.join(p2, p3)
	end)
end
