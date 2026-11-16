local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)

local GetUnreadMessageCountStore = require(AppChat.Stores.GetUnreadMessageCountStore)

local function handleGetConversationMetadataSucceeded(p)
	GetUnreadMessageCountStore(false).receivedConversationMetadata(p.responseBody)
end

local handleGetConversationMetadataSucceededsByName = {
	[AppChatNetworking.rodux.GetConversationMetadata.Succeeded.name] = handleGetConversationMetadataSucceeded
}

local function SignalsUnreadMessageCountMiddleware(callback, _)
	return function(p)
		local v = callback(p)

		local v2 = handleGetConversationMetadataSucceededsByName[p.type]

		if v2 then
			v2(p)
		end

		return v
	end
end

return SignalsUnreadMessageCountMiddleware
