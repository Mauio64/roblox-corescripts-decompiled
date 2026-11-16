local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
require(AppChat.types)

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local AppChatNetworking = require(parent.AppChatNetworking)
local React = require(parent.React)
local ConversationOverlay = AppChatNetworking.Constants.ConversationOverlay
local ModalSequence = AppChatNetworking.Constants.ModalSequence
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useShouldShowConversationOverlay = require(AppChat.Hooks.useShouldShowConversationOverlay)
local useRecordModalSeenWithDelay = require(AppChat.Hooks.useRecordModalSeenWithDelay)
local ModalConfiguration = require(AppChat.Models.ModalConfiguration)
local TrustedFriendsUpsellContainer = require(AppChat.Components.TrustedFriendsUpsell.TrustedFriendsUpsellContainer)
local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)

local useRecordModalSequenceResponseForConversation = require(AppChat.Hooks.useRecordModalSequenceResponseForConversation)
local RoactUtils2 = require(parent.RoactUtils)
local useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local DismissedChatModal = require(AppChat.Conversations.Actions.DismissedChatModal)

local FIntAppChatModalSeenImpressionDelayMs = require(AppChat.Flags.FIntAppChatModalSeenImpressionDelayMs)

local set = {
	[ConversationOverlay.TrustedConnectionCreated] = true,
	[ConversationOverlay.AddTrustedConnectionU18] = true,
	[ConversationOverlay.TrustedConnectionRequestU18] = true
}

return React.memo(function(p)
	local v2 = useSelector(function(p2)
		return getDeepValue2(p2, `ChatAppReducer.Modals.conversationOverlays.{p.conversationId}`)
			or ModalConfiguration.default
	end)

	v2 = React.useMemo(function()
		return v2
	end, { p.conversationId })
	local modal_layout = v2.modal_layout
	local canRecordAction = useShouldShowConversationOverlay(p.conversationId) and set[v2.modal_variant] == true
	local v3 = useRecordModalSequenceResponseForConversation(p.conversationId)
	local v4 = useDispatch()
	local userId = useGetOneToOneFriendIdFromConversationId(p.conversationId)

	useRecordModalSeenWithDelay({
		modalSequence = ModalSequence.ConversationOverlay,
		modalId = modal_layout.id,
		modalVariant = v2.modal_variant,
		actionToRecord = modal_layout.seen_record_action,
		delayMs = FIntAppChatModalSeenImpressionDelayMs,
		canRecordAction = canRecordAction,
		conversationId = p.conversationId
	})

	React.useEffect(function()
		if not canRecordAction then
			p.dismissModal()
		end
	end, { canRecordAction })

	local dismissModal = React.useCallback(function()
		v3(
			v2.modal_layout.dismissed_record_action,
			AppChatNetworking.Constants.ModalSequence.ConversationOverlay,
			v2.modal_layout.id,
			v2.modal_variant
		):catch(function(p2)
			v:warning(`Error in ConversationOverlayContainer {v2.modal_layout.id} -> RecordModalSequenceResponse: {tostring(p2)}`)
		end)
		p.dismissModal()
		v4(DismissedChatModal(AppChatNetworking.Constants.ModalSequence.ConversationOverlay, p.conversationId))
	end, {
		p.conversationId,
		v2.modal_layout.dismissed_record_action,
		v2.modal_layout.id,
		v2.modal_variant,
		v3,
		v4,
		p.dismissModal
	})

	if canRecordAction and userId then
		return React.createElement(TrustedFriendsUpsellContainer, {
			userId = userId,
			conversationId = p.conversationId,
			analyticsModalVariant = v2.modal_variant,
			dismissModal = dismissModal
		})
	end

	return nil
end)
