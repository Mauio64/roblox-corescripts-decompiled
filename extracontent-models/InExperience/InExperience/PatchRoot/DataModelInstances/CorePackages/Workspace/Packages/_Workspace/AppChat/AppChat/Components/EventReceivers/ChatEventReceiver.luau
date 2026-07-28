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
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

local function chunkAndLogString(p1) -- line: 62
	-- upvalues: v17 (copy)
	local t1 = {}

	for i = 1, #p1, 800 do
		table.insert(t1, p1:sub(i, i + 800 - 1))
	end

	for _, v56 in t1 do
		v17:debug(v56)
	end
end

local t2 = {
	handlesAppShellNotifications = true
}

function ChatEventReceiver(t3: {[any]: any}) -- line: 85
	-- upvalues: useEffect (copy), v17 (copy), useSelector (copy), useCallback (copy), Cryo (copy), useLocalUserId (copy), useIsChatEnabled (copy), useIsGroupChatEnabled (copy), useIsInExperience (copy), useDispatch (copy), ChangedParticipants (copy), fetchChatMetadata (copy), fetchLatestConversationDetails (copy), getAllFriendsAsync (copy), FFlagAppChatPresenceStoreMigration (copy), getAllUserPresences (copy), getNewMessages (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), RoduxAliases (copy), ReceivedUserTyping (copy), paginateAndRefreshConversations (copy), RemovedConversation (copy), RenamedGroupConversation (copy), SetConnectionState (copy), t2 (copy), useRef (copy), useLocalization (copy), RoactNavigation (copy), EnumScreens (copy), FormFactor (copy), FriendshipDestroyed (copy), Conversation (copy), CommunicationChannelsTypes (copy), ConversationChannels (copy), FriendConversationCreated (copy), useMemo (copy), getFFlagDebugUnfilteredThreads (copy), chunkAndLogString (copy), multiGetConversationDetails (copy), AppChatNetworking (copy), FFlagAppChatEnableDoubleOptIn (copy), refreshConversationUnfilteredThreadsDetails (copy), useChatTrustedConnectionsEvents (copy)
	useEffect(function() -- line: 86
		-- upvalues: v17 (copy)
		v17:info("ChatEventReceiver mounted")

		return function() -- line: 88
			-- upvalues: v17 (copy)
			v17:info("ChatEventReceiver unmounted")
		end
	end, {})

	local v58 = useSelector(useCallback(function(p2) -- line: 94
		return p2.ChatAppReducer.AppLoaded
	end, {}))
	local v59 = useSelector(useCallback(function(p3) -- line: 97
		return p3.ChatAppReducer.Conversations
	end, {}))
	local v60 = useSelector(useCallback(function(p4) -- line: 100
		return p4.FormFactor
	end, {}))
	local v61 = useSelector(useCallback(function(p5) -- line: 103
		return p5.Users
	end, {}))
	local v62 = Cryo.isEmpty(v59)
	local v63 = useLocalUserId()
	local v64 = useIsChatEnabled()
	local v65 = useIsGroupChatEnabled()
	local v66 = useIsInExperience()
	local v67 = useDispatch()

	local function v68(p6) -- line: 121
		-- upvalues: v67 (copy), fetchLatestConversationDetails (copy)
		return v67(fetchLatestConversationDetails(p6))
	end

	local v69 = if FFlagAppChatPresenceStoreMigration then nil else function() -- line: 128
		-- upvalues: v67 (copy), getAllUserPresences (copy)
		spawn(function() -- line: 129
			-- upvalues: v67 (copy), getAllUserPresences (copy)
			v67(getAllUserPresences())
		end)
	end

	local function restartMessageReceiveTracking(s1: string) -- line: 138
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
	local function v71() -- line: 158
		-- upvalues: v67 (copy), paginateAndRefreshConversations (copy)
		v67(paginateAndRefreshConversations())
	end

	local v72 = Cryo.Dictionary.join(t2, t3)
	local robloxEventReceiver = v72.robloxEventReceiver
	local v74 = useRef({})
	local v75 = useRef(Enum.ConnectionState.Connected)
	local v76 = useLocalization({
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		removedFromConversationToastTitle = "Feature.Chat.Message.RemovedFromConversation"
	})
	local networkErrorText = v76.networkErrorText
	local removedFromConversationToastTitle = v76.removedFromConversationToastTitle
	local v79 = useCallback(function(s2: string, p7) -- line: 185
		-- upvalues: v74 (copy)
		assert(v74.current, "table")
		v74.current[s2] = p7
	end, { v74.current })
	local v80 = useCallback(function() -- line: 190
		-- upvalues: v72 (copy), RoactNavigation (copy), EnumScreens (copy), networkErrorText (copy)
		if v72.rnBypassActionSignal then
			v72.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
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
		v72.rnBypassActionSignal,
		networkErrorText
	})

	useEffect(function() -- line: 205
		-- upvalues: robloxEventReceiver (copy), v79 (copy), v17 (copy), v67 (copy), RemovedConversation (copy), v72 (copy), RoactNavigation (copy), v60 (copy), FormFactor (copy), EnumScreens (copy), removedFromConversationToastTitle (copy), fetchLatestConversationDetails (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v62 (copy), FFlagAppChatPerfTracking (copy), restartMessageReceiveTracking (copy), getNewMessages (copy), ReceivedUserTyping (copy)
		local v110 = robloxEventReceiver:observeEvent("ChatNotifications", function(p8, p9, _) -- line: 206
			-- upvalues: v79 (copy), v17 (copy), v67 (copy), RemovedConversation (copy), v72 (copy), RoactNavigation (copy), v60 (copy), FormFactor (copy), EnumScreens (copy), removedFromConversationToastTitle (copy), fetchLatestConversationDetails (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v62 (copy), FFlagAppChatPerfTracking (copy), restartMessageReceiveTracking (copy), getNewMessages (copy), ReceivedUserTyping (copy)
			v79("ChatNotifications", p8.SequenceNumber)

			local v121 = p8.Type or p9

			v17:info("Received chat notification: {}", v121)

			local v122 = p8.ConversationId and tostring(p8.ConversationId) or ""

			if v121 == "RemovedFromConversation" or v121 == "ConversationRemoved" then
				v67(RemovedConversation(v122))

				local activeConversationId = v72.activeConversationId

				if activeConversationId ~= nil and v122 == tostring(activeConversationId) and v72.rnBypassActionSignal then
					v72.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v60 == FormFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
					}))
				end

				if v121 == "RemovedFromConversation" then
					v72.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
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
				if v121 == "ConversationTitleChanged" or v121 == "ParticipantAdded" or v121 == "ParticipantLeft" then
					task.spawn(function() -- line: 244
						-- upvalues: v122 (copy), v67 (copy), fetchLatestConversationDetails (copy), v121 (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v17 (copy)
						local v170 = v122

						v67(fetchLatestConversationDetails(v170)):andThen(function(p11) -- line: 246
							-- upvalues: v121 (copy), v122 (copy), v67 (copy), RenamedGroupConversation (copy), ChangedParticipants (copy)
							local title = p11.title
							local lastUpdated = p11.lastUpdated

							if v121 == "ConversationTitleChanged" then
								local v184 = v122
								local isDefaultTitle = p11.isDefaultTitle

								v67(RenamedGroupConversation(v184, title, isDefaultTitle, lastUpdated))

								return
							end

							local v186 = v122
							local participants = p11.participants

							v67(ChangedParticipants(v186, participants, title, lastUpdated))
						end):catch(function(p12) -- line: 262
							-- upvalues: v17 (copy), v121 (copy)
							v17:warning(`NetworkingChat failure in RobloxEventReceiver->{ v121 }, Status: { tostring(p12) }`)
						end)
					end)

					return
				end

				if v121 == "AddedToConversation" or v121 == "NewConversation" then
					if v62 then
						v17:debug(`Received { v121 } event while loading conversation data`)

						return
					end

					task.spawn(function() -- line: 274
						-- upvalues: v122 (copy), v67 (copy), fetchLatestConversationDetails (copy), v17 (copy), v121 (copy)
						local v171 = v122

						v67(fetchLatestConversationDetails(v171)):catch(function(p13) -- line: 275
							-- upvalues: v17 (copy), v121 (copy)
							v17:warning(`NetworkingChat failure in RobloxEventReceiver->{ v121 }, Status: { tostring(p13) }`)
						end)
					end)

					return
				end

				if v121 == "NewMessage" then
					if FFlagAppChatPerfTracking and v72.activeConversationId and v122 == tostring(v72.activeConversationId) then
						restartMessageReceiveTracking(v122)
					end

					local timestamp = tick()

					v67(getNewMessages(v122, false, timestamp))

					return
				end

				if v121 == "NewMessageBySelf" then
					local timestamp = tick()

					v67(getNewMessages(v122, true, timestamp))

					return
				end

				if v121 == "ParticipantTyping" then
					local str = tostring(p8.UserId)

					v67(ReceivedUserTyping(v122, str))
				end
			end
		end)

		return function() -- line: 299
			-- upvalues: v110 (copy)
			if v110 and v110.disconnect then
				v110:disconnect()
			end
		end
	end, {
		v67,
		v79,
		v72.activeConversationId,
		v72.rnBypassActionSignal,
		v62,
		v60,
		v61
	})
	useEffect(function() -- line: 314
		-- upvalues: v64 (copy), v72 (copy), v17 (copy), RoactNavigation (copy), v60 (copy), FormFactor (copy), EnumScreens (copy)
		if not v64 and (v72.activeConversationId and v72.rnBypassActionSignal) then
			v17:debug("Chat is disabled for our user, navigating away from active conversation")
			v72.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v60 == FormFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, { v64 })

	local v81 = if not v72.activeConversationId then nil else v59[v72.activeConversationId]

	useEffect(function() -- line: 327
		-- upvalues: v65 (copy), v81 (copy), v72 (copy), v17 (copy), RoactNavigation (copy), v60 (copy), FormFactor (copy), EnumScreens (copy)
		if not v65 and (v81 and v72.rnBypassActionSignal and v81.type == "group") then
			v17:debug("Group chats are disabled and we are navigated to a group chat. Navigating to ChatLanding")
			v72.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v60 == FormFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, {
		v65,
		v81
	})
	useEffect(function() -- line: 343
		-- upvalues: robloxEventReceiver (copy), v67 (copy), RoduxAliases (copy)
		local v111 = robloxEventReceiver:observeEvent("UserTagChangeNotification", function(p14, _) -- line: 344
			-- upvalues: v67 (copy), RoduxAliases (copy)
			if p14.Type == "UserTagUpdate" then
				local str = tostring(p14.UserId)
				local NewAlias = p14.NewAlias

				v67(RoduxAliases.Actions.AliasUpdated(str, NewAlias))
			end
		end)

		return function() -- line: 350
			-- upvalues: v111 (copy)
			if v111 and v111.disconnect then
				v111:disconnect()
			end
		end
	end, { v67 })
	useEffect(function() -- line: 357
		-- upvalues: robloxEventReceiver (copy), v17 (copy), v67 (copy), paginateAndRefreshConversations (copy), v63 (copy), FriendshipDestroyed (copy), v81 (copy), Conversation (copy), Cryo (copy), v60 (copy), FormFactor (copy), EnumScreens (copy), v72 (copy), RoactNavigation (copy)
		local v112 = robloxEventReceiver:observeEvent("FriendshipNotifications", function(p16, _) -- line: 358
			-- upvalues: v17 (copy), v67 (copy), paginateAndRefreshConversations (copy), v63 (copy), FriendshipDestroyed (copy), v81 (copy), Conversation (copy), Cryo (copy), v60 (copy), FormFactor (copy), EnumScreens (copy), v72 (copy), RoactNavigation (copy)
			local p16Type = p16.Type

			v17:info("Received friendship notification: {}", p16Type)

			if p16Type == "FriendshipCreated" then
				v67(paginateAndRefreshConversations())

				return
			end

			if p16Type == "FriendshipDestroyed" then
				local u134 = nil

				if p16.EventArgs then
					local str = tostring(p16.EventArgs.UserId1)
					local str2 = tostring(p16.EventArgs.UserId2)

					if str == v63 then
						str = "localUserId"
						u134 = str2
					end

					if str2 == v63 then
						str2 = "localUserId"
						u134 = str
					end

					v67(FriendshipDestroyed({
						userId1 = str,
						userId2 = str2
					}))
				end

				if v81 and v81.source == "friends" and v81.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION and Cryo.List.findWhere(v81.participants, function(p18) -- line: 390
					-- upvalues: u134 (ref)
					return p18 == u134
				end) then
					local v137 = if v60 ~= FormFactor.WIDE then EnumScreens.ChatLanding else EnumScreens.EmptyConversation

					v72.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v137
					}))
				end
			end
		end)

		return function() -- line: 404
			-- upvalues: v112 (copy)
			if v112 and v112.disconnect then
				v112:disconnect()
			end
		end
	end, {
		v67,
		v71,
		v63,
		v60,
		v81,
		v72.rnBypassActionSignal
	})
	useEffect(function() -- line: 418
		-- upvalues: robloxEventReceiver (copy), v17 (copy), v67 (copy), RemovedConversation (copy), fetchLatestConversationDetails (copy), v72 (copy), RoactNavigation (copy), EnumScreens (copy)
		local v113 = robloxEventReceiver:observeEvent("ChatMigration", function(p19, _) -- line: 421
			-- upvalues: v17 (copy), v67 (copy), RemovedConversation (copy), fetchLatestConversationDetails (copy), v72 (copy), RoactNavigation (copy), EnumScreens (copy)
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

			v67(RemovedConversation(ConversationId))
			v67(fetchLatestConversationDetails(ChannelId)):catch(function(p21) -- line: 439
				-- upvalues: v17 (copy), p19Type (copy)
				v17:warning(`NetworkingChat failure in RobloxEventReceiver->{ p19Type }, Status: { tostring(p21) }`)
			end)

			if v72.activeConversationId and ConversationId and ConversationId == tostring(v72.activeConversationId) and v72.rnBypassActionSignal then
				v72.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
					routeName = EnumScreens.ChatConversation,
					params = {
						conversationId = ChannelId
					}
				}))
			end
		end)

		return function() -- line: 461
			-- upvalues: v113 (copy)
			if v113 and v113.disconnect then
				v113:disconnect()
			end
		end
	end, {
		v67,
		v72.activeConversationId,
		v72.rnBypassActionSignal,
		v68
	})

	local v82 = useCallback(function() -- line: 473
		-- upvalues: v58 (copy), v67 (copy), fetchChatMetadata (copy), v17 (copy), paginateAndRefreshConversations (copy), getAllFriendsAsync (copy), FFlagAppChatPresenceStoreMigration (copy), v69 (copy)
		if v58 then
			v67(fetchChatMetadata()):andThen(function(b1: boolean) -- line: 475
				-- upvalues: v17 (copy), v67 (copy), paginateAndRefreshConversations (copy), getAllFriendsAsync (copy), FFlagAppChatPresenceStoreMigration (copy), v69 (copy)
				if b1 then
					v17:trace("Chat is enabled for our user, refreshing conversations")
					v67(paginateAndRefreshConversations())
					task.spawn(function() -- line: 480
						-- upvalues: v67 (copy), getAllFriendsAsync (copy)
						v67(getAllFriendsAsync())
					end)

					if not FFlagAppChatPresenceStoreMigration then
						v69()

						return
					end
				else
					v17:trace("Chat is disabled for our user, no need to refresh conversations")
				end
			end)
		end
	end, {
		v58,
		v71,
		function() -- line: 124
			-- upvalues: v67 (copy), getAllFriendsAsync (copy)
			v67(getAllFriendsAsync())
		end,
		v69,
		function() -- line: 117
			-- upvalues: v67 (copy), fetchChatMetadata (copy)
			return v67(fetchChatMetadata())
		end
	})

	useEffect(function() -- line: 493
		-- upvalues: robloxEventReceiver (copy), v17 (copy), v67 (copy), SetConnectionState (copy), v75 (copy), v74 (copy), v58 (copy), v82 (copy)
		local v114 = robloxEventReceiver:observeEvent("signalR", function(p22, _, p24) -- line: 496
			-- upvalues: v17 (copy), v67 (copy), SetConnectionState (copy), v75 (copy), v74 (copy), v58 (copy), v82 (copy)
			v17:info("SignalR connection state transitioned to {}", (tostring(p22)))
			v67(SetConnectionState(p22))
			v75.current = p22

			if p22 == Enum.ConnectionState.Connected and p24 and (v74.current == nil or v74.current.ChatNotifications ~= p24.ChatNotifications or v74.current.CommunicationChannels ~= p24.CommunicationChannels) then
				v17:trace("We missed some messages while we were disconnected. The chat app was previously {}", not v58 and "unloaded" or "loaded")
				v82()
			end
		end)

		return function() -- line: 519
			-- upvalues: v114 (copy)
			if v114 and v114.disconnect then
				v114:disconnect()
			end
		end
	end, {
		v67,
		v75,
		v74,
		v80,
		v58
	})
	useEffect(function() -- line: 526
		-- upvalues: robloxEventReceiver (copy), CommunicationChannelsTypes (copy), v17 (copy), v79 (copy), v67 (copy), RemovedConversation (copy), v72 (copy), v60 (copy), FormFactor (copy), EnumScreens (copy), RoactNavigation (copy), v63 (copy), removedFromConversationToastTitle (copy), fetchLatestConversationDetails (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v62 (copy), ConversationChannels (copy), FriendConversationCreated (copy), FFlagAppChatPerfTracking (copy), restartMessageReceiveTracking (copy), getNewMessages (copy), ReceivedUserTyping (copy)
		local v115 = robloxEventReceiver:observeEvent("CommunicationChannels", function(p25, _) -- line: 529
			-- upvalues: CommunicationChannelsTypes (copy), v17 (copy), v79 (copy), v67 (copy), RemovedConversation (copy), v72 (copy), v60 (copy), FormFactor (copy), EnumScreens (copy), RoactNavigation (copy), v63 (copy), removedFromConversationToastTitle (copy), fetchLatestConversationDetails (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v62 (copy), ConversationChannels (copy), FriendConversationCreated (copy), FFlagAppChatPerfTracking (copy), restartMessageReceiveTracking (copy), getNewMessages (copy), ReceivedUserTyping (copy)
			if p25.ChannelVertical ~= "PlatformChat" then
				return
			end

			if not table.find(CommunicationChannelsTypes.ChannelTypeAllowlist, p25.ChannelType) then
				return
			end

			v17:info("Received channels notification: {}", p25.Type)
			v79("CommunicationChannels", p25.SequenceNumber)

			local ChannelId = p25.ChannelId

			if p25.Type == "ChannelDeleted" or p25.Type == "RemovedFromChannel" or p25.Type == "ChannelArchived" then
				v67(RemovedConversation(ChannelId))

				local activeConversationId = v72.activeConversationId

				if activeConversationId ~= nil and tostring(activeConversationId) == p25.ChannelId and v72.rnBypassActionSignal then
					local v151 = if v60 ~= FormFactor.WIDE then EnumScreens.ChatLanding else EnumScreens.EmptyConversation

					v72.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v151
					}))
				end

				if p25.Actor.Id ~= tostring(v63) then
					v72.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
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
					task.spawn(function() -- line: 582
						-- upvalues: ChannelId (copy), v67 (copy), fetchLatestConversationDetails (copy), p25 (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v17 (copy)
						local v174 = ChannelId

						v67(fetchLatestConversationDetails(v174)):andThen(function(p27) -- line: 584
							-- upvalues: p25 (copy), ChannelId (copy), v67 (copy), RenamedGroupConversation (copy), ChangedParticipants (copy)
							local title = p27.title
							local lastUpdated = p27.lastUpdated

							if p25.Type == "ChannelUpdated" then
								local v193 = ChannelId
								local isDefaultTitle = p27.isDefaultTitle

								v67(RenamedGroupConversation(v193, title, isDefaultTitle, lastUpdated))

								return
							end

							local v195 = ChannelId
							local participants = p27.participants

							v67(ChangedParticipants(v195, participants, title, lastUpdated))
						end):catch(function(p28) -- line: 595
							-- upvalues: v17 (copy), p25 (copy)
							v17:warning(`Failure in RobloxEventReceiver->{ p25.Type }, Status: { tostring(p28) }`)
						end)
					end)

					return
				end

				if p25.Type == "AddedToChannel" or p25.Type == "ChannelCreated" or p25.Type == "ChannelMarkedRead" or (p25.Type == "ChannelMetadataUpdated" and ChannelId ~= nil or p25.Type == "ChannelUnarchived") then
					if v62 then
						v17:debug("Received {} event while loading conversation data", p25.Type)

						return
					end

					task.spawn(function() -- line: 613
						-- upvalues: ChannelId (copy), v67 (copy), fetchLatestConversationDetails (copy), p25 (copy), ConversationChannels (copy), FriendConversationCreated (copy), v72 (copy), RoactNavigation (copy), EnumScreens (copy), v17 (copy)
						local v175 = ChannelId

						v67(fetchLatestConversationDetails(v175)):andThen(function(p29) -- line: 615
							-- upvalues: p25 (copy), ConversationChannels (copy), v67 (copy), FriendConversationCreated (copy), v72 (copy), RoactNavigation (copy), EnumScreens (copy)
							if (p25.Type == "ChannelCreated" or p25.Type == "ChannelUnarchived") and p29.type == "one_to_one" then
								local v199 = ConversationChannels.getFriendConversationId(p29.participants)

								if v199 then
									v67(FriendConversationCreated({
										newConversationId = p29.id,
										oldFriendConversationId = v199
									}))

									if v199 == v72.activeConversationId then
										v72.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
											routeName = EnumScreens.ChatConversation,
											params = {
												conversationId = p29.id
											}
										}))
									end
								end
							end
						end):catch(function(p30) -- line: 639
							-- upvalues: v17 (copy), p25 (copy)
							v17:warning("Failure in RobloxEventReceiver->{}, Status: {}", p25.Type, (tostring(p30)))
						end)
					end)

					return
				end

				if p25.Type == "MessageCreated" or p25.Type == "SystemMessageCreated" then
					if FFlagAppChatPerfTracking then
						local v152 = p25.Actor.Id == tostring(v63)

						if not v152 and v72.activeConversationId and ChannelId == tostring(v72.activeConversationId) then
							restartMessageReceiveTracking(ChannelId)
						end

						local timestamp = tick()

						v67(getNewMessages(ChannelId, v152, timestamp))

						return
					end

					local v154 = p25.Actor.Id == tostring(v63)
					local timestamp = tick()

					v67(getNewMessages(ChannelId, v154, timestamp))

					return
				end

				if p25.Type == "ParticipantTyping" and p25.IsTyping then
					local ActorId = p25.Actor.Id

					v67(ReceivedUserTyping(ChannelId, ActorId))
				end
			end
		end)

		return function() -- line: 668
			-- upvalues: v115 (copy)
			if v115 and v115.disconnect then
				v115:disconnect()
			end
		end
	end, {
		v63,
		robloxEventReceiver,
		v79,
		function(p31) -- line: 162
			-- upvalues: v67 (copy), RemovedConversation (copy)
			v67(RemovedConversation(p31))
		end,
		v72.activeConversationId,
		v72.rnBypassActionSignal,
		removedFromConversationToastTitle,
		v68,
		function(p32, p33, p34, p35) -- line: 165
			-- upvalues: v67 (copy), RenamedGroupConversation (copy)
			v67(RenamedGroupConversation(p32, p33, p34, p35))
		end,
		function(p36, p37, p38, p39) -- line: 114
			-- upvalues: v67 (copy), ChangedParticipants (copy)
			v67(ChangedParticipants(p36, p37, p38, p39))
		end,
		v62,
		function(p40, p41, p42) -- line: 134
			-- upvalues: v67 (copy), getNewMessages (copy)
			return v67(getNewMessages(p40, p41, p42))
		end,
		function(p43, p44) -- line: 154
			-- upvalues: v67 (copy), ReceivedUserTyping (copy)
			v67(ReceivedUserTyping(p43, p44))
		end,
		v82
	})

	local v83 = useMemo(function() -- line: 690
		-- upvalues: v59 (copy), Cryo (copy)
		if not v59 then
			return {}
		end

		return (Cryo.List.filterMap(Cryo.Dictionary.values(v59), function(p45) -- line: 695
			if p45 and (p45.id and p45.source ~= "friends") then
				return p45.id
			end

			return nil
		end))
	end, { v59 })

	useEffect(function() -- line: 705
		-- upvalues: robloxEventReceiver (copy), v17 (copy), getFFlagDebugUnfilteredThreads (copy), chunkAndLogString (copy), Cryo (copy), v83 (copy), v67 (copy), multiGetConversationDetails (copy), v72 (copy), AppChatNetworking (copy), FFlagAppChatEnableDoubleOptIn (copy), refreshConversationUnfilteredThreadsDetails (copy), v66 (copy)
		local v116 = robloxEventReceiver:observeEvent("ChatModerationTypeEligibility", function(p46, _) -- line: 708
			-- upvalues: v17 (copy), getFFlagDebugUnfilteredThreads (copy), chunkAndLogString (copy), Cryo (copy), v83 (copy), v67 (copy), multiGetConversationDetails (copy), v72 (copy), AppChatNetworking (copy), FFlagAppChatEnableDoubleOptIn (copy), refreshConversationUnfilteredThreadsDetails (copy), v66 (copy)
			v17:debug("Received ChatModerationTypeEligibility notification")

			local channels_inspected = p46.channels_inspected

			if not channels_inspected or #channels_inspected == 0 then
				return
			end

			if getFFlagDebugUnfilteredThreads() then
				local s3 = ""

				for _, v163 in channels_inspected do
					s3 = `{ s3 }, { v163 }`
				end

				chunkAndLogString(`RTN CONVERSATIONS INSPECTED{ s3 }`)
			end

			local v164 = Cryo.List.filter(channels_inspected, function(p48) -- line: 722
				-- upvalues: v83 (copy)
				return table.find(v83, p48)
			end)

			if #v164 == 0 then
				v17:debug("No filtered existing conversation IDs found in ChatModerationTypeEligibility notification")

				return
			end

			if getFFlagDebugUnfilteredThreads() then
				local s4 = ""

				for _, v167 in v164 do
					s4 = `{ s4 }, { v167 }`
				end

				chunkAndLogString(`RTN FILTERED CONVERSATIONS{ s4 }`)
			end

			v67(multiGetConversationDetails(v164)):catch(function(p49) -- line: 738
				-- upvalues: v17 (copy)
				v17:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->MultiGetConversationDetails, Status: " .. tostring(p49))
			end)

			if not v72.activeConversationId then
				return
			end

			if table.find(channels_inspected, v72.activeConversationId) then
				v67(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ v72.activeConversationId })):catch(function(p50) -- line: 752
					-- upvalues: v17 (copy)
					v17:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->GetConversationsParticipantsMetadata, Status: " .. tostring(p50))
				end)

				if FFlagAppChatEnableDoubleOptIn then
					v67(refreshConversationUnfilteredThreadsDetails(v72.activeConversationId, v66))

					return
				end

				v67(AppChatNetworking.rodux.GetConversationTopModal.API(v72.activeConversationId, v66)):catch(function(p51) -- line: 769
					-- upvalues: v17 (copy)
					v17:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->GetConversationTopModal, Status: " .. tostring(p51))
				end)
			end
		end)

		return function() -- line: 781
			-- upvalues: v116 (copy)
			if v116 and v116.disconnect then
				v116:disconnect()
			end
		end
	end, {
		v67,
		v72.activeConversationId,
		v83
	})
	useEffect(function() -- line: 788
		-- upvalues: robloxEventReceiver (copy), v17 (copy), v67 (copy), AppChatNetworking (copy), v66 (copy)
		local v117 = robloxEventReceiver:observeEvent("EligibilityStatusChanged", function(_, _) -- line: 791
			-- upvalues: v17 (copy), v67 (copy), AppChatNetworking (copy), v66 (copy)
			v17:info("Received EligibilityStatusChanged notification")
			v67(AppChatNetworking.rodux.GetChatLandingModal.API(v66)):catch(function(p54) -- line: 794
				-- upvalues: v17 (copy)
				v17:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p54)))
			end)
		end)

		return function() -- line: 800
			-- upvalues: v117 (copy)
			if v117 and v117.disconnect then
				v117:disconnect()
			end
		end
	end, { v67 })
	useChatTrustedConnectionsEvents({
		activeConversationId = v72.activeConversationId
	})

	return {}
end

return ChatEventReceiver
