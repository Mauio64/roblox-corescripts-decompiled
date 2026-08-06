local Parent = script:FindFirstAncestor("FriendsChat").Parent
local Players = game:GetService("Players")
local React = require(Parent.React)
local RealtimeDelivery = require(Parent.RealtimeDelivery)
local ExpChatShared = require(Parent.ExpChatShared)
local ConversationChannels = require(Parent.AppChat.ConversationChannels)
local fetchNewerMessages = require(Parent.AppChat.fetchNewerMessages)
local classifyCommunicationChannelsEvent = require(script.Parent.classifyCommunicationChannelsEvent)
local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local GetFriendsChatNavigationStore = require(script.Parent.Parent.Stores.GetFriendsChatNavigationStore)
local GetFriendsChatRealtimeStore = require(script.Parent.Parent.Stores.GetFriendsChatRealtimeStore)
local FStringDebugFriendsChatConversationId = require(script.Parent.Parent.Flags.FStringDebugFriendsChatConversationId)
local v13 = ExpChatShared.Logger:new(script.Name)

local function fetchNewerMessagesSafe(s1: string) -- line: 59
	-- upvalues: ExpChatConversationListAdapter (copy), fetchNewerMessages (copy), GetFriendsChatRealtimeStore (copy), Players (copy), v13 (copy)
	local v21 = ExpChatConversationListAdapter.getConversationStore().getConversation(s1, false)
	local v22 = v21 and v21.lastUpdated

	fetchNewerMessages(s1):andThen(function(p1) -- line: 65
		-- upvalues: GetFriendsChatRealtimeStore (copy), Players (copy), s1 (copy), ExpChatConversationListAdapter (copy), v22 (copy)
		local v40 = p1 and p1.response
		local v41 = v40 and v40.responseBody
		local v42 = if not v41 then {} else v41.messages or {}
		local v43 = GetFriendsChatRealtimeStore(false)
		local v44 = v43.getActiveConversationId(false)
		local LocalPlayer = Players.LocalPlayer
		local v46 = v44 ~= s1
		local _, v48 = ExpChatConversationListAdapter.updateConversationPreviewFromMessages(s1, v42, {
			refreshListOnMissingConversation = true,
			hasUnreadMessages = v46,
			localUserId = not LocalPlayer and 0 or LocalPlayer.UserId,
			unreadFreshnessLastUpdated = v22
		})

		if v48 then
			v43.addLocalUnread(s1)
		end

		if v44 == s1 then
			ExpChatConversationListAdapter.markConversationRead(s1, true)
		end
	end):catch(function(p2) -- line: 89
		-- upvalues: v13 (copy), s1 (copy)
		v13:warning(`Failed to fetch newer messages for { s1 }: { tostring(p2) }`)
	end)
end
local function getFirstConversationResponse(p3) -- line: 96
	local v24 = if p3 == nil then nil else p3.responseBody or p3
	local v25 = v24 and v24.conversations

	if v25 ~= nil then
		return v25[1]
	end

	return nil
end
local function updateSelectedFriendPlaceholder(s2: string, p4) -- line: 102
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
local function fetchConversationDetailsSafe(s3: string) -- line: 121
	-- upvalues: ExpChatConversationListAdapter (copy), updateSelectedFriendPlaceholder (copy), v13 (copy)
	ExpChatConversationListAdapter.fetchConversationDetailsToSignals(s3):andThen(function(p5) -- line: 123
		-- upvalues: updateSelectedFriendPlaceholder (copy), s3 (copy)
		updateSelectedFriendPlaceholder(s3, p5)
	end):catch(function(p6) -- line: 126
		-- upvalues: v13 (copy), s3 (copy)
		v13:warning(`Failed to fetch conversation details for { s3 }: { tostring(p6) }`)
	end)
end
local function handleRemove(s4: string) -- line: 132
	-- upvalues: ExpChatConversationListAdapter (copy), GetFriendsChatNavigationStore (copy)
	ExpChatConversationListAdapter.removeConversation(s4)

	local v35 = GetFriendsChatNavigationStore(false)

	if s4 == v35.getSelectedConversationId(false) then
		v35.setSelectedConversationId(nil)
	end
