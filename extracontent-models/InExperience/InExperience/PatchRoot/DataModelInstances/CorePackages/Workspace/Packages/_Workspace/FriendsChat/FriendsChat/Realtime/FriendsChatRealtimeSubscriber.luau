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

local function fetchNewerMessagesSafe(s1: string) -- line: 52
	-- upvalues: ExpChatConversationListAdapter (copy), fetchNewerMessages (copy), GetFriendsChatRealtimeStore (copy), Players (copy), v12 (copy)
	local v20 = ExpChatConversationListAdapter.getConversationStore().getConversation(s1, false)
	local v21 = v20 and v20.lastUpdated

	fetchNewerMessages(s1):andThen(function(p1) -- line: 58
		-- upvalues: GetFriendsChatRealtimeStore (copy), Players (copy), s1 (copy), ExpChatConversationListAdapter (copy), v21 (copy)
		local v36 = p1 and p1.response
		local v37 = v36 and v36.responseBody
		local v38 = if not v37 then {} else v37.messages or {}
		local v39 = GetFriendsChatRealtimeStore(false)
		local v40 = v39.getActiveConversationId(false)
		local LocalPlayer = Players.LocalPlayer
		local v42 = v40 ~= s1
		local _, v44 = ExpChatConversationListAdapter.updateConversationPreviewFromMessages(s1, v38, {
			refreshListOnMissingConversation = true,
			hasUnreadMessages = v42,
			localUserId = not LocalPlayer and 0 or LocalPlayer.UserId,
			unreadFreshnessLastUpdated = v21
		})

		if v44 then
			v39.setHasLocalUnread(true)
		end

		if v40 == s1 then
			ExpChatConversationListAdapter.markConversationRead(s1, true)
		end
	end):catch(function(p2) -- line: 82
		-- upvalues: v12 (copy), s1 (copy)
		v12:warning(`Failed to fetch newer messages for { s1 }: { tostring(p2) }`)
	end)
end
local function getFirstConversationResponse(p3) -- line: 89
	local v23 = if p3 == nil then nil else p3.responseBody or p3
	local v24 = v23 and v23.conversations

	if v24 ~= nil then
		return v24[1]
	end

	return nil
end
local function updateSelectedFriendPlaceholder(s2: string, p4) -- line: 95
	-- upvalues: ConversationChannels (copy), GetFriendsChatNavigationStore (copy)
	local v27 = if p4 == nil then nil else p4.responseBody or p4
	local v28 = v27 and v27.conversations
	local v29 = if v28 == nil then nil else v28[1]

	if v29 == nil or (v29.source ~= ConversationChannels.Source.Channels or v29.type ~= ConversationChannels.Type.OneToOne or v29.participant_user_ids == nil) then
		return
	end

	local v30 = ConversationChannels.getFriendConversationId(v29.participant_user_ids)
	local v31 = GetFriendsChatNavigationStore(false)

	if v30 == v31.getSelectedConversationId(false) then
		v31.setSelectedConversationId(v29.id or s2)
	end
end
local function fetchConversationDetailsSafe(s3: string) -- line: 114
	-- upvalues: ExpChatConversationListAdapter (copy), updateSelectedFriendPlaceholder (copy), v12 (copy)
	ExpChatConversationListAdapter.fetchConversationDetailsToSignals(s3):andThen(function(p5) -- line: 116
		-- upvalues: updateSelectedFriendPlaceholder (copy), s3 (copy)
		updateSelectedFriendPlaceholder(s3, p5)
	end):catch(function(p6) -- line: 119
		-- upvalues: v12 (copy), s3 (copy)
		v12:warning(`Failed to fetch conversation details for { s3 }: { tostring(p6) }`)
	end)
end
local function handleRemove(s4: string) -- line: 125
	-- upvalues: ExpChatConversationListAdapter (copy), GetFriendsChatNavigationStore (copy)
	ExpChatConversationListAdapter.removeConversation(s4)

	local v34 = GetFriendsChatNavigationStore(false)

	if s4 == v34.getSelectedConversationId(false) then
		v34.setSelectedConversationId(nil)
	end
end
local function FriendsChatRealtimeSubscriber() -- line: 133
	-- upvalues: RealtimeDelivery (copy), classifyCommunicationChannelsEvent (copy), fetchNewerMessagesSafe (copy), ExpChatConversationListAdapter (copy), GetFriendsChatNavigationStore (copy), fetchConversationDetailsSafe (copy), GetFriendsChatRealtimeStore (copy), FStringDebugFriendsChatConversationId (copy)
	RealtimeDelivery.useRealtimeNamespace("CommunicationChannels", function(p7) -- line: 134
		-- upvalues: classifyCommunicationChannelsEvent (copy), fetchNewerMessagesSafe (copy), ExpChatConversationListAdapter (copy), GetFriendsChatNavigationStore (copy), fetchConversationDetailsSafe (copy)
		local v49 = classifyCommunicationChannelsEvent(p7)
		local channelId = v49.channelId

		if channelId == nil then
			return
		end

		if v49.kind == "fetchMessage" then
			fetchNewerMessagesSafe(channelId)

			return
		end

		if v49.kind == "removeConversation" then
			ExpChatConversationListAdapter.removeConversation(channelId)

			local v51 = GetFriendsChatNavigationStore(false)

			if channelId == v51.getSelectedConversationId(false) then
				v51.setSelectedConversationId(nil)

				return
			end
		elseif v49.kind == "fetchConversationDetails" then
			fetchConversationDetailsSafe(channelId)
		end
	end, {})
	RealtimeDelivery.useRealtimeConnectionStateChanged("CommunicationChannels", function(p8, b1: boolean) -- line: 152
		-- upvalues: GetFriendsChatRealtimeStore (copy), FStringDebugFriendsChatConversationId (copy), fetchNewerMessagesSafe (copy)
		if p8 ~= Enum.ConnectionState.Connected or not b1 then
			return
		end

		local v54 = GetFriendsChatRealtimeStore(false).getActiveConversationId(false) or FStringDebugFriendsChatConversationId

		if v54 ~= "" then
			fetchNewerMessagesSafe(v54)
		end
	end, {})

	return nil
end

return FriendsChatRealtimeSubscriber
