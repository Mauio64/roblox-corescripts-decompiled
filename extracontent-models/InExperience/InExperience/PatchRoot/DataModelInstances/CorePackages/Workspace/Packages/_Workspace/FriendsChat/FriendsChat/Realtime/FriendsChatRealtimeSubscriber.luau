local parent = script:FindFirstAncestor("FriendsChat").Parent
local Players = game:GetService("Players")

local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local ExpChatShared = require(parent.ExpChatShared)

local ConversationChannels = require(parent.AppChat.ConversationChannels)
local fetchNewerMessages = require(parent.AppChat.fetchNewerMessages)
local GetConversationMessageListStore = require(parent.AppChat.GetConversationMessageListStore)

local classifyCommunicationChannelsEvent = require(script.Parent.classifyCommunicationChannelsEvent)
local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local GetFriendsChatNavigationStore = require(script.Parent.Parent.Stores.GetFriendsChatNavigationStore)
local GetFriendsChatRealtimeStore = require(script.Parent.Parent.Stores.GetFriendsChatRealtimeStore)
local FStringDebugFriendsChatConversationId = require(script.Parent.Parent.Flags.FStringDebugFriendsChatConversationId)

local v = ExpChatShared.Logger:new(script.Name)

local FriendshipNotifications = require(script.Parent.FriendshipNotifications)

local function fetchNewerMessagesSafe(p: string, onActiveConversationMessageReceived)
	local conversation = ExpChatConversationListAdapter.getConversationStore().getConversation(p, false)
	local lastUpdated = conversation and conversation.lastUpdated

	local set = {}

	for _, v2 in GetConversationMessageListStore(false).getOrderedIds(p, false) do
		set[v2] = true
	end

	fetchNewerMessages(p):andThen(function(p2)
		local response = p2 and p2.response
		local responseBody = response and response.responseBody
		local messages = responseBody and responseBody.messages or {}
		local ingestedIds = p2 and p2.ingestedIds
		local friendsChatRealtimeStore = GetFriendsChatRealtimeStore(false)
		local activeConversationId = friendsChatRealtimeStore.getActiveConversationId(false)
		local localPlayer = Players.LocalPlayer
		local hasUnreadMessages = activeConversationId ~= p
		local _, v2 = ExpChatConversationListAdapter.updateConversationPreviewFromMessages(p, messages, {
			hasUnreadMessages = hasUnreadMessages,
			localUserId = not localPlayer and 0 or localPlayer.UserId,
			refreshListOnMissingConversation = true,
			unreadFreshnessLastUpdated = lastUpdated
		})

		if v2 then
			friendsChatRealtimeStore.addLocalUnread(p)
		end

		if activeConversationId == p then
			ExpChatConversationListAdapter.markConversationRead(p, true)

			if onActiveConversationMessageReceived ~= nil then
				local flag = false

				if ingestedIds ~= nil then
					for _, ingestedId in ingestedIds do
						if not set[ingestedId] then
							flag = true
							break
						end
					end
				end

				if flag then
					onActiveConversationMessageReceived()
				end
			end
		end
	end):catch(function(p2)
		v:warning(`Failed to fetch newer messages for {p}: {tostring(p2)}`)
	end)
end

local function getFirstConversationResponse(p) -- 2 equivalent calls inferred from this helper
	local responseBody

	if p ~= nil then
		responseBody = p.responseBody or p
	end

	local conversations = responseBody and responseBody.conversations
	return if conversations ~= nil then conversations[1] else nil
end

local function updateSelectedFriendPlaceholder(p: string, p2)
	local firstConversationResponse = getFirstConversationResponse(p2) -- inferred equivalent call

	if
		firstConversationResponse == nil
		or firstConversationResponse.source ~= ConversationChannels.Source.Channels
		or firstConversationResponse.type ~= ConversationChannels.Type.OneToOne
		or firstConversationResponse.participant_user_ids == nil
	then
		return
	end

	local friendConversationId = ConversationChannels.getFriendConversationId(firstConversationResponse.participant_user_ids)
	local friendsChatNavigationStore = GetFriendsChatNavigationStore(false)

	if friendsChatNavigationStore.getSelectedConversationId(false) == friendConversationId then
		friendsChatNavigationStore.setSelectedConversationId(firstConversationResponse.id or p)
	end
end

