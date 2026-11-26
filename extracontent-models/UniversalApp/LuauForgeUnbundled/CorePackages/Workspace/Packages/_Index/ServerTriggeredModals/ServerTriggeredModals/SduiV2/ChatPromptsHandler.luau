local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local NotificationsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/NotificationsUpsell")
local usePushPermissionClientAttributes = NotificationsUpsell.usePushPermissionClientAttributes
local useOpenPendingLegacyUpsell = NotificationsUpsell.ChatPushUpsellLegacyPrompt.useOpenPendingLegacyUpsell

local promptsHandler = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsHandler").PromptsHandler
local PromptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsEntryPoint")

local function ChatPromptsHandler()
	local v5 = usePushPermissionClientAttributes()
	useOpenPendingLegacyUpsell()

	if v5 == nil then
		return nil
	end

	return React.createElement(promptsHandler, {
		entryPoint = PromptsEntryPoint.ChatLandingOpen,
		clientAttributes = v5
	})
end

return ChatPromptsHandler
