local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local v3 = require(AppChat.Logger):new(script.Name)
local Foundation = require(AppChatParent.Foundation)

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local ConversationTopModal = AppChatNetworking.Constants.ConversationTopModal
local ModalConfiguration = require(AppChat.Models.ModalConfiguration)
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local useRecordModalSeenWithDelay = require(AppChat.Hooks.useRecordModalSeenWithDelay)
local ModalSequence = AppChatNetworking.Constants.ModalSequence
local useRecordModalSequenceResponseForConversation = require(AppChat.Hooks.useRecordModalSequenceResponseForConversation)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local DismissedChatModal = require(AppChat.Conversations.Actions.DismissedChatModal)
local useIsGuiInChatVisible = require(AppChat.Hooks.useIsGuiInChatVisible)
local ConversationBannerContainer = require(script.Parent.ConversationBanner.ConversationBannerContainer)
local FIntAppChatModalSeenImpressionDelayMs = require(AppChat.Flags.FIntAppChatModalSeenImpressionDelayMs)
local t1 = {
	setModalHeight = function(_) -- line: 34
	end
}
local t2 = {
	[ConversationTopModal.AddTrustedConnection] = ConversationBannerContainer,
	[ConversationTopModal.TrustedConnectionRequest] = ConversationBannerContainer
}

local function ConversationTopModalContainer(t3: {[any]: any}) -- line: 43
	-- upvalues: Cryo (copy), t1 (copy), useSelector (copy), getDeepValue2 (copy), ModalConfiguration (copy), t2 (copy), useDispatch (copy), useRecordModalSequenceResponseForConversation (copy), React (copy), useIsGuiInChatVisible (copy), useRecordModalSeenWithDelay (copy), ModalSequence (copy), FIntAppChatModalSeenImpressionDelayMs (copy), v3 (copy), DismissedChatModal (copy), AppChatNetworking (copy), ConversationTopModal (copy), Foundation (copy)
	local v25 = Cryo.Dictionary.union(t1, t3)
	local v26 = useSelector(function(p2) -- line: 46
		-- upvalues: getDeepValue2 (copy), v25 (copy), ModalConfiguration (copy)
		return getDeepValue2(p2, `ChatAppReducer.Modals.conversationTopModals.{ v25.conversationId }`) or ModalConfiguration.default
	end)
	local modal_layout = v26.modal_layout
	local v28 = t2[v26.modal_variant]
	local v29 = useDispatch()
	local v30 = useRecordModalSequenceResponseForConversation(v25.conversationId)
	local v31 = React.useRef(nil)
	local v32 = useIsGuiInChatVisible(v31, {
		v31.current,
		v28
	})

	useRecordModalSeenWithDelay({
		modalSequence = ModalSequence.ConversationTopModal,
		modalVariant = v26.modal_variant,
		actionToRecord = modal_layout.seen_record_action,
		delayMs = FIntAppChatModalSeenImpressionDelayMs,
		canRecordAction = v32 and v28 ~= nil,
		conversationId = v25.conversationId
	})

	local v33 = React.useCallback(function() -- line: 68
		-- upvalues: v30 (copy), v26 (copy), ModalSequence (copy), v3 (copy), v29 (copy), DismissedChatModal (copy), AppChatNetworking (copy), v25 (copy)
		v30(v26.modal_layout.dismissed_record_action, ModalSequence.ConversationTopModal, nil, v26.modal_variant):catch(function(p3) -- line: 74
			-- upvalues: v3 (copy), v26 (copy)
			v3:warning(`Error in ConversationOverlayContainer { v26.modal_layout.id } -> RecordModalSequenceResponse: { tostring(p3) }`)
		end)
		v29(DismissedChatModal(AppChatNetworking.Constants.ModalSequence.ConversationTopModal, v25.conversationId))
	end, {
		v25.conversationId,
		v26.modal_layout.dismissed_record_action,
		v26.modal_variant,
		v30,
		v29
	})
	local v34 = React.useCallback(function(p4) -- line: 94
		-- upvalues: v25 (copy)
		v25.setModalHeight(p4.AbsoluteSize.Y)
	end, { v25.setModalHeight })
	local v35 = nil

	if v28 then
		v35 = React.createElement(v28, {
			conversationId = v25.conversationId,
			modalVariant = v26.modal_variant,
			onDismissed = v33,
			bodyText = modal_layout.body and modal_layout.body.text,
			actionText = modal_layout.buttons and (modal_layout.buttons[1] and modal_layout.buttons[1].text)
		})
	elseif v26.modal_variant ~= nil and v26.modal_variant ~= ConversationTopModal.None then
		v3:warning(`Unsupported ConversationTopModal variant: { v26.modal_variant }`)
	end

	return React.createElement(Foundation.View, {
		tag = "gui-objects-default auto-y size-full-0",
		LayoutOrder = v25.layoutOrder,
		onAbsoluteSizeChanged = v34,
		ref = v31
	}, {
		conversationTopModal = v35
	})
end

return React.memo(ConversationTopModalContainer)
