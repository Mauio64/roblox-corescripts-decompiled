local Parent = script:FindFirstAncestor("AppChat").Parent
local Rodux = require(Parent.Rodux)
local AppChatNetworking = require(Parent.AppChatNetworking)

return Rodux.createReducer(0, {
	[AppChatNetworking.rodux.GetConversationMetadata.Succeeded.name] = function(n1: number, p1) -- line: 10
		local responseBody = p1.responseBody

		if responseBody and responseBody.global_unread_message_count then
			return responseBody.global_unread_message_count
		end

		return n1
	end
})
