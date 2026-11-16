local TextChatService = game:GetService("TextChatService")

local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)

local function useChatWindowReport(callback)
	return React.useCallback(function(p)
		local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		if chatWindowConfiguration and callback then
			callback(p, chatWindowConfiguration)
		end
	end, { callback })
end

return useChatWindowReport
