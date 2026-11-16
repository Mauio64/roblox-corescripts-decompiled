local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local EventNames = require(AppChat.Analytics.EventNames)
local useAnalytics = require(AppChat.Analytics.useAnalytics)

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local function ScrollToLatestButton(props)
	local v = useAnalytics()
	local v2 = useLocalization({ jumpToLatestMessages = "Feature.Chat.Action.JumpToLatestMessages" })

	local conversationId = props.conversationId
	local messageListVersion = props.messageListVersion
	local onActivated = props.onActivated
	local onActivated2 = React.useCallback(function()
		v.fireAnalyticsEvent(EventNames.ConversationScrollToLatestBtnClicked, {
			conversationId = conversationId,
			messageListVersion = messageListVersion
		})

		onActivated()
	end, { v, conversationId, messageListVersion, onActivated })

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
					title = v2.jumpToLatestMessages,
					side = PopoverSide.Left,
					align = PopoverAlign.Center
				},
				{
					Button = React.createElement(Foundation.IconButton, {
						icon = IconName.ChevronLargeDown,
						size = InputSize.Medium,
						variant = ButtonVariant.Standard,
						isCircular = true,
						onActivated = onActivated2,
						testId = "chat-conversation-scrollToLatest-button"
					})
				}
			)
		}
	)
end

return ScrollToLatestButton
