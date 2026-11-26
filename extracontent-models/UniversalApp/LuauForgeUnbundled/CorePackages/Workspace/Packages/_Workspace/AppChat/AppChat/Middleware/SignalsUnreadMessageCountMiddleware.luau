local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local GetUnreadMessageCountStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetUnreadMessageCountStore")

local function handleGetConversationMetadataSucceeded(p2)
	GetUnreadMessageCountStore(false).receivedConversationMetadata(p2.responseBody)
end

local handleGetConversationMetadataSucceededsByName = {
	[AppChatNetworking.rodux.GetConversationMetadata.Succeeded.name] = handleGetConversationMetadataSucceeded
}

local function SignalsUnreadMessageCountMiddleware(callback, p2)
	return function(p3)
		local v5 = callback(p3)

		local v6 = handleGetConversationMetadataSucceededsByName[p3.type]

		if v6 then
			v6(p3)
		end

		return v5
	end
end

return SignalsUnreadMessageCountMiddleware
