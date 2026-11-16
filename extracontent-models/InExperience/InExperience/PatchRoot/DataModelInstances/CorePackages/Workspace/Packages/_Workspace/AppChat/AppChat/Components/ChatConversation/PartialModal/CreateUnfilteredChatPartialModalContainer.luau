local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils2.Hooks.useEffectOnMount
local Hooks = require(parent.SquadsCore.Hooks)
local useIsLocalPlayerPartyVoiceEligible = Hooks.useIsLocalPlayerPartyVoiceEligible
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local useState = React.useState

local AppChatNetworking = require(parent.AppChatNetworking)
local EventNames = require(AppChat.Analytics.EventNames)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local PartialModal = require(script.Parent.PartialModal)

local v = {
	conversationId = "",
	onDismissed = function() end,
	navigateToConversation = function(_) end,
	navigateToToast = function(_) end,
	titleKey = "Feature.Chat.Heading.CreateUnfilteredChatDialog",
	bodyKey = "Feature.Chat.Description.CreateUnfilteredChatDialog",
	bodyKeyWithVoice = "Feature.Chat.Description.CreateUnfilteredChatWithVoice",
	networkErrorTextKey = "Feature.Toast.NetworkingError.SomethingIsWrong",
	actionKey = "Feature.Chat.Action.Create",
	cancelAlertKey = "Feature.Chat.Action.Cancel"
}

local function CreateUnfilteredChatPartialModalContainer(p)
	local union = Cryo.Dictionary.union(v, p)
	local style = useStyle()
	local screenSize = useScreenSize()
	local v2 = useLayerCollector()

	if v2 and v2.absoluteSize then
		screenSize = v2.absoluteSize
	end

	local state, setState = useState(false)
	local v3 = useDispatch()
	local v4 = useAnalytics()
	local v5 = useIsLocalPlayerPartyVoiceEligible()

	useEffectOnMount(function()
		if v4 then
			v4.fireAnalyticsEvent(EventNames.ConversationUpgradeDialogRendered, {
				conversationId = union.conversationId
			})
		end
	end)

	local v6 = useLocalization({
		networkErrorText = union.networkErrorTextKey,
		titleText = union.titleKey,
		bodyText = union.bodyKey,
		bodyTextWithVoice = union.bodyKeyWithVoice,
		actionText = union.actionKey,
		cancelAlertText = union.cancelAlertKey
	})

	local v7 = useCallback(function()
		union.navigateToToast(v6.networkErrorText)
	end, { union.navigateToToast, v6.networkErrorText })

	local onActivated = useCallback(function()
		if v4 then
			v4.fireAnalyticsEvent(EventNames.ConversationUpgradeDialogActionClicked, {
				conversationId = union.conversationId
			})
		end

		setState(true)
		v3(AppChatNetworking.rodux.DuplicateConversation.API(union.conversationId, "trusted_comms")):andThen(function(p2)
			local responseBody = p2.responseBody

			local id = responseBody
				and responseBody.conversations
				and responseBody.conversations[1]
				and responseBody.conversations[1].id

			if id then
				union.navigateToConversation(id)
			else
				v7()
			end
		end):catch(function()
			v7()
		end):finally(function()
			setState(false)
		end)
	end, { v3, setState, v7, union.navigateToConversation, union.conversationId, v4 })

	local onDismissed = useCallback(function()
		if v4 then
			v4.fireAnalyticsEvent(EventNames.ConversationUpgradeDialogDismissed, {
				conversationId = union.conversationId
			})
		end

		union.onDismissed()
	end, { union.onDismissed, v4, union.conversationId })

	local createElement = React.createElement
	local v8 = {
		titleText = v6.titleText,
		bodyText = 0,
		actionText = 0,
		cancelAlertText = 0,
		isButtonDisabled = 0,
		screenSize = 0,
		onActivated = 0,
		onDismissed = 0,
		style = 0
	}

	local bodyText = if v5 then v6.bodyTextWithVoice else v6.bodyText
	v8.bodyText = bodyText

	v8.actionText = v6.actionText
	v8.cancelAlertText = v6.cancelAlertText
	v8.isButtonDisabled = state
	v8.screenSize = screenSize

	v8.onActivated = onActivated
	v8.onDismissed = onDismissed

	v8.style = style
	return createElement(PartialModal, v8)
end

return memo(CreateUnfilteredChatPartialModalContainer)
