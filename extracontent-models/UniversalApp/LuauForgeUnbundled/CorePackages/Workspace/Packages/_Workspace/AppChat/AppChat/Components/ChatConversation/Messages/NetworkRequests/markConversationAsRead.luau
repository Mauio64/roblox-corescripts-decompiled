local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger")

local function markConversationAsRead(value)
	return function(object)
		local v5 = getDeepValue(object:getState(), string.format("ChatAppReducer.Conversations.%s", value or ""))

		if v5 and v5.hasUnreadMessages then
			Logger:info("Marking conversation {} as read", value)
			object:dispatch(AppChatNetworking.rodux.MarkConversation.API(value)):catch(function(p2)
				Logger:error(`AppChatNetworking failure in markConversationAsRead, Status: {tostring(p2)}`)
			end)
		end
	end
end

return markConversationAsRead
