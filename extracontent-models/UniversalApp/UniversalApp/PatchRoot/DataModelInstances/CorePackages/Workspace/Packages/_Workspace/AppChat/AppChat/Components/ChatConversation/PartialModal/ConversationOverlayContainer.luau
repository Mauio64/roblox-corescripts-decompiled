local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local v3 = require(AppChat.Logger):new(script.Name)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local React = require(AppChatParent.React)
local ConversationOverlay = AppChatNetworking.Constants.ConversationOverlay
local ModalSequence = AppChatNetworking.Constants.ModalSequence
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useShouldShowConversationOverlay = require(AppChat.Hooks.useShouldShowConversationOverlay)
local useRecordModalSeenWithDelay = require(AppChat.Hooks.useRecordModalSeenWithDelay)
local ModalConfiguration = require(AppChat.Models.ModalConfiguration)
local TrustedConnectionsUpsellContainer = require(AppChat.Components.TrustedConnectionsUpsell.TrustedConnectionsUpsellContainer)
local useRecordModalSequenceResponseForConversation = require(AppChat.Hooks.useRecordModalSequenceResponseForConversation)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local DismissedChatModal = require(AppChat.Conversations.Actions.DismissedChatModal)
local SharedFlags = require(AppChatParent.SharedFlags)
local FIntAppChatModalSeenImpressionDelayMs = require(AppChat.Flags.FIntAppChatModalSeenImpressionDelayMs)
local FFlagAppChatEnableDoubleOptIn = SharedFlags.FFlagAppChatEnableDoubleOptIn
local t1 = {
	[ConversationOverlay.TrustedConnectionCreated] = TrustedConnectionsUpsellContainer,
	[ConversationOverlay.AddTrustedConnectionU18] = if not FFlagAppChatEnableDoubleOptIn then nil else TrustedConnectionsUpsellContainer,
	[ConversationOverlay.TrustedConnectionRequestU18] = if not FFlagAppChatEnableDoubleOptIn then nil else TrustedConnectionsUpsellContainer
}

return React.memo(function(t2: {[any]: any}) -- line: 49
	-- upvalues: useSelector (copy), getDeepValue2 (copy), ModalConfiguration (copy), React (copy), t1 (copy), useShouldShowConversationOverlay (copy), useRecordModalSequenceResponseForConversation (copy), useDispatch (copy), useRecordModalSeenWithDelay (copy), ModalSequence (copy), FIntAppChatModalSeenImpressionDelayMs (copy), AppChatNetworking (copy), v3 (copy), DismissedChatModal (copy)
	local u22 = useSelector(function(p1) -- line: 51
		-- upvalues: getDeepValue2 (copy), t2 (copy), ModalConfiguration (copy)
		return getDeepValue2(p1, `ChatAppReducer.Modals.conversationOverlays.{ t2.conversationId }`) or ModalConfiguration.default
	end)

	u22 = React.useMemo(function() -- line: 57
		-- upvalues: u22 (ref)
		return u22
	end, { t2.conversationId })

	local modal_layout = u22.modal_layout
	local v24 = t1[u22.modal_variant]
	local v25 = useShouldShowConversationOverlay(t2.conversationId) and v24 ~= nil
	local v26 = useRecordModalSequenceResponseForConversation(t2.conversationId)
	local v27 = useDispatch()

	useRecordModalSeenWithDelay({
		modalSequence = ModalSequence.ConversationOverlay,
		modalId = modal_layout.id,
		modalVariant = u22.modal_variant,
		actionToRecord = modal_layout.seen_record_action,
		delayMs = FIntAppChatModalSeenImpressionDelayMs,
		canRecordAction = v25,
		conversationId = t2.conversationId
	})
	React.useEffect(function() -- line: 76
		-- upvalues: v25 (copy), t2 (copy)
		if not v25 then
			t2.dismissModal()
		end
	end, { v25 })

	local v28 = React.useCallback(function() -- line: 83
		-- upvalues: v26 (copy), u22 (ref), AppChatNetworking (copy), v3 (copy), t2 (copy), v27 (copy), DismissedChatModal (copy)
		v26(u22.modal_layout.dismissed_record_action, AppChatNetworking.Constants.ModalSequence.ConversationOverlay, u22.modal_layout.id, u22.modal_variant):catch(function(p2) -- line: 89
			-- upvalues: v3 (copy), u22 (ref)
			v3:warning(`Error in ConversationOverlayContainer { u22.modal_layout.id } -> RecordModalSequenceResponse: { tostring(p2) }`)
		end)
		t2.dismissModal()
		v27(DismissedChatModal(AppChatNetworking.Constants.ModalSequence.ConversationOverlay, t2.conversationId))
	end, {
		t2.conversationId,
		u22.modal_layout.dismissed_record_action,
		u22.modal_layout.id,
		u22.modal_variant,
		v26,
		v27,
		t2.dismissModal
	})

	if v25 then
		return React.createElement(v24, {
			conversationId = t2.conversationId,
			modalVariant = u22.modal_variant,
			dismissModal = v28
		})
	end

	return nil
end)
