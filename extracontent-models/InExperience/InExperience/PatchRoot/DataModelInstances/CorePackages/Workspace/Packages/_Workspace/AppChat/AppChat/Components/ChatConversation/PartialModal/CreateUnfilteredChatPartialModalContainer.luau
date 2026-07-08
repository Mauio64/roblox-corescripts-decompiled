local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useCallback = React.useCallback
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffectOnMount = require(AppChatParent.RoactUtils).Hooks.useEffectOnMount
local useIsLocalPlayerPartyVoiceEligible = require(AppChatParent.SquadsCore.Hooks).useIsLocalPlayerPartyVoiceEligible
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useScreenSize = require(AppChatParent.RobloxAppHooks).useScreenSize
local useState = React.useState
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local EventNames = require(AppChat.Analytics.EventNames)
local UIBlox = require(AppChatParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local PartialModal = require(script.Parent.PartialModal)
local t1 = {
	conversationId = "",
	titleKey = "Feature.Chat.Heading.CreateUnfilteredChatDialog",
	bodyKey = "Feature.Chat.Description.CreateUnfilteredChatDialog",
	bodyKeyWithVoice = "Feature.Chat.Description.CreateUnfilteredChatWithVoice",
	networkErrorTextKey = "Feature.Toast.NetworkingError.SomethingIsWrong",
	actionKey = "Feature.Chat.Action.Create",
	cancelAlertKey = "Feature.Chat.Action.Cancel",
	onDismissed = function() -- line: 41
	end,
	navigateToConversation = function(_) -- line: 42
	end,
	navigateToToast = function(_) -- line: 43
	end
}

local function CreateUnfilteredChatPartialModalContainer(t2: {[any]: any}) -- line: 53
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useScreenSize (copy), useLayerCollector (copy), useState (copy), useDispatch (copy), useAnalytics (copy), useIsLocalPlayerPartyVoiceEligible (copy), useEffectOnMount (copy), EventNames (copy), useLocalization (copy), useCallback (copy), AppChatNetworking (copy), React (copy), PartialModal (copy)
	local v25 = Cryo.Dictionary.union(t1, t2)
	local v26 = useStyle()
	local v27 = useScreenSize()
	local v28 = useLayerCollector()

	if v28 and v28.absoluteSize then
		v27 = v28.absoluteSize
	end

	local v29, v30 = useState(false)
	local v31 = useDispatch()
	local v32 = useAnalytics()
	local v33 = useIsLocalPlayerPartyVoiceEligible()

	useEffectOnMount(function() -- line: 66
		-- upvalues: v32 (copy), EventNames (copy), v25 (copy)
		if v32 then
			v32.fireAnalyticsEvent(EventNames.ConversationUpgradeDialogRendered, {
				conversationId = v25.conversationId
			})
		end
	end)

	local v34 = useLocalization({
		networkErrorText = v25.networkErrorTextKey,
		titleText = v25.titleKey,
		bodyText = v25.bodyKey,
		bodyTextWithVoice = v25.bodyKeyWithVoice,
		actionText = v25.actionKey,
		cancelAlertText = v25.cancelAlertKey
	})
	local v35 = useCallback(function() -- line: 83
		-- upvalues: v25 (copy), v34 (copy)
		v25.navigateToToast(v34.networkErrorText)
	end, {
		v25.navigateToToast,
		v34.networkErrorText
	})
	local v36 = useCallback(function() -- line: 88
		-- upvalues: v32 (copy), EventNames (copy), v25 (copy), v30 (copy), v31 (copy), AppChatNetworking (copy), v35 (copy)
		if v32 then
			v32.fireAnalyticsEvent(EventNames.ConversationUpgradeDialogActionClicked, {
				conversationId = v25.conversationId
			})
		end

		v30(true)
		v31(AppChatNetworking.rodux.DuplicateConversation.API(v25.conversationId, "trusted_comms")):andThen(function(p3) -- line: 96
			-- upvalues: v25 (copy), v35 (copy)
			local responseBody = p3.responseBody
			local v40 = responseBody and (responseBody.conversations and (responseBody.conversations[1] and responseBody.conversations[1].id))

			if v40 then
				v25.navigateToConversation(v40)

				return
			end

			v35()
		end):catch(function() -- line: 108
			-- upvalues: v35 (copy)
			v35()
		end):finally(function() -- line: 111
			-- upvalues: v30 (copy)
			v30(false)
		end)
	end, {
		v31,
		v30,
		v35,
		v25.navigateToConversation,
		v25.conversationId,
		v32
	})
	local v37 = useCallback(function() -- line: 117
		-- upvalues: v32 (copy), EventNames (copy), v25 (copy)
		if v32 then
			v32.fireAnalyticsEvent(EventNames.ConversationUpgradeDialogDismissed, {
				conversationId = v25.conversationId
			})
		end

		v25.onDismissed()
	end, {
		v25.onDismissed,
		v32,
		v25.conversationId
	})

	return React.createElement(PartialModal, {
		titleText = v34.titleText,
		bodyText = if not v33 then v34.bodyText else v34.bodyTextWithVoice,
		actionText = v34.actionText,
		cancelAlertText = v34.cancelAlertText,
		isButtonDisabled = v29,
		screenSize = v27,
		onActivated = v36,
		onDismissed = v37,
		style = v26
	})
end

return memo(CreateUnfilteredChatPartialModalContainer)
