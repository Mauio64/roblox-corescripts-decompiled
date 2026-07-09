local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Localization = require(AppChatParent.Localization)
local React = require(AppChatParent.React)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local RoactUtils = require(AppChatParent.RoactUtils)
local Cryo = require(AppChatParent.Cryo)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useLocalization = Localization.Hooks.useLocalization
local useMemo = React.useMemo
local useRef = React.useRef
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FormFactor = require(AppChatParent.FormFactor).Enums.FormFactor
local v17 = require(AppChat.Logger):new("AppChat.Realtime")
local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local ChangedParticipants = require(AppChat.Conversations.Actions.ChangedParticipants)
local RoduxAliases = require(AppChat.Http.RoduxAliases)
local ReceivedUserTyping = require(AppChat.Conversations.Actions.ReceivedUserTyping)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local RenamedGroupConversation = require(AppChat.Conversations.Actions.RenamedGroupConversation)
local SetConnectionState = require(AppChat.Actions.SetConnectionState)
local FriendConversationCreated = require(AppChat.Conversations.Actions.FriendConversationCreated)
local FriendshipDestroyed = require(AppChat.Actions.FriendshipDestroyed)
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local useIsGroupChatEnabled = require(AppChat.Hooks.useIsGroupChatEnabled)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local Messages = require(AppChat.Components.ChatConversation.Messages)
local EnumScreens = require(AppChat.EnumScreens)
local getNewMessages = Messages.Thunks.getNewMessages
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local paginateAndRefreshConversations = require(AppChat.Conversations.Thunks.paginateAndRefreshConversations)
local fetchChatMetadata = require(AppChat.Conversations.Thunks.fetchChatMetadata)
local getAllUserPresences = require(AppChat.Conversations.Thunks.getAllUserPresences)
local fetchLatestConversationDetails = require(AppChat.Conversations.Thunks.fetchLatestConversationDetails)
local getAllFriendsAsync = require(AppChat.Conversations.Thunks.getAllFriendsAsync)
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local multiGetConversationDetails = require(AppChat.Conversations.Thunks.multiGetConversationDetails)
local refreshConversationUnfilteredThreadsDetails = require(AppChat.Conversations.Thunks.refreshConversationUnfilteredThreadsDetails)
local CommunicationChannelsTypes = require(script.Parent.CommunicationChannelsTypes)

require(script.Parent.UnfilteredThreadsTypes)
require(script.Parent.ChatMigrationTypes)

local useChatTrustedConnectionsEvents = require(AppChat.Components.EventReceivers.useChatTrustedConnectionsEvents)
local getFFlagDebugUnfilteredThreads = require(AppChatParent.SharedFlags).getFFlagDebugUnfilteredThreads
local FFlagAppChatEnableDoubleOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableDoubleOptIn

local function chunkAndLogString(p1) -- line: 61
	-- upvalues: v17 (copy)
	local t1 = {}

	for i = 1, #p1, 800 do
		table.insert(t1, p1:sub(i, i + 800 - 1))
	end

	for _, v55 in t1 do
		v17:debug(v55)
	end
end

local t2 = {
	handlesAppShellNotifications = true
}

