if require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatMigrateChatEventReceiver then
	return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/ChatEventReceiver2")
end

local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useLocalization = Localization.Hooks.useLocalization
local useMemo = React.useMemo
local useRef = React.useRef
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local formFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FormFactor").Enums.FormFactor
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("AppChat.Realtime")

local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local ChangedParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ChangedParticipants")
local RoduxAliases = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxAliases")
local ReceivedUserTyping = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedUserTyping")
local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")
local RenamedGroupConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RenamedGroupConversation")
local SetConnectionState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/SetConnectionState")
local FriendConversationCreated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/FriendConversationCreated")
local FriendshipDestroyed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/FriendshipDestroyed")
local useIsChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatEnabled")
local useIsGroupChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsGroupChatEnabled")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")

local module20 = require("@luauforge/bundled/hbw")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local getNewMessages = module20.Thunks.getNewMessages
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatMessageTTIMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageTTIMilestones")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local paginateAndRefreshConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/paginateAndRefreshConversations")
local fetchChatMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/fetchChatMetadata")
local getAllUserPresences = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/getAllUserPresences")
local fetchLatestConversationDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/fetchLatestConversationDetails")
local getAllFriendsAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/getAllFriendsAsync")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local multiGetConversationDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/multiGetConversationDetails")

local refreshConversationUnfilteredThreadsDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/refreshConversationUnfilteredThreadsDetails")

local CommunicationChannelsTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/CommunicationChannelsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/UnfilteredThreadsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/ChatMigrationTypes")

local useChatTrustedConnectionsEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/useChatTrustedConnectionsEvents")
local getFFlagDebugUnfilteredThreads = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").getFFlagDebugUnfilteredThreads

local fFlagRemoveUnusedConnectionStateRoduxSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagRemoveUnusedConnectionStateRoduxSlice
local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")
local FFlagAppChatUseSignalsForAppLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForAppLoaded")
local GetAppLoadedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetAppLoadedStore")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState

local function chunkAndLogString(value)
	local v6 = {}

	for i = 1, #value, 800 do
		table.insert(v6, value:sub(i, i + 800 - 1))
	end

	for k, v7 in v6 do
		v5:debug(v7)
	end
end

local v6 = { handlesAppShellNotifications = true }

