local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local React = require(parent.React)
local NotificationsUpsell = require(parent.NotificationsUpsell)
local usePushPermissionClientAttributes = NotificationsUpsell.usePushPermissionClientAttributes
local useOpenPendingLegacyUpsell = NotificationsUpsell.ChatPushUpsellLegacyPrompt.useOpenPendingLegacyUpsell

local PromptsHandler = require(script.Parent.PromptsHandler)
local promptsHandler = PromptsHandler.PromptsHandler
local PromptsEntryPoint = require(script.Parent.PromptsEntryPoint)

local function ChatPromptsHandler()
	local clientAttributes = usePushPermissionClientAttributes()
	useOpenPendingLegacyUpsell()

	if clientAttributes == nil then
		return nil
	end

	return React.createElement(promptsHandler, {
		entryPoint = PromptsEntryPoint.ChatLandingOpen,
		clientAttributes = clientAttributes
	})
end

return ChatPromptsHandler
