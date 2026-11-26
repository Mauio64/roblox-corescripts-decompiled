local FFlagAppChatDebounceConversationFocusActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDebounceConversationFocusActivation")

local FIntAppChatConversationFocusActivationDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatConversationFocusActivationDelayMs")

if FFlagAppChatDebounceConversationFocusActivation then
	return FIntAppChatConversationFocusActivationDelayMs / 1000
end

return nil
