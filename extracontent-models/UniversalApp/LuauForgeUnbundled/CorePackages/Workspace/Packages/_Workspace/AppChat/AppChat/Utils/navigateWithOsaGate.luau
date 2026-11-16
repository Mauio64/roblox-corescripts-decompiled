local HttpService = game:GetService("HttpService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local GetOverlayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetOverlayStore")
local OverlayTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetOverlayStore/OverlayTypes")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger")
local fetchLatestConversationDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/fetchLatestConversationDetails")
local shouldShowOSAForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/shouldShowOSAForConversation")
local shouldShowU13ChatOptInForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/shouldShowU13ChatOptInForConversation")
local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")
local ReceivedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedConversation")
local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local ConversationRoduxSeed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/ConversationRoduxSeed")
local isFriendsPlaceholderConversation = ConversationRoduxSeed.isFriendsPlaceholderConversation

local fFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry

local function evaluateAndShowGate(data, p2)
	local conversationId = data.conversationId
	local dispatch = data.dispatch
	local onAccepted = data.onAccepted
	local onDeclined = data.onDeclined

	local v5 = nil
	local v6 = shouldShowU13ChatOptInForConversation(p2)

	if v6 and data.requireMultiUserForU13 then
		v6 = p2 and p2.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	end

	if v6 then
		v5 = Constants.OptInVariant.ChatOptInInfoCard
	elseif shouldShowOSAForConversation(p2) then
		v5 = Constants.OptInVariant.OsaContextCard
	end

	if not v5 then
		onAccepted()
		return
	end

	local v7 = GetOverlayStore(false)
	Logger:debug("[OSA Gate] Showing overlay variant={} for conversation {}", v5, conversationId)
	v7.showOverlay(OverlayTypes.GroupOSADialog, {
		conversationId = conversationId,
		impressionId = HttpService:GenerateGUID(false),
		modalVariant = v5,
		onJoin = function()
			v7.dismissOverlay()
			onAccepted()
		end,
		onDecline = function()
			if conversationId and p2 and p2.conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
				dispatch(RemovedConversation(conversationId))
			end

			v7.dismissOverlay()

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

local function getConversationFromStore(callback, p2)
	local conversation = nil
	callback(function(object)
		conversation = object:getState().ChatAppReducer.Conversations[p2]
	end)
	return conversation
end

local function seedConversationFromSignals(callback, p2)
	local conversation = GetConversationStore(false).getConversation(p2, false)

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

	if not fFlagAppChatShowOSAOnPageEntry then
		onAccepted()
		return
	end

	if not conversationId or conversationId == "" then
		onAccepted()
		return
	end

	local v5 = nil
	dispatch(function(object)
		v5 = object:getState().ChatAppReducer.Conversations[conversationId]
	end)
	local v6 = v5

	if v6 == nil then
		local conversation = GetConversationStore(false).getConversation(conversationId, false)

		if conversation == nil then
			v6 = nil
		else
			v6 = ConversationRoduxSeed.normalizeStoreConversationForRodux(conversation)
			dispatch(ReceivedConversation(v6))
		end
	end

	if isFriendsPlaceholderConversation(conversationId, v6) then
		evaluateAndShowGate(data, v6)
	else
		dispatch(fetchLatestConversationDetails(conversationId)):andThen(function()
			local v10 = conversationId
			local v11 = nil
			dispatch(function(object)
				v11 = object:getState().ChatAppReducer.Conversations[v10]
			end)

			evaluateAndShowGate(data, v11)
		end):catch(function(p2)
			Logger:warning(
				"[OSA Gate] Error fetching conversation details for {}: {}",
				conversationId,
				(tostring(p2))
			)

			if data.onError then
				data.onError(p2)
			end
		end)
	end
end
