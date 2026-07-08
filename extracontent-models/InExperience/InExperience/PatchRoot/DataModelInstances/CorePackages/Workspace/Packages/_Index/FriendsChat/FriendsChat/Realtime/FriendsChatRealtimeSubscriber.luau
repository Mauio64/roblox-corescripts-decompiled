local Parent = script:FindFirstAncestor("FriendsChat").Parent
local Players = game:GetService("Players")
local RealtimeDelivery = require(Parent.RealtimeDelivery)
local ExpChatShared = require(Parent.ExpChatShared)
local ConversationChannels = require(Parent.AppChat.ConversationChannels)
local fetchNewerMessages = require(Parent.AppChat.fetchNewerMessages)
local classifyCommunicationChannelsEvent = require(script.Parent.classifyCommunicationChannelsEvent)
local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local GetFriendsChatNavigationStore = require(script.Parent.Parent.Stores.GetFriendsChatNavigationStore)
local GetFriendsChatRealtimeStore = require(script.Parent.Parent.Stores.GetFriendsChatRealtimeStore)
local FStringDebugFriendsChatConversationId = require(script.Parent.Parent.Flags.FStringDebugFriendsChatConversationId)
local v12 = ExpChatShared.Logger:new(script.Name)

local function fetchNewerMessagesSafe(s1: string) -- line: 48
	-- upvalues: fetchNewerMessages (copy), GetFriendsChatRealtimeStore (copy), Players (copy), ExpChatConversationListAdapter (copy), v12 (copy)
	fetchNewerMessages(s1):andThen(function(p1) -- line: 50
		-- upvalues: GetFriendsChatRealtimeStore (copy), Players (copy), ExpChatConversationListAdapter (copy), s1 (copy)
		local v34 = p1 and p1.response
		local v35 = v34 and v34.responseBody
		local v36 = if not v35 then {} else v35.messages or {}
		local v37 = GetFriendsChatRealtimeStore(false)
		local v38 = v37.getActiveConversationId(false)
		local LocalPlayer = Players.LocalPlayer
		local _, v41 = ExpChatConversationListAdapter.updateConversationPreviewFromMessages(s1, v36, {
			refreshListOnMissingConversation = true,
			hasUnreadMessages = v38 ~= s1,
			localUserId = not LocalPlayer and 0 or LocalPlayer.UserId
		})

		if v41 then
			v37.setHasLocalUnread(true)
		end

		if v38 == s1 then
			ExpChatConversationListAdapter.markConversationRead(s1, true)
		end
	end):catch(function(p2) -- line: 74
		-- upvalues: v12 (copy), s1 (copy)
		v12:warning(`Failed to fetch newer messages for { s1 }: { tostring(p2) }`)
	end)
end
local function getFirstConversationResponse(p3) -- line: 81
	local v21 = if p3 == nil then nil else p3.responseBody or p3
	local v22 = v21 and v21.conversations

	if v22 ~= nil then
		return v22[1]
	end

	return nil
end
local function updateSelectedFriendPlaceholder(s2: string, p4) -- line: 87
	-- upvalues: ConversationChannels (copy), GetFriendsChatNavigationStore (copy)
	local v25 = if p4 == nil then nil else p4.responseBody or p4
	local v26 = v25 and v25.conversations
	local v27 = if v26 == nil then nil else v26[1]

	if v27 == nil or (v27.source ~= ConversationChannels.Source.Channels or v27.type ~= ConversationChannels.Type.OneToOne or v27.participant_user_ids == nil) then
		return
	end

	local v28 = ConversationChannels.getFriendConversationId(v27.participant_user_ids)
	local v29 = GetFriendsChatNavigationStore(false)

	if v28 == v29.getSelectedConversationId(false) then
		v29.setSelectedConversationId(v27.id or s2)
	end
end
local function fetchConversationDetailsSafe(s3: string) -- line: 106
	-- upvalues: ExpChatConversationListAdapter (copy), updateSelectedFriendPlaceholder (copy), v12 (copy)
	ExpChatConversationListAdapter.fetchConversationDetailsToSignals(s3):andThen(function(p5) -- line: 108
		-- upvalues: updateSelectedFriendPlaceholder (copy), s3 (copy)
		updateSelectedFriendPlaceholder(s3, p5)
	end):catch(function(p6) -- line: 111
		-- upvalues: v12 (copy), s3 (copy)
		v12:warning(`Failed to fetch conversation details for { s3 }: { tostring(p6) }`)
	end)
end
local function handleRemove(s4: string) -- line: 117
	-- upvalues: ExpChatConversationListAdapter (copy), GetFriendsChatNavigationStore (copy)
	ExpChatConversationListAdapter.removeConversation(s4)

	local v32 = GetFriendsChatNavigationStore(false)

	if s4 == v32.getSelectedConversationId(false) then
		v32.setSelectedConversationId(nil)
	end
end
local function FriendsChatRealtimeSubscriber() -- line: 125
	-- upvalues: RealtimeDelivery (copy), classifyCommunicationChannelsEvent (copy), fetchNewerMessagesSafe (copy), ExpChatConversationListAdapter (copy), GetFriendsChatNavigationStore (copy), fetchConversationDetailsSafe (copy), GetFriendsChatRealtimeStore (copy), FStringDebugFriendsChatConversationId (copy)
	RealtimeDelivery.useRealtimeNamespace("CommunicationChannels", function(p7) -- line: 126
		-- upvalues: classifyCommunicationChannelsEvent (copy), fetchNewerMessagesSafe (copy), ExpChatConversationListAdapter (copy), GetFriendsChatNavigationStore (copy), fetchConversationDetailsSafe (copy)
		local v46 = classifyCommunicationChannelsEvent(p7)
		local channelId = v46.channelId

		if channelId == nil then
			return
		end

		if v46.kind == "fetchMessage" then
			fetchNewerMessagesSafe(channelId)

			return
		end

		if v46.kind == "removeConversation" then
			ExpChatConversationListAdapter.removeConversation(channelId)

			local v48 = GetFriendsChatNavigationStore(false)

			if channelId == v48.getSelectedConversationId(false) then
				v48.setSelectedConversationId(nil)

				return
			end
		elseif v46.kind == "fetchConversationDetails" then
			fetchConversationDetailsSafe(channelId)
		end
	end, {})
	RealtimeDelivery.useRealtimeConnectionStateChanged("CommunicationChannels", function(p8, b1: boolean) -- line: 144
		-- upvalues: GetFriendsChatRealtimeStore (copy), FStringDebugFriendsChatConversationId (copy), fetchNewerMessagesSafe (copy)
		if p8 ~= Enum.ConnectionState.Connected or not b1 then
			return
		end

		local v51 = GetFriendsChatRealtimeStore(false).getActiveConversationId(false) or FStringDebugFriendsChatConversationId

		if v51 ~= "" then
			fetchNewerMessagesSafe(v51)
		end
	end, {})

	return nil
end

return FriendsChatRealtimeSubscriber
