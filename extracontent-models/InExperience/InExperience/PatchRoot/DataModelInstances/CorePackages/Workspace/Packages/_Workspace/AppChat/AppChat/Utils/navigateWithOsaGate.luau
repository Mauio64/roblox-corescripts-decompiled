local HttpService = game:GetService("HttpService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SharedFlags = require(AppChatParent.SharedFlags)
local Constants = require(AppChat.Constants)
local GetOverlayStore = require(AppChat.Stores.GetOverlayStore)
local OverlayTypes = require(AppChat.Stores.GetOverlayStore.OverlayTypes)
local Logger = require(AppChat.Logger)
local fetchLatestConversationDetails = require(AppChat.Conversations.Thunks.fetchLatestConversationDetails)
local shouldShowOSAForConversation = require(AppChat.Utils.shouldShowOSAForConversation)
local shouldShowU13ChatOptInForConversation = require(AppChat.Utils.shouldShowU13ChatOptInForConversation)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local Conversation = require(AppChat.Models.Conversation)
local FFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: FFlagAppChatShowOSAOnPageEntry (copy), fetchLatestConversationDetails (copy), shouldShowU13ChatOptInForConversation (copy), Conversation (copy), Constants (copy), shouldShowOSAForConversation (copy), GetOverlayStore (copy), Logger (copy), OverlayTypes (copy), HttpService (copy), RemovedConversation (copy)
	local conversationId = t1.conversationId
	local dispatch = t1.dispatch
	local onAccepted = t1.onAccepted
	local onDeclined = t1.onDeclined

	if not FFlagAppChatShowOSAOnPageEntry then
		onAccepted()

		return
	end

	if not conversationId or conversationId == "" then
		onAccepted()

		return
	end

	dispatch(fetchLatestConversationDetails(conversationId)):andThen(function() -- line: 46
		-- upvalues: dispatch (copy), conversationId (copy), shouldShowU13ChatOptInForConversation (copy), t1 (copy), Conversation (copy), Constants (copy), shouldShowOSAForConversation (copy), onAccepted (copy), GetOverlayStore (copy), Logger (copy), OverlayTypes (copy), HttpService (copy), RemovedConversation (copy), onDeclined (copy)
		local u20 = nil

		dispatch(function(p1) -- line: 48
			-- upvalues: u20 (ref), conversationId (copy)
			u20 = p1:getState().ChatAppReducer.Conversations[conversationId]
		end)

		local ChatOptInInfoCard = nil

		if shouldShowU13ChatOptInForConversation(u20) and (not t1.requireMultiUserForU13 or u20 and u20.conversationType == Conversation.Type.MULTI_USER_CONVERSATION) then
			ChatOptInInfoCard = Constants.OptInVariant.ChatOptInInfoCard
		elseif shouldShowOSAForConversation(u20) then
			ChatOptInInfoCard = Constants.OptInVariant.OsaContextCard
		end

		if not ChatOptInInfoCard then
			onAccepted()

			return
		end

		local v22 = GetOverlayStore(false)

		Logger:debug("[OSA Gate] Showing overlay variant={} for conversation {}", ChatOptInInfoCard, conversationId)
		v22.showOverlay(OverlayTypes.GroupOSADialog, {
			conversationId = conversationId,
			impressionId = HttpService:GenerateGUID(false),
			modalVariant = ChatOptInInfoCard,
			onJoin = function() -- line: 74
				-- upvalues: v22 (copy), onAccepted (copy)
				v22.dismissOverlay()
				onAccepted()
			end,
			onDecline = function() -- line: 78
				-- upvalues: conversationId (copy), u20 (ref), Conversation (copy), dispatch (copy), RemovedConversation (copy), v22 (copy), onDeclined (copy)
				if conversationId and (u20 and u20.conversationType == Conversation.Type.MULTI_USER_CONVERSATION) then
					dispatch(RemovedConversation(conversationId))
				end

				v22.dismissOverlay()

				if onDeclined then
					onDeclined()
				end
			end,
			onClose = function() -- line: 91
				-- upvalues: onDeclined (copy)
				if onDeclined then
					onDeclined()
				end
			end
		})
	end):catch(function(p2) -- line: 98
		-- upvalues: Logger (copy), conversationId (copy), t1 (copy)
		Logger:warning("[OSA Gate] Error fetching conversation details for {}: {}", conversationId, (tostring(p2)))

		if t1.onError then
			t1.onError(p2)
		end
	end)
end
