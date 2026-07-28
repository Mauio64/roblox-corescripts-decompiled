local Parent = script:FindFirstAncestor("AppChat").Parent
local RealtimeDelivery = require(Parent.RealtimeDelivery)
local Constants = require(script.Parent.Constants)

require(script.Parent.PlatformChatConversationTypes)

local function useRealtimePlatformChatConversation(p1: ((...any) -> ...any), t1: {[any]: any}) -- line: 10
	-- upvalues: RealtimeDelivery (copy), Constants (copy)
	RealtimeDelivery.useRealtimeNamespace(Constants.PlatformChatConversation.Namespace, p1, t1)
end

return useRealtimePlatformChatConversation
