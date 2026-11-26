local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local EnumMessageTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EnumMessageTypes")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")

return function(p2, p3)
	ArgCheck.isType(p2, "table", "formatMessages.messages")
	ArgCheck.isType(p3, "table", "formatMessages.messageData")

	return Cryo.List.map(p2, function(p4)
		if p4.placeId or p4.shareLink then
			return Cryo.Dictionary.join(p3, p4, {
				messageType = EnumMessageTypes.Link,
				content = Cryo.None
			})
		end

		return Cryo.Dictionary.join(p3, p4)
	end)
end
