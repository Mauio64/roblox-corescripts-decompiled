require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")
local useCallback = React.useCallback
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useEffectOnMount
local useIsLocalPlayerPartyVoiceEligible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Hooks").useIsLocalPlayerPartyVoiceEligible
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useScreenSize
local useState = React.useState

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local PartialModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/PartialModal")

local v5 = {
	conversationId = "",
	onDismissed = function() end,
	navigateToConversation = function(p2) end,
	navigateToToast = function(p2) end,
	titleKey = "Feature.Chat.Heading.CreateUnfilteredChatDialog",
	bodyKey = "Feature.Chat.Description.CreateUnfilteredChatDialog",
	bodyKeyWithVoice = "Feature.Chat.Description.CreateUnfilteredChatWithVoice",
	networkErrorTextKey = "Feature.Toast.NetworkingError.SomethingIsWrong",
	actionKey = "Feature.Chat.Action.Create",
	cancelAlertKey = "Feature.Chat.Action.Cancel"
}

local function CreateUnfilteredChatPartialModalContainer(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = useStyle()
	local v7 = useScreenSize()
	local v8 = useLayerCollector()

	if v8 and v8.absoluteSize then
		v7 = v8.absoluteSize
	end

	local state, setState = useState(false)
	local v9 = useDispatch()
	local v10 = useAnalytics()
	local v11 = useIsLocalPlayerPartyVoiceEligible()

	useEffectOnMount(function()
		if v10 then
			v10.fireAnalyticsEvent(EventNames.ConversationUpgradeDialogRendered, {
				conversationId = union.conversationId
			})
		end
	end)

	local v12 = useLocalization({
		networkErrorText = union.networkErrorTextKey,
		titleText = union.titleKey,
		bodyText = union.bodyKey,
		bodyTextWithVoice = union.bodyKeyWithVoice,
		actionText = union.actionKey,
		cancelAlertText = union.cancelAlertKey
	})

	local v13 = useCallback(function()
		union.navigateToToast(v12.networkErrorText)
	end, { union.navigateToToast, v12.networkErrorText })

	local v14 = useCallback(function()
		if v10 then
			v10.fireAnalyticsEvent(EventNames.ConversationUpgradeDialogActionClicked, {
				conversationId = union.conversationId
			})
		end

		setState(true)
		v9(AppChatNetworking.rodux.DuplicateConversation.API(union.conversationId, "trusted_comms")):andThen(function(p3)
			local responseBody = p3.responseBody

			local id = responseBody
				and responseBody.conversations
				and responseBody.conversations[1]
				and responseBody.conversations[1].id

			if id then
				union.navigateToConversation(id)
			else
				v13()
			end
		end):catch(function()
			v13()
		end):finally(function()
			setState(false)
		end)
	end, { v9, setState, v13, union.navigateToConversation, union.conversationId, v10 })

	local v15 = useCallback(function()
		if v10 then
			v10.fireAnalyticsEvent(EventNames.ConversationUpgradeDialogDismissed, {
				conversationId = union.conversationId
			})
		end

		union.onDismissed()
	end, { union.onDismissed, v10, union.conversationId })

	local createElement = React.createElement
	local v17 = {
		titleText = v12.titleText,
		bodyText = 0,
		actionText = 0,
		cancelAlertText = 0,
		isButtonDisabled = 0,
		screenSize = 0,
		onActivated = 0,
		onDismissed = 0,
		style = 0
	}

	local v18 = if v11 then v12.bodyTextWithVoice else v12.bodyText
	v17.bodyText = v18

	v17.actionText = v12.actionText
	v17.cancelAlertText = v12.cancelAlertText
	v17.isButtonDisabled = state
	v17.screenSize = v7

	v17.onActivated = v14
	v17.onDismissed = v15

	v17.style = v6
	return createElement(PartialModal, v17)
end

return memo(CreateUnfilteredChatPartialModalContainer)
