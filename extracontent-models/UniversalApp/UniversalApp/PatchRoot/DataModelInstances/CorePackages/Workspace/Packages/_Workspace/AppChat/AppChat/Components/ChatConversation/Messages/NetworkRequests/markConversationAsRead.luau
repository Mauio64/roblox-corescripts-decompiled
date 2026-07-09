local AppChat = script:FindFirstAncestor("AppChat")
local AppChatNetworking = require(AppChat.Parent.AppChatNetworking)
local getDeepValue = require(AppChat.Utils.getDeepValue)
local Logger = require(AppChat.Logger)

local function markConversationAsRead(p1) -- line: 8
	-- upvalues: getDeepValue (copy), Logger (copy), AppChatNetworking (copy)
	return function(p2) -- line: 9
		-- upvalues: getDeepValue (copy), p1 (copy), Logger (copy), AppChatNetworking (copy)
		local v8 = getDeepValue(p2:getState(), string.format("ChatAppReducer.Conversations.%s", p1 or ""))

		if v8 and v8.hasUnreadMessages then
			Logger:info("Marking conversation {} as read", p1)
			p2:dispatch(AppChatNetworking.rodux.MarkConversation.API(p1)):catch(function(p3) -- line: 14
				-- upvalues: Logger (copy)
				Logger:error(`AppChatNetworking failure in markConversationAsRead, Status: { tostring(p3) }`)
			end)
		end
	end
end

return markConversationAsRead