end
local function FriendsChatRealtimeSubscriber() -- line: 143
	-- upvalues: React (copy), ExpChatConversationListAdapter (copy), v13 (copy), RealtimeDelivery (copy), classifyCommunicationChannelsEvent (copy), fetchNewerMessagesSafe (copy), GetFriendsChatNavigationStore (copy), fetchConversationDetailsSafe (copy), GetFriendsChatRealtimeStore (copy), FStringDebugFriendsChatConversationId (copy)
	local v36 = React.useRef(false)
	local v37 = React.useRef(0)

	local function requestFriendshipListRefresh() -- line: 151
		-- upvalues: v36 (copy), v37 (copy), ExpChatConversationListAdapter (copy), v13 (copy)
		v36.current = true

		local v52 = v37

		v52.current = v52.current + 1

		local current = v37.current

		local function attempt(n1: number) -- line: 156
			-- upvalues: v37 (copy), current (copy), ExpChatConversationListAdapter (copy), v36 (copy), v13 (copy), attempt (copy)
			if v37.current ~= current then
				return
			end

			if ExpChatConversationListAdapter.getConversationStore().getListStatus(false).isFetchingConversations == true then
				if n1 <= 0 then
					v36.current = false
					v13:warning("Gave up refreshing conversation list after friendship update: fetch still in flight")

					return
				end

				task.delay(1, function() -- line: 170
					-- upvalues: attempt (copy), n1 (copy)
					attempt(n1 - 1)
				end)

				return
			end

			if not v36.current then
				return
			end

			v36.current = false
			ExpChatConversationListAdapter.fetchConversationListPageToSignals():catch(function(p7) -- line: 181
				-- upvalues: v13 (copy)
				v13:warning(`Failed to refresh conversation list after friendship update: { tostring(p7) }`)
			end)
		end

		attempt(3)
	end

	RealtimeDelivery.useRealtimeNamespace("CommunicationChannels", function(p8) -- line: 189
		-- upvalues: classifyCommunicationChannelsEvent (copy), fetchNewerMessagesSafe (copy), ExpChatConversationListAdapter (copy), GetFriendsChatNavigationStore (copy), fetchConversationDetailsSafe (copy)
		local v56 = classifyCommunicationChannelsEvent(p8)
		local channelId = v56.channelId

		if channelId == nil then
			return
		end

		if v56.kind == "fetchMessage" then
			fetchNewerMessagesSafe(channelId)

			return
		end

		if v56.kind == "removeConversation" then
			ExpChatConversationListAdapter.removeConversation(channelId)

			local v58 = GetFriendsChatNavigationStore(false)

			if channelId == v58.getSelectedConversationId(false) then
				v58.setSelectedConversationId(nil)

				return
			end
		elseif v56.kind == "fetchConversationDetails" then
			fetchConversationDetailsSafe(channelId)
		end
	end, {})
	RealtimeDelivery.useRealtimeConnectionStateChanged("CommunicationChannels", function(p9, b1: boolean) -- line: 207
		-- upvalues: GetFriendsChatRealtimeStore (copy), FStringDebugFriendsChatConversationId (copy), fetchNewerMessagesSafe (copy)
		if p9 ~= Enum.ConnectionState.Connected or not b1 then
			return
		end

		local v61 = GetFriendsChatRealtimeStore(false).getActiveConversationId(false) or FStringDebugFriendsChatConversationId

		if v61 ~= "" then
			fetchNewerMessagesSafe(v61)
		end
	end, {})
	RealtimeDelivery.useRealtimeNamespace("FriendshipNotifications", function(p10) -- line: 221
		-- upvalues: v13 (copy), v36 (copy), v37 (copy), ExpChatConversationListAdapter (copy)
		if p10 == nil or p10.Type ~= "FriendshipCreated" then
			return
		end

		v13:info(`Received friendship notification: { p10.Type }`)
		v36.current = true

		local v63 = v37

		v63.current = v63.current + 1

		local current = v37.current

		local function attempt(n2: number) -- line: 156
			-- upvalues: v37 (copy), current (copy), ExpChatConversationListAdapter (copy), v36 (copy), v13 (copy), attempt (copy)
			if v37.current ~= current then
				return
			end

			if ExpChatConversationListAdapter.getConversationStore().getListStatus(false).isFetchingConversations == true then
				if n2 <= 0 then
					v36.current = false
					v13:warning("Gave up refreshing conversation list after friendship update: fetch still in flight")

					return
				end

				task.delay(1, function() -- line: 170
					-- upvalues: attempt (copy), n2 (copy)
					attempt(n2 - 1)
				end)

				return
			end

			if not v36.current then
				return
			end

			v36.current = false
			ExpChatConversationListAdapter.fetchConversationListPageToSignals():catch(function(p11) -- line: 181
				-- upvalues: v13 (copy)
				v13:warning(`Failed to refresh conversation list after friendship update: { tostring(p11) }`)
			end)
		end

		attempt(3)
	end, {})
	React.useEffect(function() -- line: 229
		-- upvalues: v37 (copy)
		return function() -- line: 230
			-- upvalues: v37 (copy)
			local v68 = v37

			v68.current = v68.current + 1
		end
	end, {})

	return nil
end

return FriendsChatRealtimeSubscriber