function ChatEventReceiver(t3: {[any]: any}) -- line: 84
	-- upvalues: useEffect (copy), v17 (copy), useSelector (copy), useCallback (copy), Cryo (copy), useLocalUserId (copy), useIsChatEnabled (copy), useIsGroupChatEnabled (copy), useIsInExperience (copy), useDispatch (copy), ChangedParticipants (copy), fetchChatMetadata (copy), fetchLatestConversationDetails (copy), getAllFriendsAsync (copy), getAllUserPresences (copy), getNewMessages (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), RoduxAliases (copy), ReceivedUserTyping (copy), paginateAndRefreshConversations (copy), RemovedConversation (copy), RenamedGroupConversation (copy), SetConnectionState (copy), t2 (copy), useRef (copy), useLocalization (copy), RoactNavigation (copy), EnumScreens (copy), FormFactor (copy), FriendshipDestroyed (copy), Conversation (copy), CommunicationChannelsTypes (copy), ConversationChannels (copy), FriendConversationCreated (copy), useMemo (copy), getFFlagDebugUnfilteredThreads (copy), chunkAndLogString (copy), multiGetConversationDetails (copy), AppChatNetworking (copy), FFlagAppChatEnableDoubleOptIn (copy), refreshConversationUnfilteredThreadsDetails (copy), useChatTrustedConnectionsEvents (copy)
	useEffect(function() -- line: 85
		-- upvalues: v17 (copy)
		v17:info("ChatEventReceiver mounted")

		return function() -- line: 87
			-- upvalues: v17 (copy)
			v17:info("ChatEventReceiver unmounted")
		end
	end, {})

	local v57 = useSelector(useCallback(function(p2) -- line: 93
		return p2.ChatAppReducer.AppLoaded
	end, {}))
	local v58 = useSelector(useCallback(function(p3) -- line: 96
		return p3.ChatAppReducer.Conversations
	end, {}))
	local v59 = useSelector(useCallback(function(p4) -- line: 99
		return p4.FormFactor
	end, {}))
	local v60 = useSelector(useCallback(function(p5) -- line: 102
		return p5.Users
	end, {}))
	local v61 = Cryo.isEmpty(v58)
	local v62 = useLocalUserId()
	local v63 = useIsChatEnabled()
	local v64 = useIsGroupChatEnabled()
	local v65 = useIsInExperience()
	local v66 = useDispatch()

	local function v67(p6) -- line: 120
		-- upvalues: v66 (copy), fetchLatestConversationDetails (copy)
		return v66(fetchLatestConversationDetails(p6))
	end
	local function restartMessageReceiveTracking(s1: string) -- line: 135
		-- upvalues: FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy)
		if not FFlagAppChatPerfTracking then
			return
		end

		local t4 = {
			conversationId = tostring(s1)
		}

		if FFlagAppChatMessageTTIMilestones then
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveTTI, t4)
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageReceiveTTI, t4)

			return
		end

		AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveToRender, t4)
		AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageReceiveToRender, t4)
	end
	local function v69() -- line: 155
		-- upvalues: v66 (copy), paginateAndRefreshConversations (copy)
		v66(paginateAndRefreshConversations())
	end

	local v70 = Cryo.Dictionary.join(t2, t3)
	local robloxEventReceiver = v70.robloxEventReceiver
	local v72 = useRef({})
	local v73 = useRef(Enum.ConnectionState.Connected)
	local v74 = useLocalization({
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		removedFromConversationToastTitle = "Feature.Chat.Message.RemovedFromConversation"
	})
	local networkErrorText = v74.networkErrorText
	local removedFromConversationToastTitle = v74.removedFromConversationToastTitle
	local v77 = useCallback(function(s2: string, p7) -- line: 182
		-- upvalues: v72 (copy)
		assert(v72.current, "table")
		v72.current[s2] = p7
	end, { v72.current })
	local v78 = useCallback(function() -- line: 187
		-- upvalues: v70 (copy), RoactNavigation (copy), EnumScreens (copy), networkErrorText (copy)
		if v70.rnBypassActionSignal then
			v70.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = EnumScreens.RoactChatToast,
				params = {
					toastProps = {
						toastContent = {
							toastTitle = networkErrorText
						}
					}
				}
			}))
		end
	end, {
		v70.rnBypassActionSignal,
		networkErrorText
	})

	useEffect(function() -- line: 202
		-- upvalues: robloxEventReceiver (copy), v77 (copy), v17 (copy), v66 (copy), RemovedConversation (copy), v70 (copy), RoactNavigation (copy), v59 (copy), FormFactor (copy), EnumScreens (copy), removedFromConversationToastTitle (copy), fetchLatestConversationDetails (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v61 (copy), FFlagAppChatPerfTracking (copy), restartMessageReceiveTracking (copy), getNewMessages (copy), ReceivedUserTyping (copy)
		local v108 = robloxEventReceiver:observeEvent("ChatNotifications", function(p8, p9, _) -- line: 203
			-- upvalues: v77 (copy), v17 (copy), v66 (copy), RemovedConversation (copy), v70 (copy), RoactNavigation (copy), v59 (copy), FormFactor (copy), EnumScreens (copy), removedFromConversationToastTitle (copy), fetchLatestConversationDetails (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v61 (copy), FFlagAppChatPerfTracking (copy), restartMessageReceiveTracking (copy), getNewMessages (copy), ReceivedUserTyping (copy)
			v77("ChatNotifications", p8.SequenceNumber)

			local v119 = p8.Type or p9

			v17:info("Received chat notification: {}", v119)

			local v120 = p8.ConversationId and tostring(p8.ConversationId) or ""

			if v119 == "RemovedFromConversation" or v119 == "ConversationRemoved" then
				v66(RemovedConversation(v120))

				local activeConversationId = v70.activeConversationId

				if activeConversationId ~= nil and v120 == tostring(activeConversationId) and v70.rnBypassActionSignal then
					v70.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v59 == FormFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
					}))
				end

				if v119 == "RemovedFromConversation" then
					v70.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = EnumScreens.RoactChatToast,
						params = {
							toastProps = {
								toastContent = {
									toastTitle = removedFromConversationToastTitle
								}
							}
						}
					}))

					return
				end
			else
				if v119 == "ConversationTitleChanged" or v119 == "ParticipantAdded" or v119 == "ParticipantLeft" then
					task.spawn(function() -- line: 241
						-- upvalues: v120 (copy), v66 (copy), fetchLatestConversationDetails (copy), v119 (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v17 (copy)
						local v168 = v120

						v66(fetchLatestConversationDetails(v168)):andThen(function(p11) -- line: 243
							-- upvalues: v119 (copy), v120 (copy), v66 (copy), RenamedGroupConversation (copy), ChangedParticipants (copy)
							local title = p11.title
							local lastUpdated = p11.lastUpdated

							if v119 == "ConversationTitleChanged" then
								local v182 = v120
								local isDefaultTitle = p11.isDefaultTitle

								v66(RenamedGroupConversation(v182, title, isDefaultTitle, lastUpdated))

								return
							end

							local v184 = v120
							local participants = p11.participants

							v66(ChangedParticipants(v184, participants, title, lastUpdated))
						end):catch(function(p12) -- line: 259
							-- upvalues: v17 (copy), v119 (copy)
							v17:warning(`NetworkingChat failure in RobloxEventReceiver->{ v119 }, Status: { tostring(p12) }`)
						end)
					end)

					return
				end

				if v119 == "AddedToConversation" or v119 == "NewConversation" then
					if v61 then
						v17:debug(`Received { v119 } event while loading conversation data`)

						return
					end

					task.spawn(function() -- line: 271
						-- upvalues: v120 (copy), v66 (copy), fetchLatestConversationDetails (copy), v17 (copy), v119 (copy)
						local v169 = v120

						v66(fetchLatestConversationDetails(v169)):catch(function(p13) -- line: 272
							-- upvalues: v17 (copy), v119 (copy)
							v17:warning(`NetworkingChat failure in RobloxEventReceiver->{ v119 }, Status: { tostring(p13) }`)
						end)
					end)

					return
				end

				if v119 == "NewMessage" then
					if FFlagAppChatPerfTracking and v70.activeConversationId and v120 == tostring(v70.activeConversationId) then
						restartMessageReceiveTracking(v120)
					end

					local timestamp = tick()

					v66(getNewMessages(v120, false, timestamp))

					return
				end

				if v119 == "NewMessageBySelf" then
					local timestamp = tick()

					v66(getNewMessages(v120, true, timestamp))

					return
				end

				if v119 == "ParticipantTyping" then
					local str = tostring(p8.UserId)

					v66(ReceivedUserTyping(v120, str))
				end
			end
		end)

		return function() -- line: 296
			-- upvalues: v108 (copy)
			if v108 and v108.disconnect then
				v108:disconnect()
			end
		end
	end, {
		v66,
		v77,
		v70.activeConversationId,
		v70.rnBypassActionSignal,
		v61,
		v59,
		v60
	})
	useEffect(function() -- line: 311
		-- upvalues: v63 (copy), v70 (copy), v17 (copy), RoactNavigation (copy), v59 (copy), FormFactor (copy), EnumScreens (copy)
		if not v63 and (v70.activeConversationId and v70.rnBypassActionSignal) then
			v17:debug("Chat is disabled for our user, navigating away from active conversation")
			v70.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v59 == FormFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, { v63 })

	local v79 = if not v70.activeConversationId then nil else v58[v70.activeConversationId]

	useEffect(function() -- line: 324
		-- upvalues: v64 (copy), v79 (copy), v70 (copy), v17 (copy), RoactNavigation (copy), v59 (copy), FormFactor (copy), EnumScreens (copy)
		if not v64 and (v79 and v70.rnBypassActionSignal and v79.type == "group") then
			v17:debug("Group chats are disabled and we are navigated to a group chat. Navigating to ChatLanding")
			v70.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v59 == FormFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, {
		v64,
		v79
	})
	useEffect(function() -- line: 340
		-- upvalues: robloxEventReceiver (copy), v66 (copy), RoduxAliases (copy)
		local v109 = robloxEventReceiver:observeEvent("UserTagChangeNotification", function(p14, _) -- line: 341
			-- upvalues: v66 (copy), RoduxAliases (copy)
			if p14.Type == "UserTagUpdate" then
				local str = tostring(p14.UserId)
				local NewAlias = p14.NewAlias

				v66(RoduxAliases.Actions.AliasUpdated(str, NewAlias))
			end
		end)

		return function() -- line: 347
			-- upvalues: v109 (copy)
			if v109 and v109.disconnect then
				v109:disconnect()
			end
		end
	end, { v66 })
	useEffect(function() -- line: 354
		-- upvalues: robloxEventReceiver (copy), v17 (copy), v66 (copy), paginateAndRefreshConversations (copy), v62 (copy), FriendshipDestroyed (copy), v79 (copy), Conversation (copy), Cryo (copy), v59 (copy), FormFactor (copy), EnumScreens (copy), v70 (copy), RoactNavigation (copy)
		local v110 = robloxEventReceiver:observeEvent("FriendshipNotifications", function(p16, _) -- line: 355
			-- upvalues: v17 (copy), v66 (copy), paginateAndRefreshConversations (copy), v62 (copy), FriendshipDestroyed (copy), v79 (copy), Conversation (copy), Cryo (copy), v59 (copy), FormFactor (copy), EnumScreens (copy), v70 (copy), RoactNavigation (copy)
			local p16Type = p16.Type

			v17:info("Received friendship notification: {}", p16Type)

			if p16Type == "FriendshipCreated" then
				v66(paginateAndRefreshConversations())

				return
			end

			if p16Type == "FriendshipDestroyed" then
				local u132 = nil

				if p16.EventArgs then
					local str = tostring(p16.EventArgs.UserId1)
					local str2 = tostring(p16.EventArgs.UserId2)

					if str == v62 then
						str = "localUserId"
						u132 = str2
					end

					if str2 == v62 then
						str2 = "localUserId"
						u132 = str
					end

					v66(FriendshipDestroyed({
						userId1 = str,
						userId2 = str2
					}))
				end

				if v79 and v79.source == "friends" and v79.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION and Cryo.List.findWhere(v79.participants, function(p18) -- line: 387
					-- upvalues: u132 (ref)
					return p18 == u132
				end) then
					local v135 = if v59 ~= FormFactor.WIDE then EnumScreens.ChatLanding else EnumScreens.EmptyConversation

					v70.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v135
					}))
				end
			end
		end)

		return function() -- line: 401
			-- upvalues: v110 (copy)
			if v110 and v110.disconnect then
				v110:disconnect()
			end
		end
	end, {
		v66,
		v69,
		v62,
		v59,
		v79,
		v70.rnBypassActionSignal
	})
	useEffect(function() -- line: 415
		-- upvalues: robloxEventReceiver (copy), v17 (copy), v66 (copy), RemovedConversation (copy), fetchLatestConversationDetails (copy), v70 (copy), RoactNavigation (copy), EnumScreens (copy)
		local v111 = robloxEventReceiver:observeEvent("ChatMigration", function(p19, _) -- line: 418
			-- upvalues: v17 (copy), v66 (copy), RemovedConversation (copy), fetchLatestConversationDetails (copy), v70 (copy), RoactNavigation (copy), EnumScreens (copy)
			local p19Type = p19.Type

			v17:info("Received chat migration notification: {}", p19Type)

			local ConversationId, ChannelId

			if p19Type == "ConversationBackfilled" then
				ConversationId = p19.ConversationId
				ChannelId = p19.ChannelId
			else
				if p19Type ~= "ConversationReset" then
					v17:warning(`ChatEventReceiver: unknown notification { p19Type }`)

					return
				end

				ConversationId = p19.ChannelId
				ChannelId = p19.ConversationId
			end

			v66(RemovedConversation(ConversationId))
			v66(fetchLatestConversationDetails(ChannelId)):catch(function(p21) -- line: 436
				-- upvalues: v17 (copy), p19Type (copy)
				v17:warning(`NetworkingChat failure in RobloxEventReceiver->{ p19Type }, Status: { tostring(p21) }`)
			end)

			if v70.activeConversationId and ConversationId and ConversationId == tostring(v70.activeConversationId) and v70.rnBypassActionSignal then
				v70.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
					routeName = EnumScreens.ChatConversation,
					params = {
						conversationId = ChannelId
					}
				}))
			end
		end)

		return function() -- line: 458
			-- upvalues: v111 (copy)
			if v111 and v111.disconnect then
				v111:disconnect()
			end
		end
	end, {
		v66,
		v70.activeConversationId,
		v70.rnBypassActionSignal,
		v67
	})

	local v80 = useCallback(function() -- line: 470
		-- upvalues: v57 (copy), v66 (copy), fetchChatMetadata (copy), v17 (copy), paginateAndRefreshConversations (copy), getAllFriendsAsync (copy), getAllUserPresences (copy)
		if v57 then
			v66(fetchChatMetadata()):andThen(function(b1: boolean) -- line: 472
				-- upvalues: v17 (copy), v66 (copy), paginateAndRefreshConversations (copy), getAllFriendsAsync (copy), getAllUserPresences (copy)
				if b1 then
					v17:trace("Chat is enabled for our user, refreshing conversations")
					v66(paginateAndRefreshConversations())
					task.spawn(function() -- line: 477
						-- upvalues: v66 (copy), getAllFriendsAsync (copy)
						v66(getAllFriendsAsync())
					end)
					spawn(function() -- line: 127
						-- upvalues: v66 (copy), getAllUserPresences (copy)
						v66(getAllUserPresences())
					end)

					return
				end

				v17:trace("Chat is disabled for our user, no need to refresh conversations")
			end)
		end
	end, {
		v57,
		v69,
		function() -- line: 123
			-- upvalues: v66 (copy), getAllFriendsAsync (copy)
			v66(getAllFriendsAsync())
		end,
		function() -- line: 126
			-- upvalues: v66 (copy), getAllUserPresences (copy)
			spawn(function() -- line: 127
				-- upvalues: v66 (copy), getAllUserPresences (copy)
				v66(getAllUserPresences())
			end)
		end,
		function() -- line: 116
			-- upvalues: v66 (copy), fetchChatMetadata (copy)
			return v66(fetchChatMetadata())
		end
	})

	useEffect(function() -- line: 488
		-- upvalues: robloxEventReceiver (copy), v17 (copy), v66 (copy), SetConnectionState (copy), v73 (copy), v72 (copy), v57 (copy), v80 (copy)
		local v112 = robloxEventReceiver:observeEvent("signalR", function(p22, _, p24) -- line: 491
			-- upvalues: v17 (copy), v66 (copy), SetConnectionState (copy), v73 (copy), v72 (copy), v57 (copy), v80 (copy)
			v17:info("SignalR connection state transitioned to {}", (tostring(p22)))
			v66(SetConnectionState(p22))
			v73.current = p22

			if p22 == Enum.ConnectionState.Connected and p24 and (v72.current == nil or v72.current.ChatNotifications ~= p24.ChatNotifications or v72.current.CommunicationChannels ~= p24.CommunicationChannels) then
				v17:trace("We missed some messages while we were disconnected. The chat app was previously {}", not v57 and "unloaded" or "loaded")
				v80()
			end
		end)

		return function() -- line: 514
			-- upvalues: v112 (copy)
			if v112 and v112.disconnect then
				v112:disconnect()
			end
		end
	end, {
		v66,
		v73,
		v72,
		v78,
		v57
	})
	useEffect(function() -- line: 521
		-- upvalues: robloxEventReceiver (copy), CommunicationChannelsTypes (copy), v17 (copy), v77 (copy), v66 (copy), RemovedConversation (copy), v70 (copy), v59 (copy), FormFactor (copy), EnumScreens (copy), RoactNavigation (copy), v62 (copy), removedFromConversationToastTitle (copy), fetchLatestConversationDetails (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v61 (copy), ConversationChannels (copy), FriendConversationCreated (copy), FFlagAppChatPerfTracking (copy), restartMessageReceiveTracking (copy), getNewMessages (copy), ReceivedUserTyping (copy)
		local v113 = robloxEventReceiver:observeEvent("CommunicationChannels", function(p25, _) -- line: 524
			-- upvalues: CommunicationChannelsTypes (copy), v17 (copy), v77 (copy), v66 (copy), RemovedConversation (copy), v70 (copy), v59 (copy), FormFactor (copy), EnumScreens (copy), RoactNavigation (copy), v62 (copy), removedFromConversationToastTitle (copy), fetchLatestConversationDetails (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v61 (copy), ConversationChannels (copy), FriendConversationCreated (copy), FFlagAppChatPerfTracking (copy), restartMessageReceiveTracking (copy), getNewMessages (copy), ReceivedUserTyping (copy)
			if p25.ChannelVertical ~= "PlatformChat" then
				return
			end

			if not table.find(CommunicationChannelsTypes.ChannelTypeAllowlist, p25.ChannelType) then
				return
			end

			v17:info("Received channels notification: {}", p25.Type)
			v77("CommunicationChannels", p25.SequenceNumber)

			local ChannelId = p25.ChannelId

			if p25.Type == "ChannelDeleted" or p25.Type == "RemovedFromChannel" or p25.Type == "ChannelArchived" then
				v66(RemovedConversation(ChannelId))

				local activeConversationId = v70.activeConversationId

				if activeConversationId ~= nil and tostring(activeConversationId) == p25.ChannelId and v70.rnBypassActionSignal then
					local v149 = if v59 ~= FormFactor.WIDE then EnumScreens.ChatLanding else EnumScreens.EmptyConversation

					v70.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v149
					}))
				end

				if p25.Actor.Id ~= tostring(v62) then
					v70.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = EnumScreens.RoactChatToast,
						params = {
							toastProps = {
								toastContent = {
									toastTitle = removedFromConversationToastTitle
								}
							}
						}
					}))

					return
				end
			else
				if p25.Type == "ChannelUpdated" or p25.Type == "ParticipantsAdded" or p25.Type == "ParticipantsRemoved" then
					task.spawn(function() -- line: 577
						-- upvalues: ChannelId (copy), v66 (copy), fetchLatestConversationDetails (copy), p25 (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v17 (copy)
						local v172 = ChannelId

						v66(fetchLatestConversationDetails(v172)):andThen(function(p27) -- line: 579
							-- upvalues: p25 (copy), ChannelId (copy), v66 (copy), RenamedGroupConversation (copy), ChangedParticipants (copy)
							local title = p27.title
							local lastUpdated = p27.lastUpdated

							if p25.Type == "ChannelUpdated" then
								local v191 = ChannelId
								local isDefaultTitle = p27.isDefaultTitle

								v66(RenamedGroupConversation(v191, title, isDefaultTitle, lastUpdated))

								return
							end

							local v193 = ChannelId
							local participants = p27.participants

							v66(ChangedParticipants(v193, participants, title, lastUpdated))
						end):catch(function(p28) -- line: 590
							-- upvalues: v17 (copy), p25 (copy)
							v17:warning(`Failure in RobloxEventReceiver->{ p25.Type }, Status: { tostring(p28) }`)
						end)
					end)

					return
				end

				if p25.Type == "AddedToChannel" or p25.Type == "ChannelCreated" or p25.Type == "ChannelMarkedRead" or (p25.Type == "ChannelMetadataUpdated" and ChannelId ~= nil or p25.Type == "ChannelUnarchived") then
					if v61 then
						v17:debug("Received {} event while loading conversation data", p25.Type)

						return
					end

					task.spawn(function() -- line: 608
						-- upvalues: ChannelId (copy), v66 (copy), fetchLatestConversationDetails (copy), p25 (copy), ConversationChannels (copy), FriendConversationCreated (copy), v70 (copy), RoactNavigation (copy), EnumScreens (copy), v17 (copy)
						local v173 = ChannelId

						v66(fetchLatestConversationDetails(v173)):andThen(function(p29) -- line: 610
							-- upvalues: p25 (copy), ConversationChannels (copy), v66 (copy), FriendConversationCreated (copy), v70 (copy), RoactNavigation (copy), EnumScreens (copy)
							if (p25.Type == "ChannelCreated" or p25.Type == "ChannelUnarchived") and p29.type == "one_to_one" then
								local v197 = ConversationChannels.getFriendConversationId(p29.participants)

								if v197 then
									v66(FriendConversationCreated({
										newConversationId = p29.id,
										oldFriendConversationId = v197
									}))

									if v197 == v70.activeConversationId then
										v70.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
											routeName = EnumScreens.ChatConversation,
											params = {
												conversationId = p29.id
											}
										}))
									end
								end
							end
						end):catch(function(p30) -- line: 634
							-- upvalues: v17 (copy), p25 (copy)
							v17:warning("Failure in RobloxEventReceiver->{}, Status: {}", p25.Type, (tostring(p30)))
						end)
					end)

					return
				end

				if p25.Type == "MessageCreated" or p25.Type == "SystemMessageCreated" then
					if FFlagAppChatPerfTracking then
						local v150 = p25.Actor.Id == tostring(v62)

						if not v150 and v70.activeConversationId and ChannelId == tostring(v70.activeConversationId) then
							restartMessageReceiveTracking(ChannelId)
						end

						local timestamp = tick()

						v66(getNewMessages(ChannelId, v150, timestamp))

						return
					end

					local v152 = p25.Actor.Id == tostring(v62)
					local timestamp = tick()

					v66(getNewMessages(ChannelId, v152, timestamp))

					return
				end

				if p25.Type == "ParticipantTyping" and p25.IsTyping then
					local ActorId = p25.Actor.Id

					v66(ReceivedUserTyping(ChannelId, ActorId))
				end
			end
		end)

		return function() -- line: 663
			-- upvalues: v113 (copy)
			if v113 and v113.disconnect then
				v113:disconnect()
			end
		end
	end, {
		v62,
		robloxEventReceiver,
		v77,
		function(p31) -- line: 159
			-- upvalues: v66 (copy), RemovedConversation (copy)
			v66(RemovedConversation(p31))
		end,
		v70.activeConversationId,
		v70.rnBypassActionSignal,
		removedFromConversationToastTitle,
		v67,
		function(p32, p33, p34, p35) -- line: 162
			-- upvalues: v66 (copy), RenamedGroupConversation (copy)
			v66(RenamedGroupConversation(p32, p33, p34, p35))
		end,
		function(p36, p37, p38, p39) -- line: 113
			-- upvalues: v66 (copy), ChangedParticipants (copy)
			v66(ChangedParticipants(p36, p37, p38, p39))
		end,
		v61,
		function(p40, p41, p42) -- line: 131
			-- upvalues: v66 (copy), getNewMessages (copy)
			return v66(getNewMessages(p40, p41, p42))
		end,
		function(p43, p44) -- line: 151
			-- upvalues: v66 (copy), ReceivedUserTyping (copy)
			v66(ReceivedUserTyping(p43, p44))
		end,
		v80
	})

	local v81 = useMemo(function() -- line: 685
		-- upvalues: v58 (copy), Cryo (copy)
		if not v58 then
			return {}
		end

		return (Cryo.List.filterMap(Cryo.Dictionary.values(v58), function(p45) -- line: 690
			if p45 and (p45.id and p45.source ~= "friends") then
				return p45.id
			end

			return nil
		end))
	end, { v58 })

	useEffect(function() -- line: 700
		-- upvalues: robloxEventReceiver (copy), v17 (copy), getFFlagDebugUnfilteredThreads (copy), chunkAndLogString (copy), Cryo (copy), v81 (copy), v66 (copy), multiGetConversationDetails (copy), v70 (copy), AppChatNetworking (copy), FFlagAppChatEnableDoubleOptIn (copy), refreshConversationUnfilteredThreadsDetails (copy), v65 (copy)
		local v114 = robloxEventReceiver:observeEvent("ChatModerationTypeEligibility", function(p46, _) -- line: 703
			-- upvalues: v17 (copy), getFFlagDebugUnfilteredThreads (copy), chunkAndLogString (copy), Cryo (copy), v81 (copy), v66 (copy), multiGetConversationDetails (copy), v70 (copy), AppChatNetworking (copy), FFlagAppChatEnableDoubleOptIn (copy), refreshConversationUnfilteredThreadsDetails (copy), v65 (copy)
			v17:debug("Received ChatModerationTypeEligibility notification")

			local channels_inspected = p46.channels_inspected

			if not channels_inspected or #channels_inspected == 0 then
				return
			end

			if getFFlagDebugUnfilteredThreads() then
				local s3 = ""

				for _, v161 in channels_inspected do
					s3 = `{ s3 }, { v161 }`
				end

				chunkAndLogString(`RTN CONVERSATIONS INSPECTED{ s3 }`)
			end

			local v162 = Cryo.List.filter(channels_inspected, function(p48) -- line: 717
				-- upvalues: v81 (copy)
				return table.find(v81, p48)
			end)

			if #v162 == 0 then
				v17:debug("No filtered existing conversation IDs found in ChatModerationTypeEligibility notification")

				return
			end

			if getFFlagDebugUnfilteredThreads() then
				local s4 = ""

				for _, v165 in v162 do
					s4 = `{ s4 }, { v165 }`
				end

				chunkAndLogString(`RTN FILTERED CONVERSATIONS{ s4 }`)
			end

			v66(multiGetConversationDetails(v162)):catch(function(p49) -- line: 733
				-- upvalues: v17 (copy)
				v17:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->MultiGetConversationDetails, Status: " .. tostring(p49))
			end)

			if not v70.activeConversationId then
				return
			end

			if table.find(channels_inspected, v70.activeConversationId) then
				v66(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ v70.activeConversationId })):catch(function(p50) -- line: 747
					-- upvalues: v17 (copy)
					v17:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->GetConversationsParticipantsMetadata, Status: " .. tostring(p50))
				end)

				if FFlagAppChatEnableDoubleOptIn then
					v66(refreshConversationUnfilteredThreadsDetails(v70.activeConversationId, v65))

					return
				end

				v66(AppChatNetworking.rodux.GetConversationTopModal.API(v70.activeConversationId, v65)):catch(function(p51) -- line: 764
					-- upvalues: v17 (copy)
					v17:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->GetConversationTopModal, Status: " .. tostring(p51))
				end)
			end
		end)

		return function() -- line: 776
			-- upvalues: v114 (copy)
			if v114 and v114.disconnect then
				v114:disconnect()
			end
		end
	end, {
		v66,
		v70.activeConversationId,
		v81
	})
	useEffect(function() -- line: 783
		-- upvalues: robloxEventReceiver (copy), v17 (copy), v66 (copy), AppChatNetworking (copy), v65 (copy)
		local v115 = robloxEventReceiver:observeEvent("EligibilityStatusChanged", function(_, _) -- line: 786
			-- upvalues: v17 (copy), v66 (copy), AppChatNetworking (copy), v65 (copy)
			v17:info("Received EligibilityStatusChanged notification")
			v66(AppChatNetworking.rodux.GetChatLandingModal.API(v65)):catch(function(p54) -- line: 789
				-- upvalues: v17 (copy)
				v17:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p54)))
			end)
		end)

		return function() -- line: 795
			-- upvalues: v115 (copy)
			if v115 and v115.disconnect then
				v115:disconnect()
			end
		end
	end, { v66 })
	useChatTrustedConnectionsEvents({
		activeConversationId = v70.activeConversationId
	})

	return {}
end

return ChatEventReceiver
