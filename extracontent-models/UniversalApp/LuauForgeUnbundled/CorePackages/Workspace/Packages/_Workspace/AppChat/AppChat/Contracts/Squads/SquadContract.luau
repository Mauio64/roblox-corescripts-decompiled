local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http").Enum.RetrievalStatus
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/createConversation")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/createFriendConversation")
local moderationType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels").ModerationType
local expandToGroupConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/expandToGroupConversation")
local fetchLatestConversationDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/fetchLatestConversationDetails")
local getConversationTitle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getConversationTitle")
local NavigateIntoSquadLobby = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/NavigateIntoSquadLobby")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")
local useGetConversationHasGroupUpFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationHasGroupUpFromId")
local useIsUserPending = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsUserPending")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatEnabled")
local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatUserMessagesEnabled")
local useChatSettingsRetrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatSettingsRetrievalStatus")
local fFlagReadAppChatFetchingVariable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagReadAppChatFetchingVariable

local fFlagAppChatNavigateBackIfOSAUnacknowledged = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatNavigateBackIfOSAUnacknowledged
local fFlagEnableSquadRegroupExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableSquadRegroupExperimentation

local module16 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/shouldShowOSAForConversation")

local GetOverlayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetOverlayStore")
local OverlayTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetOverlayStore/OverlayTypes")
local HttpService = game:GetService("HttpService")
local createExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/Thunks").CreateExperienceInvite

local function fn(p2, callback, callback2)
	local v5 = GetOverlayStore(false)
	v5.showOverlay(OverlayTypes.GroupOSADialog, {
		conversationId = p2,
		impressionId = HttpService:GenerateGUID(false),
		onJoin = function()
			v5.dismissOverlay()
			callback()
		end,
		onDecline = function()
			v5.dismissOverlay()
			callback2()
		end
	})
end

local v5 = {
	fetchParentChannelDetails = function(callback, p2)
		return callback(fetchLatestConversationDetails(p2))
	end,
	inviteToParentChannel = function(callback, p2, p3)
		if p2.conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
			return callback(AppChatNetworking.rodux.AddUserToConversation.API(p2.id, p3)):andThen(function()
				return p2.id
			end)
		end

		return callback(expandToGroupConversation(p2.id, p3)):andThen(function(p4)
			return p4.id
		end)
	end,
	navigateIntoSquadLobby = NavigateIntoSquadLobby,
	removeUserFromParentChannel = function(callback, p2, p3)
		return callback(AppChatNetworking.rodux.RemoveUserFromConversation.API(p2, p3))
	end,
	createConversation = module4,
	createFriendConversation = module5,
	createExperienceInvite = fFlagEnableSquadRegroupExperimentation and function(p2, p3, p4)
		return createExperienceInvite(p2, p3, p4)
	end or nil,
	useGetConversationFromId = module10,
	useParentChannelHasGroupUp = function(p2)
		return useGetConversationHasGroupUpFromId(p2)
	end,
	useParentChannelHasSquadAccess = function(p2): boolean
		assert(p2 ~= nil, "Missing parent channel ID")
		local v6 = module10(p2) or {}

		if v6.source == "friends" then
			return true
		end

		local v7 = v6.participantPendingStatus == ConversationChannels.UserPendingStatus.Pending

		return not (useIsUserPending(v6) or v7)
	end,
	useParentChannelIsPartyVoiceEligible = function(p2): nil | boolean
		local v6 = module10(p2)

		if v6 and v6.moderationType ~= nil then
			return v6.moderationType == moderationType.TrustedComms
		end

		return nil
	end,
	useParentChannelTitleSelector = function(p2)
		return getConversationTitle((module10(p2)))
	end,
	useIsChatEnabled = module13,
	useIsLoadingChatSettings = function(): nil | boolean
		local v6 = useChatSettingsRetrievalStatus()

		if fFlagReadAppChatFetchingVariable then
			return v6 ~= retrievalStatus.Done
		end

		return nil
	end,
	useIsChatUserMessagesEnabled = module14,
	shouldShowOSAForConversation = 0,
	showGroupOSADialog = 0
}

if not fFlagAppChatNavigateBackIfOSAUnacknowledged then
	module16 = nil
end

v5.shouldShowOSAForConversation = module16

v5.showGroupOSADialog = fn
return v5
