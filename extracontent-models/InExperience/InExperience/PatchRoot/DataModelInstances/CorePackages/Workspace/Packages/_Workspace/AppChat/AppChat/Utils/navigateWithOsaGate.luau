local HttpService = game:GetService("HttpService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SharedFlags = require(parent.SharedFlags)
local Constants = require(AppChat.Constants)
local GetOverlayStore = require(AppChat.Stores.GetOverlayStore)
local OverlayTypes = require(AppChat.Stores.GetOverlayStore.OverlayTypes)
local Logger = require(AppChat.Logger)
local fetchLatestConversationDetails = require(AppChat.Conversations.Thunks.fetchLatestConversationDetails)
local shouldShowOSAForConversation = require(AppChat.Utils.shouldShowOSAForConversation)
local shouldShowU13ChatOptInForConversation = require(AppChat.Utils.shouldShowU13ChatOptInForConversation)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local ReceivedConversation = require(AppChat.Conversations.Actions.ReceivedConversation)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local Conversation = require(AppChat.Models.Conversation)
local ConversationRoduxSeed = require(AppChat.Utils.ConversationRoduxSeed)
local isFriendsPlaceholderConversation = ConversationRoduxSeed.isFriendsPlaceholderConversation

local FFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry

local function evaluateAndShowGate(data, p)
	local conversationId = data.conversationId
	local dispatch = data.dispatch
	local onAccepted = data.onAccepted
	local onDeclined = data.onDeclined

	local modalVariant = nil
	local v = shouldShowU13ChatOptInForConversation(p)

	if v and data.requireMultiUserForU13 then
		v = p and p.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	end

	if v then
		modalVariant = Constants.OptInVariant.ChatOptInInfoCard
	elseif shouldShowOSAForConversation(p) then
		modalVariant = Constants.OptInVariant.OsaContextCard
	end

	if not modalVariant then
		onAccepted()
		return
	end

	local overlayStore = GetOverlayStore(false)
	Logger:debug("[OSA Gate] Showing overlay variant={} for conversation {}", modalVariant, conversationId)
	overlayStore.showOverlay(OverlayTypes.GroupOSADialog, {
		conversationId = conversationId,
		impressionId = HttpService:GenerateGUID(false),
		modalVariant = modalVariant,
		onJoin = function()
			overlayStore.dismissOverlay()
			onAccepted()
		end,
		onDecline = function()
			if conversationId and p and p.conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
				dispatch(RemovedConversation(conversationId))
			end

			overlayStore.dismissOverlay()

			if onDeclined then
				onDeclined()
			end
		end,
		onClose = function()
			if onDeclined then
				onDeclined()
			end
		end
	})
end

local function getConversationFromStore(dispatch, conversationId: string) -- 2 equivalent calls inferred from this helper
	local conversation = nil
	dispatch(function(object)
		conversation = object:getState().ChatAppReducer.Conversations[conversationId]
	end)
	return conversation
end

local function seedConversationFromSignals(callback, p: string)
	local conversation = GetConversationStore(false).getConversation(p, false)

	if conversation == nil then
		return nil
	end

	local storeConversationForRodux = ConversationRoduxSeed.normalizeStoreConversationForRodux(conversation)
	callback(ReceivedConversation(storeConversationForRodux))
	return storeConversationForRodux
end

return function(data)
	local conversationId = data.conversationId
	local dispatch = data.dispatch
	local onAccepted = data.onAccepted

	if not FFlagAppChatShowOSAOnPageEntry then
		onAccepted()
		return
	end

	if not conversationId or conversationId == "" then
		onAccepted()
		return
	end

	local conversation2 = getConversationFromStore(dispatch, conversationId) -- inferred equivalent call

	if conversation2 == nil then
		local conversation = GetConversationStore(false).getConversation(conversationId, false)

		if conversation == nil then
			conversation2 = nil
		else
			conversation2 = ConversationRoduxSeed.normalizeStoreConversationForRodux(conversation)
			dispatch(ReceivedConversation(conversation2))
		end
	end

	if isFriendsPlaceholderConversation(conversationId, conversation2) then
		evaluateAndShowGate(data, conversation2)
	else
		dispatch(fetchLatestConversationDetails(conversationId)):andThen(function()
			evaluateAndShowGate(data, getConversationFromStore(dispatch, conversationId)) -- inferred equivalent call
		end):catch(function(p)
			Logger:warning("[OSA Gate] Error fetching conversation details for {}: {}", conversationId, (tostring(p)))

			if data.onError then
				data.onError(p)
			end
		end)
	end
end
