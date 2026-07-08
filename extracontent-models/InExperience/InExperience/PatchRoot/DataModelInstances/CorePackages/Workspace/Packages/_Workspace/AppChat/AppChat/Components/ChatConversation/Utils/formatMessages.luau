local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)
local ArgCheck = require(AppChatParent.ArgCheck)

return function(p1, p2) -- line: 8
	-- upvalues: ArgCheck (copy), Cryo (copy), EnumMessageTypes (copy)
	ArgCheck.isType(p1, "table", "formatMessages.messages")
	ArgCheck.isType(p2, "table", "formatMessages.messageData")

	return Cryo.List.map(p1, function(p3) -- line: 12
		-- upvalues: Cryo (copy), p2 (copy), EnumMessageTypes (copy)
		if p3.placeId or p3.shareLink then
			return Cryo.Dictionary.join(p2, p3, {
				messageType = EnumMessageTypes.Link,
				content = Cryo.None
			})
		end

		return Cryo.Dictionary.join(p2, p3)
	end)
end
