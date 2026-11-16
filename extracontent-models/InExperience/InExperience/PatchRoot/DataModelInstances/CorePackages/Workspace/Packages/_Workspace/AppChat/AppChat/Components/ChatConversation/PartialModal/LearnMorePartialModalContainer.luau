local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize

local EventNames = require(AppChat.Analytics.EventNames)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local PartialModal = require(script.Parent.PartialModal)

local v = {
	conversationId = "",
	onDismissed = function() end,
	titleKey = "Feature.Chat.Heading.ExpressiveChat",
	bodyKey = "Feature.Chat.Description.ExpressiveChatLearnMore",
	cancelAlertKey = "CommonUI.Features.Action.Close"
}

local function LearnMorePartialModalContainer(p)
	local union = Cryo.Dictionary.union(v, p)
	local style = useStyle()
	local screenSize = useScreenSize()
	local v2 = useLayerCollector()

	if v2 and v2.absoluteSize then
		screenSize = v2.absoluteSize
	end

	local v3 = useAnalytics()

	useEffectOnMount(function()
		if v3 then
			v3.fireAnalyticsEvent(EventNames.ConversationLearnMoreDialogRendered, {
				conversationId = union.conversationId
			})
		end
	end)

	local onDismissed = useCallback(function()
		if v3 then
			v3.fireAnalyticsEvent(EventNames.ConversationLearnMoreDialogDismissed, {
				conversationId = union.conversationId
			})
		end

		union.onDismissed()
	end, { v3, union.conversationId, union.onDismissed })

	local v4 = useLocalization({
		titleText = union.titleKey,
		bodyText = union.bodyKey,
		cancelAlertText = union.cancelAlertKey
	})

	return React.createElement(PartialModal, {
		titleText = v4.titleText,
		bodyText = v4.bodyText,
		cancelAlertText = v4.cancelAlertText,
		screenSize = screenSize,
		onDismissed = onDismissed,
		style = style
	})
end

return memo(LearnMorePartialModalContainer)
