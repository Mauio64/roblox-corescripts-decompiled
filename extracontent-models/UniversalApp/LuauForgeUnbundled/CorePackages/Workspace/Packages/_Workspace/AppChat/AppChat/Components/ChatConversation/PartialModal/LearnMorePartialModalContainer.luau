require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")
local useCallback = React.useCallback
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useEffectOnMount
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useScreenSize

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local PartialModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/PartialModal")

local v5 = {
	conversationId = "",
	onDismissed = function() end,
	titleKey = "Feature.Chat.Heading.ExpressiveChat",
	bodyKey = "Feature.Chat.Description.ExpressiveChatLearnMore",
	cancelAlertKey = "CommonUI.Features.Action.Close"
}

local function LearnMorePartialModalContainer(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = useStyle()
	local v7 = useScreenSize()
	local v8 = useLayerCollector()

	if v8 and v8.absoluteSize then
		v7 = v8.absoluteSize
	end

	local v9 = useAnalytics()

	useEffectOnMount(function()
		if v9 then
			v9.fireAnalyticsEvent(EventNames.ConversationLearnMoreDialogRendered, {
				conversationId = union.conversationId
			})
		end
	end)

	local v10 = useCallback(function()
		if v9 then
			v9.fireAnalyticsEvent(EventNames.ConversationLearnMoreDialogDismissed, {
				conversationId = union.conversationId
			})
		end

		union.onDismissed()
	end, { v9, union.conversationId, union.onDismissed })

	local v11 = useLocalization({
		titleText = union.titleKey,
		bodyText = union.bodyKey,
		cancelAlertText = union.cancelAlertKey
	})

	return React.createElement(PartialModal, {
		titleText = v11.titleText,
		bodyText = v11.bodyText,
		cancelAlertText = v11.cancelAlertText,
		screenSize = v7,
		onDismissed = v10,
		style = v6
	})
end

return memo(LearnMorePartialModalContainer)
