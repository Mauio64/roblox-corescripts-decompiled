local AppChat = script:FindFirstAncestor("AppChat")

local AppChatNetworking = require(AppChat.Parent.AppChatNetworking)
local getDeepValue = require(AppChat.Utils.getDeepValue)

local Logger = require(AppChat.Logger)

local function markConversationAsRead(value)
	return function(object)
		local deepValue = getDeepValue(object:getState(), string.format("ChatAppReducer.Conversations.%s", value or ""))

		if deepValue and deepValue.hasUnreadMessages then
			Logger:info("Marking conversation {} as read", value)
			object:dispatch(AppChatNetworking.rodux.MarkConversation.API(value)):catch(function(p)
				Logger:error(`AppChatNetworking failure in markConversationAsRead, Status: {tostring(p)}`)
			end)
		end
	end
end

return markConversationAsRead
