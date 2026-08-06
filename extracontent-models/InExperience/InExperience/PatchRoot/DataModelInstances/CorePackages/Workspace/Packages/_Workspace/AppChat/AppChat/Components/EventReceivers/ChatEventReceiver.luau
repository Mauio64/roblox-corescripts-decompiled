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
local FFlagRemoveUnusedConnectionStateRoduxSlice = require(AppChatParent.SharedFlags).FFlagRemoveUnusedConnectionStateRoduxSlice
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

local function chunkAndLogString(p1) -- line: 64
	-- upvalues: v17 (copy)
	local t1 = {}

	for i = 1, #p1, 800 do
		table.insert(t1, p1:sub(i, i + 800 - 1))
	end

	for _, v57 in t1 do
		v17:debug(v57)
	end
end

local t2 = {
	handlesAppShellNotifications = true
}

function ChatEventReceiver(t3: {[any]: any}) -- line: 87
	-- upvalues: useEffect (copy), v17 (copy), useSelector (copy), useCallback (copy), Cryo (copy), useLocalUserId (copy), useIsChatEnabled (copy), useIsGroupChatEnabled (copy), useIsInExperience (copy), useDispatch (copy), ChangedParticipants (copy), fetchChatMetadata (copy), fetchLatestConversationDetails (copy), getAllFriendsAsync (copy), FFlagAppChatPresenceStoreMigration (copy), getAllUserPresences (copy), getNewMessages (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), RoduxAliases (copy), ReceivedUserTyping (copy), paginateAndRefreshConversations (copy), RemovedConversation (copy), RenamedGroupConversation (copy), SetConnectionState (copy), t2 (copy), useRef (copy), useLocalization (copy), RoactNavigation (copy), EnumScreens (copy), FormFactor (copy), FriendshipDestroyed (copy), Conversation (copy), FFlagRemoveUnusedConnectionStateRoduxSlice (copy), CommunicationChannelsTypes (copy), ConversationChannels (copy), FriendConversationCreated (copy), useMemo (copy), getFFlagDebugUnfilteredThreads (copy), chunkAndLogString (copy), multiGetConversationDetails (copy), AppChatNetworking (copy), FFlagAppChatEnableDoubleOptIn (copy), refreshConversationUnfilteredThreadsDetails (copy), useChatTrustedConnectionsEvents (copy)
	useEffect(function() -- line: 88
		-- upvalues: v17 (copy)
		v17:info("ChatEventReceiver mounted")

		return function() -- line: 90
			-- upvalues: v17 (copy)
			v17:info("ChatEventReceiver unmounted")
		end
	end, {})

	local v59 = useSelector(useCallback(function(p2) -- line: 96
		return p2.ChatAppReducer.AppLoaded
	end, {}))
	local v60 = useSelector(useCallback(function(p3) -- line: 99
		return p3.ChatAppReducer.Conversations
	end, {}))
	local v61 = useSelector(useCallback(function(p4) -- line: 102
		return p4.FormFactor
	end, {}))
	local v62 = useSelector(useCallback(function(p5) -- line: 105
		return p5.Users
	end, {}))
	local v63 = Cryo.isEmpty(v60)
	local v64 = useLocalUserId()
	local v65 = useIsChatEnabled()
	local v66 = useIsGroupChatEnabled()
	local v67 = useIsInExperience()
	local v68 = useDispatch()

	local function v69(p6) -- line: 123
		-- upvalues: v68 (copy), fetchLatestConversationDetails (copy)
		return v68(fetchLatestConversationDetails(p6))
	end

	local v70 = if FFlagAppChatPresenceStoreMigration then nil else function() -- line: 130
		-- upvalues: v68 (copy), getAllUserPresences (copy)
		spawn(function() -- line: 131
			-- upvalues: v68 (copy), getAllUserPresences (copy)
			v68(getAllUserPresences())
		end)
	end

	local function restartMessageReceiveTracking(s1: string) -- line: 140
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
	local function v72() -- line: 160
		-- upvalues: v68 (copy), paginateAndRefreshConversations (copy)
		v68(paginateAndRefreshConversations())
	end

	local v73 = Cryo.Dictionary.join(t2, t3)
	local robloxEventReceiver = v73.robloxEventReceiver
	local v75 = useRef({})
	local v76 = useRef(Enum.ConnectionState.Connected)
	local v77 = useLocalization({
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		removedFromConversationToastTitle = "Feature.Chat.Message.RemovedFromConversation"
	})
	local networkErrorText = v77.networkErrorText
	local removedFromConversationToastTitle = v77.removedFromConversationToastTitle
	local v80 = useCallback(function(s2: string, p7) -- line: 187
		-- upvalues: v75 (copy)
		assert(v75.current, "table")
		v75.current[s2] = p7
	end, { v75.current })
	local v81 = useCallback(function() -- line: 192
		-- upvalues: v73 (copy), RoactNavigation (copy), EnumScreens (copy), networkErrorText (copy)
		if v73.rnBypassActionSignal then
			v73.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
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
		v73.rnBypassActionSignal,
		networkErrorText
	})

	useEffect(function() -- line: 207
		-- upvalues: robloxEventReceiver (copy), v80 (copy), v17 (copy), v68 (copy), RemovedConversation (copy), v73 (copy), RoactNavigation (copy), v61 (copy), FormFactor (copy), EnumScreens (copy), removedFromConversationToastTitle (copy), fetchLatestConversationDetails (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v63 (copy), FFlagAppChatPerfTracking (copy), restartMessageReceiveTracking (copy), getNewMessages (copy), ReceivedUserTyping (copy)
		local v111 = robloxEventReceiver:observeEvent("ChatNotifications", function(p8, p9, _) -- line: 208
			-- upvalues: v80 (copy), v17 (copy), v68 (copy), RemovedConversation (copy), v73 (copy), RoactNavigation (copy), v61 (copy), FormFactor (copy), EnumScreens (copy), removedFromConversationToastTitle (copy), fetchLatestConversationDetails (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v63 (copy), FFlagAppChatPerfTracking (copy), restartMessageReceiveTracking (copy), getNewMessages (copy), ReceivedUserTyping (copy)
			v80("ChatNotifications", p8.SequenceNumber)

			local v122 = p8.Type or p9

			v17:info("Received chat notification: {}", v122)

			local v123 = p8.ConversationId and tostring(p8.ConversationId) or ""

			if v122 == "RemovedFromConversation" or v122 == "ConversationRemoved" then
				v68(RemovedConversation(v123))

				local activeConversationId = v73.activeConversationId

				if activeConversationId ~= nil and v123 == tostring(activeConversationId) and v73.rnBypassActionSignal then
					v73.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v61 == FormFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
					}))
				end

				if v122 == "RemovedFromConversation" then
					v73.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
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
				if v122 == "ConversationTitleChanged" or v122 == "ParticipantAdded" or v122 == "ParticipantLeft" then
					task.spawn(function() -- line: 246
						-- upvalues: v123 (copy), v68 (copy), fetchLatestConversationDetails (copy), v122 (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v17 (copy)
						local v171 = v123

						v68(fetchLatestConversationDetails(v171)):andThen(function(p11) -- line: 248
							-- upvalues: v122 (copy), v123 (copy), v68 (copy), RenamedGroupConversation (copy), ChangedParticipants (copy)
							local title = p11.title
							local lastUpdated = p11.lastUpdated

							if v122 == "ConversationTitleChanged" then
								local v185 = v123
								local isDefaultTitle = p11.isDefaultTitle

								v68(RenamedGroupConversation(v185, title, isDefaultTitle, lastUpdated))

								return
							end

							local v187 = v123
							local participants = p11.participants

							v68(ChangedParticipants(v187, participants, title, lastUpdated))
						end):catch(function(p12) -- line: 264
							-- upvalues: v17 (copy), v122 (copy)
							v17:warning(`NetworkingChat failure in RobloxEventReceiver->{ v122 }, Status: { tostring(p12) }`)
						end)
					end)

					return
				end

				if v122 == "AddedToConversation" or v122 == "NewConversation" then
					if v63 then
						v17:debug(`Received { v122 } event while loading conversation data`)

						return
					end

					task.spawn(function() -- line: 276
						-- upvalues: v123 (copy), v68 (copy), fetchLatestConversationDetails (copy), v17 (copy), v122 (copy)
						local v172 = v123

						v68(fetchLatestConversationDetails(v172)):catch(function(p13) -- line: 277
							-- upvalues: v17 (copy), v122 (copy)
							v17:warning(`NetworkingChat failure in RobloxEventReceiver->{ v122 }, Status: { tostring(p13) }`)
						end)
					end)

					return
				end

				if v122 == "NewMessage" then
					if FFlagAppChatPerfTracking and v73.activeConversationId and v123 == tostring(v73.activeConversationId) then
						restartMessageReceiveTracking(v123)
					end

					local timestamp = tick()

					v68(getNewMessages(v123, false, timestamp))

					return
				end

				if v122 == "NewMessageBySelf" then
					local timestamp = tick()

					v68(getNewMessages(v123, true, timestamp))

					return
				end

				if v122 == "ParticipantTyping" then
					local str = tostring(p8.UserId)

					v68(ReceivedUserTyping(v123, str))
				end
			end
		end)

		return function() -- line: 301
			-- upvalues: v111 (copy)
			if v111 and v111.disconnect then
				v111:disconnect()
			end
		end
	end, {
		v68,
		v80,
		v73.activeConversationId,
		v73.rnBypassActionSignal,
		v63,
		v61,
		v62
	})
	useEffect(function() -- line: 316
		-- upvalues: v65 (copy), v73 (copy), v17 (copy), RoactNavigation (copy), v61 (copy), FormFactor (copy), EnumScreens (copy)
		if not v65 and (v73.activeConversationId and v73.rnBypassActionSignal) then
			v17:debug("Chat is disabled for our user, navigating away from active conversation")
			v73.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v61 == FormFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, { v65 })

	local v82 = if not v73.activeConversationId then nil else v60[v73.activeConversationId]

	useEffect(function() -- line: 329
		-- upvalues: v66 (copy), v82 (copy), v73 (copy), v17 (copy), RoactNavigation (copy), v61 (copy), FormFactor (copy), EnumScreens (copy)
		if not v66 and (v82 and v73.rnBypassActionSignal and v82.type == "group") then
			v17:debug("Group chats are disabled and we are navigated to a group chat. Navigating to ChatLanding")
			v73.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v61 == FormFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, {
		v66,
		v82
	})
	useEffect(function() -- line: 345
		-- upvalues: robloxEventReceiver (copy), v68 (copy), RoduxAliases (copy)
		local v112 = robloxEventReceiver:observeEvent("UserTagChangeNotification", function(p14, _) -- line: 346
			-- upvalues: v68 (copy), RoduxAliases (copy)
			if p14.Type == "UserTagUpdate" then
				local str = tostring(p14.UserId)
				local NewAlias = p14.NewAlias

				v68(RoduxAliases.Actions.AliasUpdated(str, NewAlias))
			end
		end)

		return function() -- line: 352
			-- upvalues: v112 (copy)
			if v112 and v112.disconnect then
				v112:disconnect()
			end
		end
	end, { v68 })
	useEffect(function() -- line: 359
		-- upvalues: robloxEventReceiver (copy), v17 (copy), v68 (copy), paginateAndRefreshConversations (copy), v64 (copy), FriendshipDestroyed (copy), v82 (copy), Conversation (copy), Cryo (copy), v61 (copy), FormFactor (copy), EnumScreens (copy), v73 (copy), RoactNavigation (copy)
		local v113 = robloxEventReceiver:observeEvent("FriendshipNotifications", function(p16, _) -- line: 360
			-- upvalues: v17 (copy), v68 (copy), paginateAndRefreshConversations (copy), v64 (copy), FriendshipDestroyed (copy), v82 (copy), Conversation (copy), Cryo (copy), v61 (copy), FormFactor (copy), EnumScreens (copy), v73 (copy), RoactNavigation (copy)
			local p16Type = p16.Type

			v17:info("Received friendship notification: {}", p16Type)

			if p16Type == "FriendshipCreated" then
				v68(paginateAndRefreshConversations())

				return
			end

			if p16Type == "FriendshipDestroyed" then
				local u135 = nil

				if p16.EventArgs then
					local str = tostring(p16.EventArgs.UserId1)
					local str2 = tostring(p16.EventArgs.UserId2)

					if str == v64 then
						str = "localUserId"
						u135 = str2
					end

					if str2 == v64 then
						str2 = "localUserId"
						u135 = str
					end

					v68(FriendshipDestroyed({
						userId1 = str,
						userId2 = str2
					}))
				end

				if v82 and v82.source == "friends" and v82.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION and Cryo.List.findWhere(v82.participants, function(p18) -- line: 392
					-- upvalues: u135 (ref)
					return p18 == u135
				end) then
					local v138 = if v61 ~= FormFactor.WIDE then EnumScreens.ChatLanding else EnumScreens.EmptyConversation

					v73.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v138
					}))
				end
			end
		end)

		return function() -- line: 406
			-- upvalues: v113 (copy)
			if v113 and v113.disconnect then
				v113:disconnect()
			end
		end
	end, {
		v68,
		v72,
		v64,
		v61,
		v82,
		v73.rnBypassActionSignal
	})
	useEffect(function() -- line: 420
		-- upvalues: robloxEventReceiver (copy), v17 (copy), v68 (copy), RemovedConversation (copy), fetchLatestConversationDetails (copy), v73 (copy), RoactNavigation (copy), EnumScreens (copy)
		local v114 = robloxEventReceiver:observeEvent("ChatMigration", function(p19, _) -- line: 423
			-- upvalues: v17 (copy), v68 (copy), RemovedConversation (copy), fetchLatestConversationDetails (copy), v73 (copy), RoactNavigation (copy), EnumScreens (copy)
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

			v68(RemovedConversation(ConversationId))
			v68(fetchLatestConversationDetails(ChannelId)):catch(function(p21) -- line: 441
				-- upvalues: v17 (copy), p19Type (copy)
				v17:warning(`NetworkingChat failure in RobloxEventReceiver->{ p19Type }, Status: { tostring(p21) }`)
			end)

			if v73.activeConversationId and ConversationId and ConversationId == tostring(v73.activeConversationId) and v73.rnBypassActionSignal then
				v73.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
					routeName = EnumScreens.ChatConversation,
					params = {
						conversationId = ChannelId
					}
				}))
			end
		end)

		return function() -- line: 463
			-- upvalues: v114 (copy)
			if v114 and v114.disconnect then
				v114:disconnect()
			end
		end
	end, {
		v68,
		v73.activeConversationId,
		v73.rnBypassActionSignal,
		v69
	})

	local v83 = useCallback(function() -- line: 475
		-- upvalues: v59 (copy), v68 (copy), fetchChatMetadata (copy), v17 (copy), paginateAndRefreshConversations (copy), getAllFriendsAsync (copy), FFlagAppChatPresenceStoreMigration (copy), v70 (copy)
		if v59 then
			v68(fetchChatMetadata()):andThen(function(b1: boolean) -- line: 477
				-- upvalues: v17 (copy), v68 (copy), paginateAndRefreshConversations (copy), getAllFriendsAsync (copy), FFlagAppChatPresenceStoreMigration (copy), v70 (copy)
				if b1 then
					v17:trace("Chat is enabled for our user, refreshing conversations")
					v68(paginateAndRefreshConversations())
					task.spawn(function() -- line: 482
						-- upvalues: v68 (copy), getAllFriendsAsync (copy)
						v68(getAllFriendsAsync())
					end)

					if not FFlagAppChatPresenceStoreMigration then
						v70()

						return
					end
				else
					v17:trace("Chat is disabled for our user, no need to refresh conversations")
				end
			end)
		end
	end, {
		v59,
		v72,
		function() -- line: 126
			-- upvalues: v68 (copy), getAllFriendsAsync (copy)
			v68(getAllFriendsAsync())
		end,
		v70,
		function() -- line: 119
			-- upvalues: v68 (copy), fetchChatMetadata (copy)
			return v68(fetchChatMetadata())
		end
	})

	useEffect(function() -- line: 495
		-- upvalues: robloxEventReceiver (copy), v17 (copy), FFlagRemoveUnusedConnectionStateRoduxSlice (copy), v68 (copy), SetConnectionState (copy), v76 (copy), v75 (copy), v59 (copy), v83 (copy)
		local v115 = robloxEventReceiver:observeEvent("signalR", function(p22, _, p24) -- line: 498
			-- upvalues: v17 (copy), FFlagRemoveUnusedConnectionStateRoduxSlice (copy), v68 (copy), SetConnectionState (copy), v76 (copy), v75 (copy), v59 (copy), v83 (copy)
			v17:info("SignalR connection state transitioned to {}", (tostring(p22)))

			if not FFlagRemoveUnusedConnectionStateRoduxSlice then
				v68(SetConnectionState(p22))
			end

			v76.current = p22

			if p22 == Enum.ConnectionState.Connected and p24 and (v75.current == nil or v75.current.ChatNotifications ~= p24.ChatNotifications or v75.current.CommunicationChannels ~= p24.CommunicationChannels) then
				v17:trace("We missed some messages while we were disconnected. The chat app was previously {}", not v59 and "unloaded" or "loaded")
				v83()
			end
		end)

		return function() -- line: 523
			-- upvalues: v115 (copy)
			if v115 and v115.disconnect then
				v115:disconnect()
			end
		end
	end, {
		v68,
		v76,
		v75,
		v81,
		v59
	})
	useEffect(function() -- line: 530
		-- upvalues: robloxEventReceiver (copy), CommunicationChannelsTypes (copy), v17 (copy), v80 (copy), v68 (copy), RemovedConversation (copy), v73 (copy), v61 (copy), FormFactor (copy), EnumScreens (copy), RoactNavigation (copy), v64 (copy), removedFromConversationToastTitle (copy), fetchLatestConversationDetails (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v63 (copy), ConversationChannels (copy), FriendConversationCreated (copy), FFlagAppChatPerfTracking (copy), restartMessageReceiveTracking (copy), getNewMessages (copy), ReceivedUserTyping (copy)
		local v116 = robloxEventReceiver:observeEvent("CommunicationChannels", function(p25, _) -- line: 533
			-- upvalues: CommunicationChannelsTypes (copy), v17 (copy), v80 (copy), v68 (copy), RemovedConversation (copy), v73 (copy), v61 (copy), FormFactor (copy), EnumScreens (copy), RoactNavigation (copy), v64 (copy), removedFromConversationToastTitle (copy), fetchLatestConversationDetails (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v63 (copy), ConversationChannels (copy), FriendConversationCreated (copy), FFlagAppChatPerfTracking (copy), restartMessageReceiveTracking (copy), getNewMessages (copy), ReceivedUserTyping (copy)
			if p25.ChannelVertical ~= "PlatformChat" then
				return
			end

			if not table.find(CommunicationChannelsTypes.ChannelTypeAllowlist, p25.ChannelType) then
				return
			end

			v17:info("Received channels notification: {}", p25.Type)
			v80("CommunicationChannels", p25.SequenceNumber)

			local ChannelId = p25.ChannelId

			if p25.Type == "ChannelDeleted" or p25.Type == "RemovedFromChannel" or p25.Type == "ChannelArchived" then
				v68(RemovedConversation(ChannelId))

				local activeConversationId = v73.activeConversationId

				if activeConversationId ~= nil and tostring(activeConversationId) == p25.ChannelId and v73.rnBypassActionSignal then
					local v152 = if v61 ~= FormFactor.WIDE then EnumScreens.ChatLanding else EnumScreens.EmptyConversation

					v73.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v152
					}))
				end

				if p25.Actor.Id ~= tostring(v64) then
					v73.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
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
					task.spawn(function() -- line: 586
						-- upvalues: ChannelId (copy), v68 (copy), fetchLatestConversationDetails (copy), p25 (copy), RenamedGroupConversation (copy), ChangedParticipants (copy), v17 (copy)
						local v175 = ChannelId

						v68(fetchLatestConversationDetails(v175)):andThen(function(p27) -- line: 588
							-- upvalues: p25 (copy), ChannelId (copy), v68 (copy), RenamedGroupConversation (copy), ChangedParticipants (copy)
							local title = p27.title
							local lastUpdated = p27.lastUpdated

							if p25.Type == "ChannelUpdated" then
								local v194 = ChannelId
								local isDefaultTitle = p27.isDefaultTitle

								v68(RenamedGroupConversation(v194, title, isDefaultTitle, lastUpdated))

								return
							end

							local v196 = ChannelId
							local participants = p27.participants

							v68(ChangedParticipants(v196, participants, title, lastUpdated))
						end):catch(function(p28) -- line: 599
							-- upvalues: v17 (copy), p25 (copy)
							v17:warning(`Failure in RobloxEventReceiver->{ p25.Type }, Status: { tostring(p28) }`)
						end)
					end)

					return
				end

				if p25.Type == "AddedToChannel" or p25.Type == "ChannelCreated" or p25.Type == "ChannelMarkedRead" or (p25.Type == "ChannelMetadataUpdated" and ChannelId ~= nil or p25.Type == "ChannelUnarchived") then
					if v63 then
						v17:debug("Received {} event while loading conversation data", p25.Type)

						return
					end

					task.spawn(function() -- line: 617
						-- upvalues: ChannelId (copy), v68 (copy), fetchLatestConversationDetails (copy), p25 (copy), ConversationChannels (copy), FriendConversationCreated (copy), v73 (copy), RoactNavigation (copy), EnumScreens (copy), v17 (copy)
						local v176 = ChannelId

						v68(fetchLatestConversationDetails(v176)):andThen(function(p29) -- line: 619
							-- upvalues: p25 (copy), ConversationChannels (copy), v68 (copy), FriendConversationCreated (copy), v73 (copy), RoactNavigation (copy), EnumScreens (copy)
							if (p25.Type == "ChannelCreated" or p25.Type == "ChannelUnarchived") and p29.type == "one_to_one" then
								local v200 = ConversationChannels.getFriendConversationId(p29.participants)

								if v200 then
									v68(FriendConversationCreated({
										newConversationId = p29.id,
										oldFriendConversationId = v200
									}))

									if v200 == v73.activeConversationId then
										v73.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
											routeName = EnumScreens.ChatConversation,
											params = {
												conversationId = p29.id
											}
										}))
									end
								end
							end
						end):catch(function(p30) -- line: 643
							-- upvalues: v17 (copy), p25 (copy)
							v17:warning("Failure in RobloxEventReceiver->{}, Status: {}", p25.Type, (tostring(p30)))
						end)
					end)

					return
				end

				if p25.Type == "MessageCreated" or p25.Type == "SystemMessageCreated" then
					if FFlagAppChatPerfTracking then
						local v153 = p25.Actor.Id == tostring(v64)

						if not v153 and v73.activeConversationId and ChannelId == tostring(v73.activeConversationId) then
							restartMessageReceiveTracking(ChannelId)
						end

						local timestamp = tick()

						v68(getNewMessages(ChannelId, v153, timestamp))

						return
					end

					local v155 = p25.Actor.Id == tostring(v64)
					local timestamp = tick()

					v68(getNewMessages(ChannelId, v155, timestamp))

					return
				end

				if p25.Type == "ParticipantTyping" and p25.IsTyping then
					local ActorId = p25.Actor.Id

					v68(ReceivedUserTyping(ChannelId, ActorId))
				end
			end
		end)

		return function() -- line: 672
			-- upvalues: v116 (copy)
			if v116 and v116.disconnect then
				v116:disconnect()
			end
		end
	end, {
		v64,
		robloxEventReceiver,
		v80,
		function(p31) -- line: 164
			-- upvalues: v68 (copy), RemovedConversation (copy)
			v68(RemovedConversation(p31))
		end,
		v73.activeConversationId,
		v73.rnBypassActionSignal,
		removedFromConversationToastTitle,
		v69,
		function(p32, p33, p34, p35) -- line: 167
			-- upvalues: v68 (copy), RenamedGroupConversation (copy)
			v68(RenamedGroupConversation(p32, p33, p34, p35))
		end,
		function(p36, p37, p38, p39) -- line: 116
			-- upvalues: v68 (copy), ChangedParticipants (copy)
			v68(ChangedParticipants(p36, p37, p38, p39))
		end,
		v63,
		function(p40, p41, p42) -- line: 136
			-- upvalues: v68 (copy), getNewMessages (copy)
			return v68(getNewMessages(p40, p41, p42))
		end,
		function(p43, p44) -- line: 156
			-- upvalues: v68 (copy), ReceivedUserTyping (copy)
			v68(ReceivedUserTyping(p43, p44))
		end,
		v83
	})

	local v84 = useMemo(function() -- line: 694
		-- upvalues: v60 (copy), Cryo (copy)
		if not v60 then
			return {}
		end

		return (Cryo.List.filterMap(Cryo.Dictionary.values(v60), function(p45) -- line: 699
			if p45 and (p45.id and p45.source ~= "friends") then
				return p45.id
			end

			return nil
		end))
	end, { v60 })

	useEffect(function() -- line: 709
		-- upvalues: robloxEventReceiver (copy), v17 (copy), getFFlagDebugUnfilteredThreads (copy), chunkAndLogString (copy), Cryo (copy), v84 (copy), v68 (copy), multiGetConversationDetails (copy), v73 (copy), AppChatNetworking (copy), FFlagAppChatEnableDoubleOptIn (copy), refreshConversationUnfilteredThreadsDetails (copy), v67 (copy)
		local v117 = robloxEventReceiver:observeEvent("ChatModerationTypeEligibility", function(p46, _) -- line: 712
			-- upvalues: v17 (copy), getFFlagDebugUnfilteredThreads (copy), chunkAndLogString (copy), Cryo (copy), v84 (copy), v68 (copy), multiGetConversationDetails (copy), v73 (copy), AppChatNetworking (copy), FFlagAppChatEnableDoubleOptIn (copy), refreshConversationUnfilteredThreadsDetails (copy), v67 (copy)
			v17:debug("Received ChatModerationTypeEligibility notification")

			local channels_inspected = p46.channels_inspected

			if not channels_inspected or #channels_inspected == 0 then
				return
			end

			if getFFlagDebugUnfilteredThreads() then
				local s3 = ""

				for _, v164 in channels_inspected do
					s3 = `{ s3 }, { v164 }`
				end

				chunkAndLogString(`RTN CONVERSATIONS INSPECTED{ s3 }`)
			end

			local v165 = Cryo.List.filter(channels_inspected, function(p48) -- line: 726
				-- upvalues: v84 (copy)
				return table.find(v84, p48)
			end)

			if #v165 == 0 then
				v17:debug("No filtered existing conversation IDs found in ChatModerationTypeEligibility notification")

				return
			end

			if getFFlagDebugUnfilteredThreads() then
				local s4 = ""

				for _, v168 in v165 do
					s4 = `{ s4 }, { v168 }`
				end

				chunkAndLogString(`RTN FILTERED CONVERSATIONS{ s4 }`)
			end

			v68(multiGetConversationDetails(v165)):catch(function(p49) -- line: 742
				-- upvalues: v17 (copy)
				v17:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->MultiGetConversationDetails, Status: " .. tostring(p49))
			end)

			if not v73.activeConversationId then
				return
			end

			if table.find(channels_inspected, v73.activeConversationId) then
				v68(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ v73.activeConversationId })):catch(function(p50) -- line: 756
					-- upvalues: v17 (copy)
					v17:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->GetConversationsParticipantsMetadata, Status: " .. tostring(p50))
				end)

				if FFlagAppChatEnableDoubleOptIn then
					v68(refreshConversationUnfilteredThreadsDetails(v73.activeConversationId, v67))

					return
				end

				v68(AppChatNetworking.rodux.GetConversationTopModal.API(v73.activeConversationId, v67)):catch(function(p51) -- line: 773
					-- upvalues: v17 (copy)
					v17:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->GetConversationTopModal, Status: " .. tostring(p51))
				end)
			end
		end)

		return function() -- line: 785
			-- upvalues: v117 (copy)
			if v117 and v117.disconnect then
				v117:disconnect()
			end
		end
	end, {
		v68,
		v73.activeConversationId,
		v84
	})
	useEffect(function() -- line: 792
		-- upvalues: robloxEventReceiver (copy), v17 (copy), v68 (copy), AppChatNetworking (copy), v67 (copy)
		local v118 = robloxEventReceiver:observeEvent("EligibilityStatusChanged", function(_, _) -- line: 795
			-- upvalues: v17 (copy), v68 (copy), AppChatNetworking (copy), v67 (copy)
			v17:info("Received EligibilityStatusChanged notification")
			v68(AppChatNetworking.rodux.GetChatLandingModal.API(v67)):catch(function(p54) -- line: 798
				-- upvalues: v17 (copy)
				v17:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p54)))
			end)
		end)

		return function() -- line: 804
			-- upvalues: v118 (copy)
			if v118 and v118.disconnect then
				v118:disconnect()
			end
		end
	end, { v68 })
	useChatTrustedConnectionsEvents({
		activeConversationId = v73.activeConversationId
	})

	return {}
end

return ChatEventReceiver
