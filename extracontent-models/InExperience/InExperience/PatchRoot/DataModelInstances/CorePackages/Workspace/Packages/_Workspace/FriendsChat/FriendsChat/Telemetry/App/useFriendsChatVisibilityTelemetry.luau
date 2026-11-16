local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local React = require(parent.React)

local AppTelemetryLayer = require(parent.AppChat.AppTelemetryLayer)
local GetConversationListStore = require(parent.AppChat.GetConversationListStore)
local GetFriendsChatSettingsStore = require(parent.AppChat.GetFriendsChatSettingsStore)
local useTelemetry = require(parent.AppChat.useTelemetry)

local FFlagAppChatVisibleIsInConversation = require(parent.AppChat.FFlagAppChatVisibleIsInConversation)
local FFlagFriendsChatLandingTelemetryFields = require(FriendsChat.Flags.FFlagFriendsChatLandingTelemetryFields)
local GetFriendsChatNavigationStore = require(FriendsChat.Stores.GetFriendsChatNavigationStore)
local isInboxInitialLoading = require(FriendsChat.ConversationList.isInboxInitialLoading)

local AppLevelTelemetryEvents = require(script.Parent.AppLevelTelemetryEvents)

local function getIsChatEnabled() -- 1 equivalent call inferred from this helper
	return GetFriendsChatSettingsStore(false).getChatEnabled(false)
end

local function getEmittedInfo()
	local emittedInfo = { isChatEnabled = getIsChatEnabled() } -- inferred equivalent call

	if FFlagFriendsChatLandingTelemetryFields then
		local v = GetFriendsChatNavigationStore(false).getEffectiveConversationId(false) == nil
		local conversationListStore = GetConversationListStore(false)
		local listStatus = conversationListStore.getListStatus(false)
		local v2 = #conversationListStore.getConversations(false)
		emittedInfo.isChatLoading = v and isInboxInitialLoading(listStatus.isFetchingConversations == true, v2)
	end

	if FFlagAppChatVisibleIsInConversation then
		emittedInfo.isInConversation = GetFriendsChatNavigationStore(false).getEffectiveConversationId(false) ~= nil
	end

	return emittedInfo
end

local function useFriendsChatVisibilityTelemetry()
	local emit = useTelemetry(AppTelemetryLayer.Context).emit

	React.useEffect(function()
		emit(AppLevelTelemetryEvents.AppChatVisible, getEmittedInfo())
		return function()
			emit(AppLevelTelemetryEvents.AppChatClosed, getEmittedInfo())
		end
	end, {})
end

return useFriendsChatVisibilityTelemetry
