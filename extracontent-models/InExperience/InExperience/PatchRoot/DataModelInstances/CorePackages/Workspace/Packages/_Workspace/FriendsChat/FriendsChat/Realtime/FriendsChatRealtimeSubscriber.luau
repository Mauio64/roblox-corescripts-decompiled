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
local FFlagFriendsChatTabUnreadBadgeFix = require(script.Parent.Parent.Flags.FFlagFriendsChatTabUnreadBadgeFix)
local v13 = ExpChatShared.Logger:new(script.Name)

local function fetchNewerMessagesSafe(s1: string) -- line: 53
	-- upvalues: ExpChatConversationListAdapter (copy), fetchNewerMessages (copy), GetFriendsChatRealtimeStore (copy), Players (copy), FFlagFriendsChatTabUnreadBadgeFix (copy), v13 (copy)
	local v21 = ExpChatConversationListAdapter.getConversationStore().getConversation(s1, false)
	local v22 = v21 and v21.lastUpdated

	fetchNewerMessages(s1):andThen(function(p1) -- line: 59
		-- upvalues: GetFriendsChatRealtimeStore (copy), Players (copy), s1 (copy), ExpChatConversationListAdapter (copy), v22 (copy), FFlagFriendsChatTabUnreadBadgeFix (copy)
		local v37 = p1 and p1.response
		local v38 = v37 and v37.responseBody
		local v39 = if not v38 then {} else v38.messages or {}
		local v40 = GetFriendsChatRealtimeStore(false)
		local v41 = v40.getActiveConversationId(false)
		local LocalPlayer = Players.LocalPlayer
		local v43 = v41 ~= s1
		local _, v45 = ExpChatConversationListAdapter.updateConversationPreviewFromMessages(s1, v39, {
			refreshListOnMissingConversation = true,
			hasUnreadMessages = v43,
			localUserId = not LocalPlayer and 0 or LocalPlayer.UserId,
			unreadFreshnessLastUpdated = v22
		})

		if v45 then
			if FFlagFriendsChatTabUnreadBadgeFix then
				v40.addLocalUnread(s1)
			else
				v40.setHasLocalUnread(true)
			end
		end

		if v41 == s1 then
			ExpChatConversationListAdapter.markConversationRead(s1, true)
		end
	end):catch(function(p2) -- line: 87
		-- upvalues: v13 (copy), s1 (copy)
		v13:warning(`Failed to fetch newer messages for { s1 }: { tostring(p2) }`)
	end)
end
local function getFirstConversationResponse(p3) -- line: 94
	local v24 = if p3 == nil then nil else p3.responseBody or p3
	local v25 = v24 and v24.conversations

	if v25 ~= nil then
		return v25[1]
	end

	return nil
end
local function updateSelectedFriendPlaceholder(s2: string, p4) -- line: 100
	-- upvalues: ConversationChannels (copy), GetFriendsChatNavigationStore (copy)
	local v28 = if p4 == nil then nil else p4.responseBody or p4
	local v29 = v28 and v28.conversations
	local v30 = if v29 == nil then nil else v29[1]

	if v30 == nil or (v30.source ~= ConversationChannels.Source.Channels or v30.type ~= ConversationChannels.Type.OneToOne or v30.participant_user_ids == nil) then
		return
	end

	local v31 = ConversationChannels.getFriendConversationId(v30.participant_user_ids)
	local v32 = GetFriendsChatNavigationStore(false)

	if v31 == v32.getSelectedConversationId(false) then
		v32.setSelectedConversationId(v30.id or s2)
	end
end
local function fetchConversationDetailsSafe(s3: string) -- line: 119
	-- upvalues: ExpChatConversationListAdapter (copy), updateSelectedFriendPlaceholder (copy), v13 (copy)
	ExpChatConversationListAdapter.fetchConversationDetailsToSignals(s3):andThen(function(p5) -- line: 121
		-- upvalues: updateSelectedFriendPlaceholder (copy), s3 (copy)
		updateSelectedFriendPlaceholder(s3, p5)
	end):catch(function(p6) -- line: 124
		-- upvalues: v13 (copy), s3 (copy)
		v13:warning(`Failed to fetch conversation details for { s3 }: { tostring(p6) }`)
	end)
end
local function handleRemove(s4: string) -- line: 130
	-- upvalues: ExpChatConversationListAdapter (copy), GetFriendsChatNavigationStore (copy)
	ExpChatConversationListAdapter.removeConversation(s4)

	local v35 = GetFriendsChatNavigationStore(false)

	if s4 == v35.getSelectedConversationId(false) then
		v35.setSelectedConversationId(nil)
	end
end
local function FriendsChatRealtimeSubscriber() -- line: 138
	-- upvalues: RealtimeDelivery (copy), classifyCommunicationChannelsEvent (copy), fetchNewerMessagesSafe (copy), ExpChatConversationListAdapter (copy), GetFriendsChatNavigationStore (copy), fetchConversationDetailsSafe (copy), GetFriendsChatRealtimeStore (copy), FStringDebugFriendsChatConversationId (copy)
	RealtimeDelivery.useRealtimeNamespace("CommunicationChannels", function(p7) -- line: 139
		-- upvalues: classifyCommunicationChannelsEvent (copy), fetchNewerMessagesSafe (copy), ExpChatConversationListAdapter (copy), GetFriendsChatNavigationStore (copy), fetchConversationDetailsSafe (copy)
		local v50 = classifyCommunicationChannelsEvent(p7)
		local channelId = v50.channelId

		if channelId == nil then
			return
		end

		if v50.kind == "fetchMessage" then
			fetchNewerMessagesSafe(channelId)

			return
		end

		if v50.kind == "removeConversation" then
			ExpChatConversationListAdapter.removeConversation(channelId)

			local v52 = GetFriendsChatNavigationStore(false)

			if channelId == v52.getSelectedConversationId(false) then
				v52.setSelectedConversationId(nil)

				return
			end
		elseif v50.kind == "fetchConversationDetails" then
			fetchConversationDetailsSafe(channelId)
		end
	end, {})
	RealtimeDelivery.useRealtimeConnectionStateChanged("CommunicationChannels", function(p8, b1: boolean) -- line: 157
		-- upvalues: GetFriendsChatRealtimeStore (copy), FStringDebugFriendsChatConversationId (copy), fetchNewerMessagesSafe (copy)
		if p8 ~= Enum.ConnectionState.Connected or not b1 then
			return
		end

		local v55 = GetFriendsChatRealtimeStore(false).getActiveConversationId(false) or FStringDebugFriendsChatConversationId

		if v55 ~= "" then
			fetchNewerMessagesSafe(v55)
		end
	end, {})

	return nil
end

return FriendsChatRealtimeSubscriber
