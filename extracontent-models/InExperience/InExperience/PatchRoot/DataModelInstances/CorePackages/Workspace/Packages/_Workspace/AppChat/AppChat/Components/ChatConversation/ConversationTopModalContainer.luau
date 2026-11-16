local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local Foundation = require(parent.Foundation)
require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local AppChatNetworking = require(parent.AppChatNetworking)
local ConversationTopModal = AppChatNetworking.Constants.ConversationTopModal
local ModalConfiguration = require(AppChat.Models.ModalConfiguration)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local useRecordModalSeenWithDelay = require(AppChat.Hooks.useRecordModalSeenWithDelay)
local ModalSequence = AppChatNetworking.Constants.ModalSequence

local useRecordModalSequenceResponseForConversation = require(AppChat.Hooks.useRecordModalSequenceResponseForConversation)
local RoactUtils2 = require(parent.RoactUtils)
local useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local DismissedChatModal = require(AppChat.Conversations.Actions.DismissedChatModal)
local useIsGuiInChatVisible = require(AppChat.Hooks.useIsGuiInChatVisible)

local ConversationBannerContainer = require(script.Parent.ConversationBanner.ConversationBannerContainer)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatConversationTrustedFriendUpsellBanner = SharedFlags.FFlagAppChatConversationTrustedFriendUpsellBanner

local SduiConstants = require(AppChat.Sdui.SduiConstants)
local SduiSharedUtilities

if FFlagAppChatConversationTrustedFriendUpsellBanner then
	SduiSharedUtilities = require(parent.SduiSharedUtilities)
end

local sduiFeatureEntryPoint

if FFlagAppChatConversationTrustedFriendUpsellBanner then
	sduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
else
	sduiFeatureEntryPoint = nil
end

local useComponentConfig

if FFlagAppChatConversationTrustedFriendUpsellBanner then
	useComponentConfig = SduiSharedUtilities.useComponentConfig
else
	useComponentConfig = nil
end

local FIntAppChatModalSeenImpressionDelayMs = require(AppChat.Flags.FIntAppChatModalSeenImpressionDelayMs)

local v2 = {
	setModalHeight = function(_) end
}

local ConversationBannerContainers = {
	[ConversationTopModal.AddTrustedConnection] = ConversationBannerContainer,
	[ConversationTopModal.TrustedConnectionRequest] = ConversationBannerContainer
}

local function ConversationTopModalContainer(p)
	local union = Cryo.Dictionary.union(v2, p)
	local v3 = useSelector(function(p2)
		return getDeepValue2(p2, `ChatAppReducer.Modals.conversationTopModals.{union.conversationId}`)
			or ModalConfiguration.default
	end)

	local modal_layout = v3.modal_layout
	local v4 = ConversationBannerContainers[v3.modal_variant]
	local v5 = useDispatch()
	local v6 = useRecordModalSequenceResponseForConversation(union.conversationId)

	local ref = React.useRef(nil)
	local v7 = useIsGuiInChatVisible(ref, { ref.current, v4 })
	local configKey

	if FFlagAppChatConversationTrustedFriendUpsellBanner then
		configKey = SduiConstants.getConversationTopModalConfigKey(union.conversationId)
	end

	local v8

	if FFlagAppChatConversationTrustedFriendUpsellBanner then
		v8 = useComponentConfig(configKey, SduiConstants.ConversationTopModalIdentifier)
	end

	local v9 = FFlagAppChatConversationTrustedFriendUpsellBanner

	if v9 then
		if v4 == nil then
			v9 = v8 ~= nil
		else
			v9 = false
		end
	end

	useRecordModalSeenWithDelay({
		modalSequence = ModalSequence.ConversationTopModal,
		modalVariant = v3.modal_variant,
		actionToRecord = modal_layout.seen_record_action,
		delayMs = FIntAppChatModalSeenImpressionDelayMs,
		canRecordAction = v7 and v4 ~= nil,
		conversationId = union.conversationId
	})

	local onDismissed = React.useCallback(function()
		v6(v3.modal_layout.dismissed_record_action, ModalSequence.ConversationTopModal, nil, v3.modal_variant):catch(function(p2)
			v:warning(`Error in ConversationOverlayContainer {v3.modal_layout.id} -> RecordModalSequenceResponse: {tostring(p2)}`)
		end)
		v5(DismissedChatModal(AppChatNetworking.Constants.ModalSequence.ConversationTopModal, union.conversationId))
	end, { union.conversationId, v3.modal_layout.dismissed_record_action, v3.modal_variant, v6, v5 })

	local onAbsoluteSizeChanged = React.useCallback(function(p2)
		union.setModalHeight(p2.AbsoluteSize.Y)
	end, { union.setModalHeight })

	local conversationTopModal = nil

	if v4 then
		conversationTopModal = React.createElement(v4, {
			conversationId = union.conversationId,
			modalVariant = v3.modal_variant,
			onDismissed = onDismissed,
			bodyText = modal_layout.body and modal_layout.body.text,
			actionText = modal_layout.buttons and modal_layout.buttons[1] and modal_layout.buttons[1].text
		})
	elseif v9 then
		conversationTopModal = React.createElement(sduiFeatureEntryPoint, {
			configKey = configKey,
			identifier = SduiConstants.ConversationTopModalIdentifier,
			appPage = SduiConstants.SurfaceKey,
			shouldDisplayLoading = false,
			shouldDisplayError = false
		})
	elseif v3.modal_variant ~= nil and v3.modal_variant ~= ConversationTopModal.None then
		v:warning(`Unsupported ConversationTopModal variant: {v3.modal_variant}`)
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v10 = {
		LayoutOrder = union.layoutOrder,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		ref = 0,
		tag = "gui-objects-default auto-y size-full-0"
	}

	if v9 then
		ref = nil
	end

	v10.ref = ref
	return createElement(view, v10, { conversationTopModal = conversationTopModal })
end

return React.memo(ConversationTopModalContainer)
