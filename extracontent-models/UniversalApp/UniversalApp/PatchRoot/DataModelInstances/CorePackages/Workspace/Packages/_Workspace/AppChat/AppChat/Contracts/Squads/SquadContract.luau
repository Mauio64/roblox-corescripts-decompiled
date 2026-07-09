local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local RetrievalStatus = require(AppChatParent.Http).Enum.RetrievalStatus
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local createFriendConversation = require(AppChat.Conversations.Thunks.createFriendConversation)
local ModerationType = require(AppChat.Models.ConversationChannels).ModerationType
local expandToGroupConversation = require(AppChat.Conversations.Thunks.expandToGroupConversation)
local fetchLatestConversationDetails = require(AppChat.Conversations.Thunks.fetchLatestConversationDetails)
local getConversationTitle = require(AppChat.Conversations.getConversationTitle)
local NavigateIntoSquadLobby = require(AppChat.Conversations.Thunks.NavigateIntoSquadLobby)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local useGetConversationHasGroupUpFromId = require(AppChat.Hooks.useGetConversationHasGroupUpFromId)
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local useIsChatUserMessagesEnabled = require(AppChat.Hooks.useIsChatUserMessagesEnabled)
local getDeepValue = require(AppChat.Utils.getDeepValue)
local FFlagReadAppChatFetchingVariable = require(AppChatParent.SharedFlags).FFlagReadAppChatFetchingVariable
local FFlagEnableScheduledSquads = require(AppChatParent.SharedFlags).FFlagEnableScheduledSquads
local FFlagAppChatNavigateBackIfOSAUnacknowledged = require(AppChatParent.SharedFlags).FFlagAppChatNavigateBackIfOSAUnacknowledged
local FFlagEnableSquadRegroupExperimentation = require(AppChatParent.SharedFlags).FFlagEnableSquadRegroupExperimentation
local FFlagEnableDialogAfterSquadJoin = require(AppChatParent.SharedFlags).FFlagEnableDialogAfterSquadJoin
local shouldShowOSAForConversation = require(AppChat.Utils.shouldShowOSAForConversation)
local GetOverlayStore = require(AppChat.Stores.GetOverlayStore)
local OverlayTypes = require(AppChat.Stores.GetOverlayStore.OverlayTypes)
local HttpService = game:GetService("HttpService")
local CreateExperienceInvite = require(AppChatParent.Squads.Thunks).CreateExperienceInvite

return {
	fetchParentChannelDetails = function(p1, p2) -- line: 37
		-- upvalues: fetchLatestConversationDetails (copy)
		return p1(fetchLatestConversationDetails(p2))
	end,
	inviteToParentChannel = function(p3, p4, t1: {[any]: any}) -- line: 41
		-- upvalues: Conversation (copy), AppChatNetworking (copy), expandToGroupConversation (copy)
		if p4.conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
			return p3(AppChatNetworking.rodux.AddUserToConversation.API(p4.id, t1)):andThen(function() -- line: 45
				-- upvalues: p4 (copy)
				return p4.id
			end)
		end

		return p3(expandToGroupConversation(p4.id, t1)):andThen(function(p5) -- line: 51
			return p5.id
		end)
	end,
	navigateIntoSquadLobby = NavigateIntoSquadLobby,
	removeUserFromParentChannel = function(p6, p7, p8) -- line: 57
		-- upvalues: AppChatNetworking (copy)
		return p6(AppChatNetworking.rodux.RemoveUserFromConversation.API(p7, p8))
	end,
	createConversation = createConversation,
	createFriendConversation = createFriendConversation,
	createExperienceInvite = if not FFlagEnableSquadRegroupExperimentation then nil else function(s1: string, p9, s2: string) -- line: 133
		-- upvalues: CreateExperienceInvite (copy)
		return CreateExperienceInvite(s1, p9, s2)
	end,
	useGetConversationFromId = useGetConversationFromId,
	useParentChannelHasGroupUp = function(p10) -- line: 61
		-- upvalues: useGetConversationHasGroupUpFromId (copy)
		return useGetConversationHasGroupUpFromId(p10)
	end,
	useParentChannelHasSquadAccess = function(p11) -- line: 65
		-- upvalues: useGetConversationFromId (copy), ConversationChannels (copy), useIsUserPending (copy)
		assert(p11 ~= nil, "Missing parent channel ID")

		local v41 = useGetConversationFromId(p11) or {}

		if v41.source == "friends" then
			return true
		end

		local v42 = v41.participantPendingStatus == ConversationChannels.UserPendingStatus.Pending

		return not useIsUserPending(v41) and not v42
	end,
	useParentChannelIsPartyVoiceEligible = function(p12) -- line: 83
		-- upvalues: useGetConversationFromId (copy), ModerationType (copy)
		local v44 = useGetConversationFromId(p12)

		if v44 and v44.moderationType ~= nil then
			return v44.moderationType == ModerationType.TrustedComms
		end

		return nil
	end,
	useParentChannelTitleSelector = function(p13) -- line: 91
		-- upvalues: useGetConversationFromId (copy), getConversationTitle (copy)
		local v46 = useGetConversationFromId(p13)

		return getConversationTitle(v46)
	end,
	useIsChatEnabled = useIsChatEnabled,
	useIsLoadingChatSettings = function() -- line: 96
		-- upvalues: useSelector (copy), FFlagReadAppChatFetchingVariable (copy), getDeepValue (copy), RetrievalStatus (copy)
		return useSelector(function(p14) -- line: 97
			-- upvalues: FFlagReadAppChatFetchingVariable (copy), getDeepValue (copy), RetrievalStatus (copy)
			if FFlagReadAppChatFetchingVariable then
				return getDeepValue(p14, "ChatAppReducer.ChatSettings.retrievalStatus") ~= RetrievalStatus.Done
			end

			return nil
		end)
	end,
	useIsChatUserMessagesEnabled = if not FFlagEnableScheduledSquads then nil else useIsChatUserMessagesEnabled,
	shouldShowOSAForConversation = if not FFlagAppChatNavigateBackIfOSAUnacknowledged then nil else shouldShowOSAForConversation,
	showGroupOSADialog = if not FFlagEnableDialogAfterSquadJoin then nil else function(s3: string, p15: ((...any) -> ...any), p16: ((...any) -> ...any)) -- line: 108
		-- upvalues: GetOverlayStore (copy), OverlayTypes (copy), HttpService (copy)
		local v50 = GetOverlayStore(false)

		v50.showOverlay(OverlayTypes.GroupOSADialog, {
			conversationId = s3,
			impressionId = HttpService:GenerateGUID(false),
			onJoin = function() -- line: 113
				-- upvalues: v50 (copy), p15 (copy)
				v50.dismissOverlay()
				p15()
			end,
			onDecline = function() -- line: 117
				-- upvalues: v50 (copy), p16 (copy)
				v50.dismissOverlay()
				p16()
			end
		})
	end
}