local function fetchConversationDetailsSafe(channelId: string, flag: boolean, requestConversationListRefresh)
	ExpChatConversationListAdapter.fetchConversationDetailsToSignals(channelId):andThen(function(p)
		if flag and getFirstConversationResponse(p) == nil then -- inferred equivalent call
			requestConversationListRefresh(`new conversation {channelId}`)
			return
		end

		updateSelectedFriendPlaceholder(channelId, p)
	end):catch(function(p)
		v:warning(`Failed to fetch conversation details for {channelId}: {tostring(p)}`)
	end)
end

local function handleRemove(channelId: string) -- 1 equivalent call inferred from this helper
	ExpChatConversationListAdapter.removeConversation(channelId)
	local friendsChatNavigationStore = GetFriendsChatNavigationStore(false)

	if friendsChatNavigationStore.getSelectedConversationId(false) == channelId then
		friendsChatNavigationStore.setSelectedConversationId(nil)
	end
end

local function FriendsChatRealtimeSubscriber(p): nil
	local onActiveConversationMessageReceived = p.onActiveConversationMessageReceived

	local ref = React.useRef(false)
	local ref2 = React.useRef(0)

	local function requestConversationListRefresh(p2: string)
		ref.current = true
		ref2.current += 1
		local current = ref2.current
		local function attempt(p3: number)
			if ref2.current ~= current then
				return
			end

			if ExpChatConversationListAdapter.getConversationStore().getListStatus(false).isFetchingConversations == true then
				if p3 <= 0 then
					ref.current = false
					v:warning(`Gave up refreshing conversation list after {p2}: fetch still in flight`)
				else
					task.delay(1, function()
						attempt(p3 - 1)
					end)
				end
			else
				if not ref.current then
					return
				end

				ref.current = false

				ExpChatConversationListAdapter.fetchConversationListPageToSignals():catch(function(p4)
					v:warning(`Failed to refresh conversation list after {p2}: {tostring(p4)}`)
				end)
			end
		end

		attempt(3)
	end

	RealtimeDelivery.useRealtimeNamespace("CommunicationChannels", function(p2)
		local v2 = classifyCommunicationChannelsEvent(p2)
		local channelId = v2.channelId

		if channelId == nil then
			return
		end

		if v2.kind == "fetchMessage" then
			fetchNewerMessagesSafe(channelId, onActiveConversationMessageReceived)
		elseif v2.kind == "removeConversation" then
			handleRemove(channelId) -- inferred equivalent call
		elseif v2.kind == "fetchConversationDetails" then
			fetchConversationDetailsSafe(
				channelId,
				p2.Type == "AddedToChannel" or p2.Type == "ChannelCreated",
				requestConversationListRefresh
			)
		end
	end, {})

	RealtimeDelivery.useRealtimeConnectionStateChanged("CommunicationChannels", function(p2, flag: boolean)
		if p2 ~= Enum.ConnectionState.Connected or not flag then
			return
		end

		local v2 = GetFriendsChatRealtimeStore(false).getActiveConversationId(false)
			or FStringDebugFriendsChatConversationId

		if v2 ~= "" then
			fetchNewerMessagesSafe(v2, onActiveConversationMessageReceived)
		end
	end, {})

	RealtimeDelivery.useRealtimeNamespace(FriendshipNotifications.Namespace, function(p2)
		if p2 == nil or p2.Type ~= FriendshipNotifications.EventType.Created then
			return
		end

		v:info(`Received friendship notification: {p2.Type}`)
		ref.current = true
		ref2.current += 1
		local current = ref2.current

		local v2 = "friendship update"
		local function attempt(p3: number)
			if ref2.current ~= current then
				return
			end

			if ExpChatConversationListAdapter.getConversationStore().getListStatus(false).isFetchingConversations == true then
				if p3 <= 0 then
					ref.current = false
					v:warning(`Gave up refreshing conversation list after {v2}: fetch still in flight`)
				else
					task.delay(1, function()
						attempt(p3 - 1)
					end)
				end
			else
				if not ref.current then
					return
				end

				ref.current = false

				ExpChatConversationListAdapter.fetchConversationListPageToSignals():catch(function(p4)
					v:warning(`Failed to refresh conversation list after {v2}: {tostring(p4)}`)
				end)
			end
		end

		attempt(3)
	end, {})

	React.useEffect(function()
		return function()
			ref2.current += 1
		end
	end, {})

	return nil
end

return FriendsChatRealtimeSubscriber
