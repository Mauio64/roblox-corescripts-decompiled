local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RealtimeDelivery")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/Constants")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/PlatformChatConversationTypes")

local function useRealtimePlatformChatConversation(p2, p3)
	RealtimeDelivery.useRealtimeNamespace(Constants.PlatformChatConversation.Namespace, p2, p3)
end

return useRealtimePlatformChatConversation
