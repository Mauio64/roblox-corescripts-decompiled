require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("ConversationOverlayContainer")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local conversationOverlay = AppChatNetworking.Constants.ConversationOverlay
local modalSequence = AppChatNetworking.Constants.ModalSequence
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useShouldShowConversationOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useShouldShowConversationOverlay")
local useRecordModalSeenWithDelay = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useRecordModalSeenWithDelay")
local ModalConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ModalConfiguration")
local TrustedFriendsUpsellContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TrustedFriendsUpsell/TrustedFriendsUpsellContainer")
local useGetOneToOneFriendIdFromConversationId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetOneToOneFriendIdFromConversationId")

local useRecordModalSequenceResponseForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useRecordModalSequenceResponseForConversation")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local DismissedChatModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/DismissedChatModal")

local FIntAppChatModalSeenImpressionDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatModalSeenImpressionDelayMs")

local set = {
	[conversationOverlay.TrustedConnectionCreated] = true,
	[conversationOverlay.AddTrustedConnectionU18] = true,
	[conversationOverlay.TrustedConnectionRequestU18] = true
}

return React.memo(function(p2)
	local v6 = useSelector(function(p3)
		return getDeepValue2(p3, `ChatAppReducer.Modals.conversationOverlays.{p2.conversationId}`)
			or ModalConfiguration.default
	end)

	v6 = React.useMemo(function()
		return v6
	end, { p2.conversationId })
	local modal_layout = v6.modal_layout
	local v7 = useShouldShowConversationOverlay(p2.conversationId) and set[v6.modal_variant] == true
	local v8 = useRecordModalSequenceResponseForConversation(p2.conversationId)
	local v9 = useDispatch()
	local v10 = useGetOneToOneFriendIdFromConversationId(p2.conversationId)

	useRecordModalSeenWithDelay({
		modalSequence = modalSequence.ConversationOverlay,
		modalId = modal_layout.id,
		modalVariant = v6.modal_variant,
		actionToRecord = modal_layout.seen_record_action,
		delayMs = FIntAppChatModalSeenImpressionDelayMs,
		canRecordAction = v7,
		conversationId = p2.conversationId
	})

	React.useEffect(function()
		if not v7 then
			p2.dismissModal()
		end
	end, { v7 })

	local v11 = React.useCallback(function()
		v8(
			v6.modal_layout.dismissed_record_action,
			AppChatNetworking.Constants.ModalSequence.ConversationOverlay,
			v6.modal_layout.id,
			v6.modal_variant
		):catch(function(p3)
			v5:warning(`Error in ConversationOverlayContainer {v6.modal_layout.id} -> RecordModalSequenceResponse: {tostring(p3)}`)
		end)
		p2.dismissModal()
		v9(DismissedChatModal(AppChatNetworking.Constants.ModalSequence.ConversationOverlay, p2.conversationId))
	end, {
		p2.conversationId,
		v6.modal_layout.dismissed_record_action,
		v6.modal_layout.id,
		v6.modal_variant,
		v8,
		v9,
		p2.dismissModal
	})

	if v7 and v10 then
		return React.createElement(TrustedFriendsUpsellContainer, {
			userId = v10,
			conversationId = p2.conversationId,
			analyticsModalVariant = v6.modal_variant,
			dismissModal = v11
		})
	end

	return nil
end)
