local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

local function ScrollToLatestButton(props)
	local v5 = useAnalytics()
	local v6 = useLocalization({
		jumpToLatestMessages = "Feature.Chat.Action.JumpToLatestMessages"
	})

	local conversationId = props.conversationId
	local messageListVersion = props.messageListVersion
	local onActivated = props.onActivated
	local v7 = React.useCallback(function()
		v5.fireAnalyticsEvent(EventNames.ConversationScrollToLatestBtnClicked, {
			conversationId = conversationId,
			messageListVersion = messageListVersion
		})

		onActivated()
	end, { v5, conversationId, messageListVersion, onActivated })

	return React.createElement(
		Foundation.View,
		{
			tag = "position-bottom-right anchor-bottom-right auto-xy padding-medium",
			ZIndex = 2,
			testId = "chat-conversation-scrollToLatest"
		},
		{
			Tooltip = React.createElement(
				Foundation.Tooltip,
				{
					title = v6.jumpToLatestMessages,
					side = popoverSide.Left,
					align = popoverAlign.Center
				},
				{
					Button = React.createElement(Foundation.IconButton, {
						icon = iconName.ChevronLargeDown,
						size = inputSize.Medium,
						variant = buttonVariant.Standard,
						isCircular = true,
						onActivated = v7,
						testId = "chat-conversation-scrollToLatest-button"
					})
				}
			)
		}
	)
end

return ScrollToLatestButton
