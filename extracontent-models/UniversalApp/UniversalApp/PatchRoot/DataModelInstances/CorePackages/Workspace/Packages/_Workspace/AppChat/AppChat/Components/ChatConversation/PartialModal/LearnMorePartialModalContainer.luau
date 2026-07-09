local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useCallback = React.useCallback
local useEffectOnMount = require(AppChatParent.RoactUtils).Hooks.useEffectOnMount
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useScreenSize = require(AppChatParent.RobloxAppHooks).useScreenSize
local EventNames = require(AppChat.Analytics.EventNames)
local UIBlox = require(AppChatParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local PartialModal = require(script.Parent.PartialModal)
local t1 = {
	conversationId = "",
	titleKey = "Feature.Chat.Heading.ExpressiveChat",
	bodyKey = "Feature.Chat.Description.ExpressiveChatLearnMore",
	cancelAlertKey = "CommonUI.Features.Action.Close",
	onDismissed = function() -- line: 33
	end
}

local function LearnMorePartialModalContainer(t2: {[any]: any}) -- line: 40
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useScreenSize (copy), useLayerCollector (copy), useAnalytics (copy), useEffectOnMount (copy), EventNames (copy), useCallback (copy), useLocalization (copy), React (copy), PartialModal (copy)
	local v19 = Cryo.Dictionary.union(t1, t2)
	local v20 = useStyle()
	local v21 = useScreenSize()
	local v22 = useLayerCollector()

	if v22 and v22.absoluteSize then
		v21 = v22.absoluteSize
	end

	local v23 = useAnalytics()

	useEffectOnMount(function() -- line: 50
		-- upvalues: v23 (copy), EventNames (copy), v19 (copy)
		if v23 then
			v23.fireAnalyticsEvent(EventNames.ConversationLearnMoreDialogRendered, {
				conversationId = v19.conversationId
			})
		end
	end)

	local v24 = useCallback(function() -- line: 58
		-- upvalues: v23 (copy), EventNames (copy), v19 (copy)
		if v23 then
			v23.fireAnalyticsEvent(EventNames.ConversationLearnMoreDialogDismissed, {
				conversationId = v19.conversationId
			})
		end

		v19.onDismissed()
	end, {
		v23,
		v19.conversationId,
		v19.onDismissed
	})
	local v25 = useLocalization({
		titleText = v19.titleKey,
		bodyText = v19.bodyKey,
		cancelAlertText = v19.cancelAlertKey
	})

	return React.createElement(PartialModal, {
		titleText = v25.titleText,
		bodyText = v25.bodyText,
		cancelAlertText = v25.cancelAlertText,
		screenSize = v21,
		onDismissed = v24,
		style = v20
	})
end

return memo(LearnMorePartialModalContainer)