function LUAUFORGE_MODULE_GLOBALS_hbr_ChatEventReceiver(p2)
	useEffect(function()
		v5:info("ChatEventReceiver mounted")
		return function()
			v5:info("ChatEventReceiver unmounted")
		end
	end, {})
	local v7

	if FFlagAppChatUseSignalsForAppLoaded then
		v7 = useSignalState(GetAppLoadedStore(false).getAppLoaded)
	else
		v7 = useSelector(useCallback(function(p3)
			return p3.ChatAppReducer.AppLoaded
		end, {}))
	end

	local v8 = useSelector(useCallback(function(p3)
		return p3.ChatAppReducer.Conversations
	end, {}))
	local v9 = useSelector(useCallback(function(p3)
		return p3.FormFactor
	end, {}))
	local v10 = useSelector(useCallback(function(p3)
		return p3.Users
	end, {}))

	local empty = Cryo.isEmpty(v8)
	local v11 = useLocalUserId()
	local v12 = useIsChatEnabled()
	local v13 = useIsGroupChatEnabled()
	local v14 = useIsInExperience()

	local v15 = useDispatch()
	local function fn(p3, p4, p5, p6)
		v15(ChangedParticipants(p3, p4, p5, p6))
	end
	local function fn2()
		return v15(fetchChatMetadata())
	end

	local function fn3(p3)
		return v15(fetchLatestConversationDetails(p3))
	end

	local function fn4()
		v15(getAllFriendsAsync())
	end

	local fn5 = not FFlagAppChatPresenceStoreMigration and function()
		spawn(function()
			v15(getAllUserPresences())
		end)
	end or nil

	local function fn6(p3, p4, p5)
		return v15(getNewMessages(p3, p4, p5))
	end

	local function restartMessageReceiveTracking(p3)
		if not FFlagAppChatPerfTracking then
			return
		end

		local v16 = { conversationId = tostring(p3) }

		if FFlagAppChatMessageTTIMilestones then
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveTTI, v16)
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageReceiveTTI, v16)
		else
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveToRender, v16)
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageReceiveToRender, v16)
		end
	end

	local function fn7(p3, p4)
		v15(ReceivedUserTyping(p3, p4))
	end

	local function fn8()
		v15(paginateAndRefreshConversations())
	end

	local function fn9(p3)
		v15(RemovedConversation(p3))
	end
	local function fn10(p3, p4, p5, p6)
		v15(RenamedGroupConversation(p3, p4, p5, p6))
	end

	local joined = Cryo.Dictionary.join(v6, p2)
	local robloxEventReceiver = joined.robloxEventReceiver

	local v16 = useRef({})
	local v17 = useRef(Enum.ConnectionState.Connected)

	local v18 = useLocalization({
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		removedFromConversationToastTitle = "Feature.Chat.Message.RemovedFromConversation"
	})

	local networkErrorText = v18.networkErrorText
	local removedFromConversationToastTitle = v18.removedFromConversationToastTitle

	local v19 = useCallback(function(p3, p4)
		assert(v16.current, "table")
		v16.current[p3] = p4
	end, { v16.current })

	local v20 = useCallback(function()
		if joined.rnBypassActionSignal then
			joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = EnumScreens.RoactChatToast,
				params = {
					toastProps = {
						toastContent = { toastTitle = networkErrorText }
					}
				}
			}))
		end
	end, { joined.rnBypassActionSignal, networkErrorText })

	useEffect(function()
		local v21 = robloxEventReceiver:observeEvent("ChatNotifications", function(data, p3, p4)
			v19("ChatNotifications", data.SequenceNumber)
			local kind = data.Type or p3
			v5:info("Received chat notification: {}", kind)

			local conversationId = data.ConversationId and tostring(data.ConversationId) or ""

			if kind == "RemovedFromConversation" or kind == "ConversationRemoved" then
				v15(RemovedConversation(conversationId))

				local activeConversationId = joined.activeConversationId

				if
					activeConversationId ~= nil
					and tostring(activeConversationId) == conversationId
					and joined.rnBypassActionSignal
				then
					joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v9 == formFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
					}))
				end

				if kind == "RemovedFromConversation" then
					joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = EnumScreens.RoactChatToast,
						params = {
							toastProps = {
								toastContent = {
									toastTitle = removedFromConversationToastTitle
								}
							}
						}
					}))
				end
			elseif
				kind == "ConversationTitleChanged"
				or kind == "ParticipantAdded"
				or kind == "ParticipantLeft"
			then
				task.spawn(function()
					v15(fetchLatestConversationDetails(conversationId)):andThen(function(data2)
						local title = data2.title
						local lastUpdated = data2.lastUpdated

						if kind == "ConversationTitleChanged" then
							v15(RenamedGroupConversation(conversationId, title, data2.isDefaultTitle, lastUpdated))
						else
							v15(ChangedParticipants(conversationId, data2.participants, title, lastUpdated))
						end
					end):catch(function(p5)
						v5:warning(`NetworkingChat failure in RobloxEventReceiver->{kind}, Status: {tostring(p5)}`)
					end)
				end)
			elseif kind == "AddedToConversation" or kind == "NewConversation" then
				if empty then
					v5:debug(`Received {kind} event while loading conversation data`)
				else
					task.spawn(function()
						v15(fetchLatestConversationDetails(conversationId)):catch(function(p5)
							v5:warning(`NetworkingChat failure in RobloxEventReceiver->{kind}, Status: {tostring(p5)}`)
						end)
					end)
				end
			elseif kind == "NewMessage" then
				if
					FFlagAppChatPerfTracking
					and joined.activeConversationId
					and tostring(joined.activeConversationId) == conversationId
				then
					restartMessageReceiveTracking(conversationId)
				end

				v15(getNewMessages(conversationId, false, (tick())))
			elseif kind == "NewMessageBySelf" then
				v15(getNewMessages(conversationId, true, (tick())))
			elseif kind == "ParticipantTyping" then
				v15(ReceivedUserTyping(conversationId, (tostring(data.UserId))))
			end
		end)

		return function()
			if v21 and v21.disconnect then
				v21:disconnect()
			end
		end
	end, {
		v15,
		v19,
		joined.activeConversationId,
		joined.rnBypassActionSignal,
		empty,
		v9,
		v10
	})

	useEffect(function()
		if not v12 and joined.activeConversationId and joined.rnBypassActionSignal then
			v5:debug("Chat is disabled for our user, navigating away from active conversation")
			joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v9 == formFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, { v12 })

	local v21 = if joined.activeConversationId then v8[joined.activeConversationId] else nil
	useEffect(function()
		if not v13 and v21 and joined.rnBypassActionSignal and v21.type == "group" then
			v5:debug("Group chats are disabled and we are navigated to a group chat. Navigating to ChatLanding")

			joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v9 == formFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, { v13, v21 })

	useEffect(function()
		local v22 = robloxEventReceiver:observeEvent("UserTagChangeNotification", function(data, p3)
			if data.Type == "UserTagUpdate" then
				local userId = tostring(data.UserId)
				local newAlias = data.NewAlias
				v15(RoduxAliases.Actions.AliasUpdated(userId, newAlias))
			end
		end)

		return function()
			if v22 and v22.disconnect then
				v22:disconnect()
			end
		end
	end, { v15 })

	useEffect(function()
		local v22 = robloxEventReceiver:observeEvent("FriendshipNotifications", function(p3, p4)
			local kind = p3.Type
			v5:info("Received friendship notification: {}", kind)

			if kind == "FriendshipCreated" then
				v15(paginateAndRefreshConversations())
			elseif kind == "FriendshipDestroyed" then
				local v23 = nil

				if p3.EventArgs then
					local v24 = tostring(p3.EventArgs.UserId1)
					local v25 = tostring(p3.EventArgs.UserId2)

					if v24 == v11 then
						v23 = v25
						v24 = "localUserId"
					end

					if v25 == v11 then
						v23 = v24
						v25 = "localUserId"
					end

					v15(FriendshipDestroyed({ userId1 = v24, userId2 = v25 }))
				end

				if
					v21
					and v21.source == "friends"
					and v21.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION
					and Cryo.List.findWhere(v21.participants, function(p5): boolean
						return p5 == v23
					end)
				then
					local v24 = if v9 == formFactor.WIDE then EnumScreens.EmptyConversation else EnumScreens.ChatLanding
					joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v24
					}))
				end
			end
		end)

		return function()
			if v22 and v22.disconnect then
				v22:disconnect()
			end
		end
	end, { v15, fn8, v11, v9, v21, joined.rnBypassActionSignal })

	useEffect(function()
		local v22 = robloxEventReceiver:observeEvent("ChatMigration", function(data, p3)
			local kind = data.Type
			v5:info("Received chat migration notification: {}", kind)
			local v23, v24

			if kind == "ConversationBackfilled" then
				v23 = data.ConversationId
				v24 = data.ChannelId
			elseif kind == "ConversationReset" then
				v23 = data.ChannelId
				v24 = data.ConversationId
			else
				v5:warning(`ChatEventReceiver: unknown notification {kind}`)
				return
			end

			v15(RemovedConversation(v23))
			v15(fetchLatestConversationDetails(v24)):catch(function(p4)
				v5:warning(`NetworkingChat failure in RobloxEventReceiver->{kind}, Status: {tostring(p4)}`)
			end)

			if
				joined.activeConversationId
				and v23
				and tostring(joined.activeConversationId) == v23
				and joined.rnBypassActionSignal
			then
				joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
					routeName = EnumScreens.ChatConversation,
					params = { conversationId = v24 }
				}))
			end
		end)

		return function()
			if v22 and v22.disconnect then
				v22:disconnect()
			end
		end
	end, { v15, joined.activeConversationId, joined.rnBypassActionSignal, fn3 })

	local v22 = useCallback(function()
		if v7 then
			v15(fetchChatMetadata()):andThen(function(p3)
				if p3 then
					v5:trace("Chat is enabled for our user, refreshing conversations")
					v15(paginateAndRefreshConversations())

					task.spawn(function()
						v15(getAllFriendsAsync())
					end)

					if not FFlagAppChatPresenceStoreMigration then
						fn5()
					end
				else
					v5:trace("Chat is disabled for our user, no need to refresh conversations")
				end
			end)
		end
	end, { v7, fn8, fn4, fn5, fn2 })

	useEffect(function()
		local v23 = robloxEventReceiver:observeEvent("signalR", function(current, p3, p4)
			v5:info("SignalR connection state transitioned to {}", (tostring(current)))

			if not fFlagRemoveUnusedConnectionStateRoduxSlice then
				v15(SetConnectionState(current))
			end

			v17.current = current

			if
				current == Enum.ConnectionState.Connected
				and p4
				and (v16.current == nil or v16.current.ChatNotifications ~= p4.ChatNotifications or v16.current.CommunicationChannels ~= p4.CommunicationChannels)
			then
				v5:trace(
					"We missed some messages while we were disconnected. The chat app was previously {}",
					v7 and "loaded" or "unloaded"
				)

				v22()
			end
		end)

		return function()
			if v23 and v23.disconnect then
				v23:disconnect()
			end
		end
	end, { v15, v17, v16, v20, v7 })

	useEffect(function()
		local v23 = robloxEventReceiver:observeEvent("CommunicationChannels", function(data, p3)
			if not (data.ChannelVertical == "PlatformChat" and table.find(CommunicationChannelsTypes.ChannelTypeAllowlist, data.ChannelType)) then
				return
			end

			v5:info("Received channels notification: {}", data.Type)

			v19("CommunicationChannels", data.SequenceNumber)

			local channelId = data.ChannelId

			if
				data.Type == "ChannelDeleted"
				or data.Type == "RemovedFromChannel"
				or data.Type == "ChannelArchived"
			then
				v15(RemovedConversation(channelId))

				local activeConversationId = joined.activeConversationId

				if
					activeConversationId ~= nil
					and tostring(activeConversationId) == data.ChannelId
					and joined.rnBypassActionSignal
				then
					local v24 = if v9 == formFactor.WIDE then EnumScreens.EmptyConversation else EnumScreens.ChatLanding
					joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v24
					}))
				end

				if data.Actor.Id ~= tostring(v11) then
					joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = EnumScreens.RoactChatToast,
						params = {
							toastProps = {
								toastContent = {
									toastTitle = removedFromConversationToastTitle
								}
							}
						}
					}))
				end
			elseif
				data.Type == "ChannelUpdated"
				or data.Type == "ParticipantsAdded"
				or data.Type == "ParticipantsRemoved"
			then
				task.spawn(function()
					v15(fetchLatestConversationDetails(channelId)):andThen(function(data2)
						local title = data2.title
						local lastUpdated = data2.lastUpdated

						if data.Type == "ChannelUpdated" then
							v15(RenamedGroupConversation(channelId, title, data2.isDefaultTitle, lastUpdated))
						else
							v15(ChangedParticipants(channelId, data2.participants, title, lastUpdated))
						end
					end):catch(function(p4)
						v5:warning(`Failure in RobloxEventReceiver->{data.Type}, Status: {tostring(p4)}`)
					end)
				end)
			elseif
				data.Type == "AddedToChannel"
				or data.Type == "ChannelCreated"
				or data.Type == "ChannelMarkedRead"
				or data.Type == "ChannelMetadataUpdated" and channelId ~= nil
				or data.Type == "ChannelUnarchived"
			then
				if empty then
					v5:debug("Received {} event while loading conversation data", data.Type)
				else
					task.spawn(function()
						v15(fetchLatestConversationDetails(channelId)):andThen(function(data2)
							local v24 = (data.Type == "ChannelCreated" or data.Type == "ChannelUnarchived")
								and data2.type == "one_to_one"
								and ConversationChannels.getFriendConversationId(data2.participants)

							if v24 then
								v15(FriendConversationCreated({
									newConversationId = data2.id,
									oldFriendConversationId = v24
								}))

								if joined.activeConversationId == v24 then
									joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
										routeName = EnumScreens.ChatConversation,
										params = { conversationId = data2.id }
									}))
								end
							end
						end):catch(function(p4)
							v5:warning(
								"Failure in RobloxEventReceiver->{}, Status: {}",
								data.Type,
								(tostring(p4))
							)
						end)
					end)
				end
			elseif data.Type == "MessageCreated" or data.Type == "SystemMessageCreated" then
				if FFlagAppChatPerfTracking then
					local v24 = data.Actor.Id == tostring(v11)

					if
						not v24
						and joined.activeConversationId
						and tostring(joined.activeConversationId) == channelId
					then
						restartMessageReceiveTracking(channelId)
					end

					v15(getNewMessages(channelId, v24, (tick())))
				else
					v15(getNewMessages(channelId, data.Actor.Id == tostring(v11), (tick())))
				end
			elseif data.Type == "ParticipantTyping" and data.IsTyping then
				v15(ReceivedUserTyping(channelId, data.Actor.Id))
			end
		end)

		return function()
			if v23 and v23.disconnect then
				v23:disconnect()
			end
		end
	end, {
		v11,
		robloxEventReceiver,
		v19,
		fn9,
		joined.activeConversationId,
		joined.rnBypassActionSignal,
		removedFromConversationToastTitle,
		fn3,
		fn10,
		fn,
		empty,
		fn6,
		fn7,
		v22
	})

	local v23 = useMemo(function()
		if v8 then
			return (Cryo.List.filterMap(Cryo.Dictionary.values(v8), function(p3)
				if p3 and p3.id and p3.source ~= "friends" then
					return p3.id
				end

				return nil
			end))
		end

		return {}
	end, { v8 })
	useEffect(function()
		local v24 = robloxEventReceiver:observeEvent("ChatModerationTypeEligibility", function(p3, p4)
			v5:debug("Received ChatModerationTypeEligibility notification")
			local channels_inspected = p3.channels_inspected

			if not channels_inspected or #channels_inspected == 0 then
				return
			end

			if getFFlagDebugUnfilteredThreads() then
				local v25 = ""

				for k, v26 in channels_inspected do
					v25 = `{v25}, {v26}`
				end

				chunkAndLogString(`RTN CONVERSATIONS INSPECTED{v25}`)
			end

			local filtered = Cryo.List.filter(channels_inspected, function(p5)
				return table.find(v23, p5)
			end)

			if #filtered == 0 then
				v5:debug("No filtered existing conversation IDs found in ChatModerationTypeEligibility notification")

				return
			end

			if getFFlagDebugUnfilteredThreads() then
				local v25 = ""

				for k, v26 in filtered do
					v25 = `{v25}, {v26}`
				end

				chunkAndLogString(`RTN FILTERED CONVERSATIONS{v25}`)
			end

			v15(multiGetConversationDetails(filtered)):catch(function(p5)
				v5:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->MultiGetConversationDetails, Status: " .. tostring(p5))
			end)

			if not joined.activeConversationId then
				return
			end

			if table.find(channels_inspected, joined.activeConversationId) then
				v15(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ joined.activeConversationId })):catch(function(p5)
					v5:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->GetConversationsParticipantsMetadata, Status: " .. tostring(p5))
				end)
				v15(refreshConversationUnfilteredThreadsDetails(joined.activeConversationId, v14))
			end
		end)

		return function()
			if v24 and v24.disconnect then
				v24:disconnect()
			end
		end
	end, { v15, joined.activeConversationId, v23 })

	useEffect(function()
		local v24 = robloxEventReceiver:observeEvent("EligibilityStatusChanged", function(p3, p4)
			v5:info("Received EligibilityStatusChanged notification")

			v15(AppChatNetworking.rodux.GetChatLandingModal.API(v14)):catch(function(p5)
				v5:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p5)))
			end)
		end)

		return function()
			if v24 and v24.disconnect then
				v24:disconnect()
			end
		end
	end, { v15 })

	useChatTrustedConnectionsEvents({ activeConversationId = joined.activeConversationId })

	return {}
end

return LUAUFORGE_MODULE_GLOBALS_hbr_ChatEventReceiver
