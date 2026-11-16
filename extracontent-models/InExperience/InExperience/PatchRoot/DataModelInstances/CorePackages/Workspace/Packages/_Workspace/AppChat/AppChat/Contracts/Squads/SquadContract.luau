local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local createFriendConversation = require(AppChat.Conversations.Thunks.createFriendConversation)
local ConversationChannels2 = require(AppChat.Models.ConversationChannels)
local ModerationType = ConversationChannels2.ModerationType
local expandToGroupConversation = require(AppChat.Conversations.Thunks.expandToGroupConversation)
local fetchLatestConversationDetails = require(AppChat.Conversations.Thunks.fetchLatestConversationDetails)
local getConversationTitle = require(AppChat.Conversations.getConversationTitle)
local NavigateIntoSquadLobby = require(AppChat.Conversations.Thunks.NavigateIntoSquadLobby)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local useGetConversationHasGroupUpFromId = require(AppChat.Hooks.useGetConversationHasGroupUpFromId)
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local useIsChatUserMessagesEnabled = require(AppChat.Hooks.useIsChatUserMessagesEnabled)
local useChatSettingsRetrievalStatus = require(AppChat.Hooks.useChatSettingsRetrievalStatus)
local SharedFlags = require(parent.SharedFlags)
local FFlagReadAppChatFetchingVariable = SharedFlags.FFlagReadAppChatFetchingVariable

local SharedFlags2 = require(parent.SharedFlags)
local FFlagAppChatNavigateBackIfOSAUnacknowledged = SharedFlags2.FFlagAppChatNavigateBackIfOSAUnacknowledged
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableSquadRegroupExperimentation = SharedFlags3.FFlagEnableSquadRegroupExperimentation

local shouldShowOSAForConversation = require(AppChat.Utils.shouldShowOSAForConversation)

local GetOverlayStore = require(AppChat.Stores.GetOverlayStore)
local OverlayTypes = require(AppChat.Stores.GetOverlayStore.OverlayTypes)
local HttpService = game:GetService("HttpService")
local Thunks = require(parent.Squads.Thunks)
local CreateExperienceInvite = Thunks.CreateExperienceInvite

local function fn(conversationId: string, callback, callback2)
	local overlayStore = GetOverlayStore(false)
	overlayStore.showOverlay(OverlayTypes.GroupOSADialog, {
		conversationId = conversationId,
		impressionId = HttpService:GenerateGUID(false),
		onJoin = function()
			overlayStore.dismissOverlay()
			callback()
		end,
		onDecline = function()
			overlayStore.dismissOverlay()
			callback2()
		end
	})
end

local SquadContract = {
	fetchParentChannelDetails = function(callback, p)
		return callback(fetchLatestConversationDetails(p))
	end,
	inviteToParentChannel = function(callback, p, p2)
		if p.conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
			return callback(AppChatNetworking.rodux.AddUserToConversation.API(p.id, p2)):andThen(function()
				return p.id
			end)
		end

		return callback(expandToGroupConversation(p.id, p2)):andThen(function(p3)
			return p3.id
		end)
	end,
	navigateIntoSquadLobby = NavigateIntoSquadLobby,
	removeUserFromParentChannel = function(callback, p, p2)
		return callback(AppChatNetworking.rodux.RemoveUserFromConversation.API(p, p2))
	end,
	createConversation = createConversation,
	createFriendConversation = createFriendConversation,
	createExperienceInvite = FFlagEnableSquadRegroupExperimentation and function(p: string, p2, p3: string)
		return CreateExperienceInvite(p, p2, p3)
	end or nil,
	useGetConversationFromId = useGetConversationFromId,
	useParentChannelHasGroupUp = function(p)
		return useGetConversationHasGroupUpFromId(p)
	end,
	useParentChannelHasSquadAccess = function(p): boolean
		assert(p ~= nil, "Missing parent channel ID")
		local v = useGetConversationFromId(p) or {}

		if v.source == "friends" then
			return true
		end

		local v2 = v.participantPendingStatus == ConversationChannels.UserPendingStatus.Pending

		return not (useIsUserPending(v) or v2)
	end,
	useParentChannelIsPartyVoiceEligible = function(p): nil | boolean
		local v = useGetConversationFromId(p)

		if v and v.moderationType ~= nil then
			return v.moderationType == ModerationType.TrustedComms
		end

		return nil
	end,
	useParentChannelTitleSelector = function(p)
		return getConversationTitle((useGetConversationFromId(p)))
	end,
	useIsChatEnabled = useIsChatEnabled,
	useIsLoadingChatSettings = function(): nil | boolean
		local v = useChatSettingsRetrievalStatus()

		if FFlagReadAppChatFetchingVariable then
			return v ~= RetrievalStatus.Done
		end

		return nil
	end,
	useIsChatUserMessagesEnabled = useIsChatUserMessagesEnabled,
	shouldShowOSAForConversation = 0,
	showGroupOSADialog = 0
}

if not FFlagAppChatNavigateBackIfOSAUnacknowledged then
	shouldShowOSAForConversation = nil
end

SquadContract.shouldShowOSAForConversation = shouldShowOSAForConversation

SquadContract.showGroupOSADialog = fn
return SquadContract
