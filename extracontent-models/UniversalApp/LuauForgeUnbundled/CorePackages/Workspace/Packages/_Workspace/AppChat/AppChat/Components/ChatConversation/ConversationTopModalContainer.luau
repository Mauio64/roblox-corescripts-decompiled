local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("ConversationTopModalContainer")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local conversationTopModal = AppChatNetworking.Constants.ConversationTopModal
local ModalConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ModalConfiguration")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
local useRecordModalSeenWithDelay = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useRecordModalSeenWithDelay")
local modalSequence = AppChatNetworking.Constants.ModalSequence

local useRecordModalSequenceResponseForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useRecordModalSequenceResponseForConversation")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local DismissedChatModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/DismissedChatModal")
local useIsGuiInChatVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsGuiInChatVisible")

local ConversationBannerContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ConversationBanner/ConversationBannerContainer")

local fFlagAppChatConversationTrustedFriendUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatConversationTrustedFriendUpsellBanner

local SduiConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Sdui/SduiConstants")
local v6

if fFlagAppChatConversationTrustedFriendUpsellBanner then
	v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SduiSharedUtilities")
end

local sduiFeatureEntryPoint

if fFlagAppChatConversationTrustedFriendUpsellBanner then
	sduiFeatureEntryPoint = v6.SduiFeatureEntryPoint
else
	sduiFeatureEntryPoint = nil
end

local useComponentConfig = if fFlagAppChatConversationTrustedFriendUpsellBanner then v6.useComponentConfig else nil

local FIntAppChatModalSeenImpressionDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatModalSeenImpressionDelayMs")

local v7 = {
	setModalHeight = function(p2) end
}

local modules = {
	[conversationTopModal.AddTrustedConnection] = ConversationBannerContainer,
	[conversationTopModal.TrustedConnectionRequest] = ConversationBannerContainer
}

local function ConversationTopModalContainer(p2)
	local union = Cryo.Dictionary.union(v7, p2)
	local v8 = useSelector(function(p3)
		return getDeepValue2(p3, `ChatAppReducer.Modals.conversationTopModals.{union.conversationId}`)
			or ModalConfiguration.default
	end)

	local modal_layout = v8.modal_layout
	local v9 = modules[v8.modal_variant]
	local v10 = useDispatch()
	local v11 = useRecordModalSequenceResponseForConversation(union.conversationId)

	local ref = React.useRef(nil)
	local v12 = useIsGuiInChatVisible(ref, { ref.current, v9 })
	local v13

	if fFlagAppChatConversationTrustedFriendUpsellBanner then
		v13 = SduiConstants.getConversationTopModalConfigKey(union.conversationId)
	end

	local v14

	if fFlagAppChatConversationTrustedFriendUpsellBanner then
		v14 = useComponentConfig(v13, SduiConstants.ConversationTopModalIdentifier)
	end

	local v15 = fFlagAppChatConversationTrustedFriendUpsellBanner

	if v15 then
		v15 = v9 == nil and v14 ~= nil
	end

	useRecordModalSeenWithDelay({
		modalSequence = modalSequence.ConversationTopModal,
		modalVariant = v8.modal_variant,
		actionToRecord = modal_layout.seen_record_action,
		delayMs = FIntAppChatModalSeenImpressionDelayMs,
		canRecordAction = v12 and v9 ~= nil,
		conversationId = union.conversationId
	})

	local v16 = React.useCallback(function()
		v11(
			v8.modal_layout.dismissed_record_action,
			modalSequence.ConversationTopModal,
			nil,
			v8.modal_variant
		):catch(function(p3)
			v5:warning(`Error in ConversationOverlayContainer {v8.modal_layout.id} -> RecordModalSequenceResponse: {tostring(p3)}`)
		end)
		v10(DismissedChatModal(AppChatNetworking.Constants.ModalSequence.ConversationTopModal, union.conversationId))
	end, {
		union.conversationId,
		v8.modal_layout.dismissed_record_action,
		v8.modal_variant,
		v11,
		v10
	})

	local v17 = React.useCallback(function(p3)
		union.setModalHeight(p3.AbsoluteSize.Y)
	end, { union.setModalHeight })

	local v18 = nil

	if v9 then
		v18 = React.createElement(v9, {
			conversationId = union.conversationId,
			modalVariant = v8.modal_variant,
			onDismissed = v16,
			bodyText = modal_layout.body and modal_layout.body.text,
			actionText = modal_layout.buttons and modal_layout.buttons[1] and modal_layout.buttons[1].text
		})
	elseif v15 then
		v18 = React.createElement(sduiFeatureEntryPoint, {
			configKey = v13,
			identifier = SduiConstants.ConversationTopModalIdentifier,
			appPage = SduiConstants.SurfaceKey,
			shouldDisplayLoading = false,
			shouldDisplayError = false
		})
	elseif v8.modal_variant ~= nil and v8.modal_variant ~= conversationTopModal.None then
		v5:warning(`Unsupported ConversationTopModal variant: {v8.modal_variant}`)
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v19 = {
		LayoutOrder = union.layoutOrder,
		onAbsoluteSizeChanged = v17,
		ref = 0,
		tag = "gui-objects-default auto-y size-full-0"
	}

	if v15 then
		ref = nil
	end

	v19.ref = ref
	return createElement(view, v19, { conversationTopModal = v18 })
end

return React.memo(ConversationTopModalContainer)
