local parent = script:FindFirstAncestor("AppChat").Parent
local RealtimeDelivery = require(parent.RealtimeDelivery)

local Constants = require(script.Parent.Constants)
require(script.Parent.PlatformChatConversationTypes)

local function useRealtimePlatformChatConversation(callback, p)
	RealtimeDelivery.useRealtimeNamespace(Constants.PlatformChatConversation.Namespace, callback, p)
end

return useRealtimePlatformChatConversation
