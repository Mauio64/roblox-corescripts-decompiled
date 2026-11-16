local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SharedFlags = require(parent.SharedFlags)

if SharedFlags.FFlagAppChatMigrateChatEventReceiver then
	local ChatEventReceiver2 = require(script.Parent.ChatEventReceiver2)
	return ChatEventReceiver2
end

local Localization = require(parent.Localization)
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local RoactUtils = require(parent.RoactUtils)
local Cryo = require(parent.Cryo)
local AppChatNetworking = require(parent.AppChatNetworking)

local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useLocalization = Localization.Hooks.useLocalization
local useMemo = React.useMemo
local useRef = React.useRef
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local FormFactor = require(parent.FormFactor)
local formFactor = FormFactor.Enums.FormFactor
local Logger = require(AppChat.Logger)
local v = Logger:new("AppChat.Realtime")

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
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local multiGetConversationDetails = require(AppChat.Conversations.Thunks.multiGetConversationDetails)

local refreshConversationUnfilteredThreadsDetails = require(AppChat.Conversations.Thunks.refreshConversationUnfilteredThreadsDetails)

local CommunicationChannelsTypes = require(script.Parent.CommunicationChannelsTypes)
require(script.Parent.UnfilteredThreadsTypes)
require(script.Parent.ChatMigrationTypes)

local useChatTrustedConnectionsEvents = require(AppChat.Components.EventReceivers.useChatTrustedConnectionsEvents)
local SharedFlags2 = require(parent.SharedFlags)
local getFFlagDebugUnfilteredThreads = SharedFlags2.getFFlagDebugUnfilteredThreads

local SharedFlags3 = require(parent.SharedFlags)
local FFlagRemoveUnusedConnectionStateRoduxSlice = SharedFlags3.FFlagRemoveUnusedConnectionStateRoduxSlice
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local FFlagAppChatUseSignalsForAppLoaded = require(AppChat.Flags.FFlagAppChatUseSignalsForAppLoaded)
local GetAppLoadedStore = require(AppChat.Stores.GetAppLoadedStore)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local function chunkAndLogString(value)
	local v2 = {}

	for i = 1, #value, 800 do
		table.insert(v2, value:sub(i, i + 800 - 1))
	end

	for _, v3 in v2 do
		v:debug(v3)
	end
end

local v2 = { handlesAppShellNotifications = true }

function ChatEventReceiver(p)
	useEffect(function()
		v:info("ChatEventReceiver mounted")
		return function()
			v:info("ChatEventReceiver unmounted")
		end
	end, {})
	local v3

	if FFlagAppChatUseSignalsForAppLoaded then
		v3 = useSignalState(GetAppLoadedStore(false).getAppLoaded)
	else
		v3 = useSelector(useCallback(function(p2)
			return p2.ChatAppReducer.AppLoaded
		end, {}))
	end

	local v4 = useSelector(useCallback(function(p2)
		return p2.ChatAppReducer.Conversations
	end, {}))
	local v5 = useSelector(useCallback(function(p2)
		return p2.FormFactor
	end, {}))
	local v6 = useSelector(useCallback(function(p2)
		return p2.Users
	end, {}))

	local empty = Cryo.isEmpty(v4)
	local v7 = useLocalUserId()
	local v8 = useIsChatEnabled()
	local v9 = useIsGroupChatEnabled()
	local v10 = useIsInExperience()

	local v11 = useDispatch()
	local function fn(p2, participants, title, lastUpdated) -- 2 equivalent calls inferred from this helper
		v11(ChangedParticipants(p2, participants, title, lastUpdated))
	end
	local function fn2() -- 1 equivalent call inferred from this helper
		return v11(fetchChatMetadata())
	end

	local function fn3(p2) -- 5 equivalent calls inferred from this helper
		return v11(fetchLatestConversationDetails(p2))
	end

	local function fn4() -- 1 equivalent call inferred from this helper
		v11(getAllFriendsAsync())
	end

	local fn5 = not FFlagAppChatPresenceStoreMigration and function()
		spawn(function()
			v11(getAllUserPresences())
		end)
	end or nil

	local function fn6(p2, p3, now) -- 4 equivalent calls inferred from this helper
		return v11(getNewMessages(p2, p3, now))
	end

	local function restartMessageReceiveTracking(p2: string)
		if not FFlagAppChatPerfTracking then
			return
		end

		local v12 = { conversationId = tostring(p2) }

		if FFlagAppChatMessageTTIMilestones then
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveTTI, v12)
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageReceiveTTI, v12)
		else
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveToRender, v12)
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageReceiveToRender, v12)
		end
	end

	local function fn7(p2, p3) -- 2 equivalent calls inferred from this helper
		v11(ReceivedUserTyping(p2, p3))
	end

	local function fn8() -- 2 equivalent calls inferred from this helper
		v11(paginateAndRefreshConversations())
	end

	local function fn9(p2) -- 2 equivalent calls inferred from this helper
		v11(RemovedConversation(p2))
	end
	local function fn10(p2, title, isDefaultTitle, lastUpdated) -- 2 equivalent calls inferred from this helper
		v11(RenamedGroupConversation(p2, title, isDefaultTitle, lastUpdated))
	end

	local joined = Cryo.Dictionary.join(v2, p)
	local robloxEventReceiver = joined.robloxEventReceiver

	local v12 = useRef({})
	local v13 = useRef(Enum.ConnectionState.Connected)

	local v14 = useLocalization({
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		removedFromConversationToastTitle = "Feature.Chat.Message.RemovedFromConversation"
	})

	local networkErrorText = v14.networkErrorText
	local removedFromConversationToastTitle = v14.removedFromConversationToastTitle

	local v15 = useCallback(function(p2: string, p3)
		assert(v12.current, "table")
		v12.current[p2] = p3
	end, { v12.current })

	local v16 = useCallback(function()
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
		local v17 = robloxEventReceiver:observeEvent("ChatNotifications", function(data, p2, _)
			v15("ChatNotifications", data.SequenceNumber)
			local kind = data.Type or p2
			v:info("Received chat notification: {}", kind)

			local conversationId = data.ConversationId and tostring(data.ConversationId) or ""

			if kind == "RemovedFromConversation" or kind == "ConversationRemoved" then
				fn9(conversationId) -- inferred equivalent call
				local activeConversationId = joined.activeConversationId

				if
					activeConversationId ~= nil
					and tostring(activeConversationId) == conversationId
					and joined.rnBypassActionSignal
				then
					joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = v5 == formFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
					}))
				end

				if kind == "RemovedFromConversation" then
					joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = EnumScreens.RoactChatToast,
						params = {
							toastProps = {
								toastContent = { toastTitle = removedFromConversationToastTitle }
							}
						}
					}))
				end
			elseif kind == "ConversationTitleChanged" or kind == "ParticipantAdded" or kind == "ParticipantLeft" then
				task.spawn(function()
					fn3(conversationId):andThen(function(data2) -- inferred equivalent call
						local title = data2.title
						local lastUpdated = data2.lastUpdated

						if kind == "ConversationTitleChanged" then
							fn10(conversationId, title, data2.isDefaultTitle, lastUpdated) -- inferred equivalent call
						else
							fn(conversationId, data2.participants, title, lastUpdated) -- inferred equivalent call
						end
					end):catch(function(p3)
						v:warning(`NetworkingChat failure in RobloxEventReceiver->{kind}, Status: {tostring(p3)}`)
					end)
				end)
			elseif kind == "AddedToConversation" or kind == "NewConversation" then
				if empty then
					v:debug(`Received {kind} event while loading conversation data`)
				else
					task.spawn(function()
						fn3(conversationId):catch(function(p3) -- inferred equivalent call
							v:warning(`NetworkingChat failure in RobloxEventReceiver->{kind}, Status: {tostring(p3)}`)
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

				fn6(conversationId, false, tick()) -- inferred equivalent call
			elseif kind == "NewMessageBySelf" then
				fn6(conversationId, true, tick()) -- inferred equivalent call
			elseif kind == "ParticipantTyping" then
				fn7(conversationId, tostring(data.UserId)) -- inferred equivalent call
			end
		end)

		return function()
			if v17 and v17.disconnect then
				v17:disconnect()
			end
		end
	end, { v11, v15, joined.activeConversationId, joined.rnBypassActionSignal, empty, v5, v6 })

	useEffect(function()
		if not v8 and joined.activeConversationId and joined.rnBypassActionSignal then
			v:debug("Chat is disabled for our user, navigating away from active conversation")
			joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v5 == formFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, { v8 })
	local v17

	if joined.activeConversationId then
		v17 = v4[joined.activeConversationId]
	else
		v17 = nil
	end

	useEffect(function()
		if not v9 and v17 and joined.rnBypassActionSignal and v17.type == "group" then
			v:debug("Group chats are disabled and we are navigated to a group chat. Navigating to ChatLanding")

			joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v5 == formFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, { v9, v17 })

	local function fn11(userId, newAlias) -- 1 equivalent call inferred from this helper
		v11(RoduxAliases.Actions.AliasUpdated(userId, newAlias))
	end

	useEffect(function()
		local v18 = robloxEventReceiver:observeEvent("UserTagChangeNotification", function(data, _)
			if data.Type == "UserTagUpdate" then
				fn11(tostring(data.UserId), data.NewAlias) -- inferred equivalent call
			end
		end)

		return function()
			if v18 and v18.disconnect then
				v18:disconnect()
			end
		end
	end, { v11 })

	useEffect(function()
		local v18 = robloxEventReceiver:observeEvent("FriendshipNotifications", function(p2, _)
			local kind = p2.Type
			v:info("Received friendship notification: {}", kind)

			if kind == "FriendshipCreated" then
				fn8() -- inferred equivalent call
			elseif kind == "FriendshipDestroyed" then
				local v18 = nil

				if p2.EventArgs then
					local userId = tostring(p2.EventArgs.UserId1)
					local userId2 = tostring(p2.EventArgs.UserId2)

					if userId == v7 then
						v18 = userId2
						userId = "localUserId"
					end

					if userId2 == v7 then
						v18 = userId
						userId2 = "localUserId"
					end

					v11(FriendshipDestroyed({ userId1 = userId, userId2 = userId2 }))
				end

				if
					v17
					and v17.source == "friends"
					and v17.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION
					and Cryo.List.findWhere(v17.participants, function(p3): boolean
						return p3 == v18
					end)
				then
					local routeName

					if v5 == formFactor.WIDE then
						routeName = EnumScreens.EmptyConversation
					else
						routeName = EnumScreens.ChatLanding
					end

					joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = routeName
					}))
				end
			end
		end)

		return function()
			if v18 and v18.disconnect then
				v18:disconnect()
			end
		end
	end, { v11, fn8, v7, v5, v17, joined.rnBypassActionSignal })

	useEffect(function()
		local v18 = robloxEventReceiver:observeEvent("ChatMigration", function(data, _)
			local kind = data.Type
			v:info("Received chat migration notification: {}", kind)
			local v18, conversationId

			if kind == "ConversationBackfilled" then
				v18 = data.ConversationId
				conversationId = data.ChannelId
			elseif kind == "ConversationReset" then
				v18 = data.ChannelId
				conversationId = data.ConversationId
			else
				v:warning(`ChatEventReceiver: unknown notification {kind}`)
				return
			end

			v11(RemovedConversation(v18))
			fn3(conversationId):catch(function(p2) -- inferred equivalent call
				v:warning(`NetworkingChat failure in RobloxEventReceiver->{kind}, Status: {tostring(p2)}`)
			end)

			if
				joined.activeConversationId
				and v18
				and tostring(joined.activeConversationId) == v18
				and joined.rnBypassActionSignal
			then
				joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
					routeName = EnumScreens.ChatConversation,
					params = { conversationId = conversationId }
				}))
			end
		end)

		return function()
			if v18 and v18.disconnect then
				v18:disconnect()
			end
		end
	end, { v11, joined.activeConversationId, joined.rnBypassActionSignal, fn3 })

	local v18 = useCallback(function()
		if v3 then
			fn2():andThen(function(flag: boolean) -- inferred equivalent call
				if flag then
					v:trace("Chat is enabled for our user, refreshing conversations")
					fn8() -- inferred equivalent call
					task.spawn(function()
						fn4() -- inferred equivalent call
					end)

					if not FFlagAppChatPresenceStoreMigration then
						fn5()
					end
				else
					v:trace("Chat is disabled for our user, no need to refresh conversations")
				end
			end)
		end
	end, { v3, fn8, fn4, fn5, fn2 })

	local function fn12(current) -- 1 equivalent call inferred from this helper
		v11(SetConnectionState(current))
	end

	useEffect(function()
		local v19 = robloxEventReceiver:observeEvent("signalR", function(current, _, p2)
			v:info("SignalR connection state transitioned to {}", (tostring(current)))

			if not FFlagRemoveUnusedConnectionStateRoduxSlice then
				fn12(current) -- inferred equivalent call
			end

			v13.current = current

			if
				current == Enum.ConnectionState.Connected
				and p2
				and (v12.current == nil or v12.current.ChatNotifications ~= p2.ChatNotifications or v12.current.CommunicationChannels ~= p2.CommunicationChannels)
			then
				v:trace(
					"We missed some messages while we were disconnected. The chat app was previously {}",
					v3 and "loaded" or "unloaded"
				)

				v18()
			end
		end)

		return function()
			if v19 and v19.disconnect then
				v19:disconnect()
			end
		end
	end, { v11, v13, v12, v16, v3 })

	useEffect(function()
		local v19 = robloxEventReceiver:observeEvent("CommunicationChannels", function(data, _)
			if not (data.ChannelVertical == "PlatformChat" and table.find(
				CommunicationChannelsTypes.ChannelTypeAllowlist,
				data.ChannelType
			)) then
				return
			end

			v:info("Received channels notification: {}", data.Type)

			v15("CommunicationChannels", data.SequenceNumber)

			local channelId = data.ChannelId

			if data.Type == "ChannelDeleted" or data.Type == "RemovedFromChannel" or data.Type == "ChannelArchived" then
				fn9(channelId) -- inferred equivalent call
				local activeConversationId = joined.activeConversationId

				if
					activeConversationId ~= nil
					and tostring(activeConversationId) == data.ChannelId
					and joined.rnBypassActionSignal
				then
					local routeName

					if v5 == formFactor.WIDE then
						routeName = EnumScreens.EmptyConversation
					else
						routeName = EnumScreens.ChatLanding
					end

					joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = routeName
					}))
				end

				if data.Actor.Id ~= tostring(v7) then
					joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
						routeName = EnumScreens.RoactChatToast,
						params = {
							toastProps = {
								toastContent = { toastTitle = removedFromConversationToastTitle }
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
					fn3(channelId):andThen(function(data2) -- inferred equivalent call
						local title = data2.title
						local lastUpdated = data2.lastUpdated

						if data.Type == "ChannelUpdated" then
							fn10(channelId, title, data2.isDefaultTitle, lastUpdated) -- inferred equivalent call
						else
							fn(channelId, data2.participants, title, lastUpdated) -- inferred equivalent call
						end
					end):catch(function(p2)
						v:warning(`Failure in RobloxEventReceiver->{data.Type}, Status: {tostring(p2)}`)
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
					v:debug("Received {} event while loading conversation data", data.Type)
				else
					task.spawn(function()
						fn3(channelId):andThen(function(data2) -- inferred equivalent call
							local oldFriendConversationId = (data.Type == "ChannelCreated" or data.Type == "ChannelUnarchived")
								and data2.type == "one_to_one"
								and ConversationChannels.getFriendConversationId(data2.participants)

							if oldFriendConversationId then
								v11(FriendConversationCreated({
									newConversationId = data2.id,
									oldFriendConversationId = oldFriendConversationId
								}))

								if joined.activeConversationId == oldFriendConversationId then
									joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
										routeName = EnumScreens.ChatConversation,
										params = { conversationId = data2.id }
									}))
								end
							end
						end):catch(function(p2)
							v:warning("Failure in RobloxEventReceiver->{}, Status: {}", data.Type, (tostring(p2)))
						end)
					end)
				end
			elseif data.Type == "MessageCreated" or data.Type == "SystemMessageCreated" then
				if not FFlagAppChatPerfTracking then
					fn6(channelId, data.Actor.Id == tostring(v7), tick()) -- inferred equivalent call
					return
				end

				local v19 = data.Actor.Id == tostring(v7)

				if not v19 and joined.activeConversationId and tostring(joined.activeConversationId) == channelId then
					restartMessageReceiveTracking(channelId)
				end

				fn6(channelId, v19, tick()) -- inferred equivalent call
			elseif data.Type == "ParticipantTyping" and data.IsTyping then
				fn7(channelId, data.Actor.Id) -- inferred equivalent call
			end
		end)

		return function()
			if v19 and v19.disconnect then
				v19:disconnect()
			end
		end
	end, {
		v7,
		robloxEventReceiver,
		v15,
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
		v18
	})

	local v19 = useMemo(function()
		if v4 then
			return (Cryo.List.filterMap(Cryo.Dictionary.values(v4), function(p2)
				if p2 and p2.id and p2.source ~= "friends" then
					return p2.id
				end

				return nil
			end))
		end

		return {}
	end, { v4 })
	useEffect(function()
		local v20 = robloxEventReceiver:observeEvent("ChatModerationTypeEligibility", function(p2, _)
			v:debug("Received ChatModerationTypeEligibility notification")
			local channels_inspected = p2.channels_inspected

			if not channels_inspected or #channels_inspected == 0 then
				return
			end

			if getFFlagDebugUnfilteredThreads() then
				local v20 = ""

				for _, v21 in channels_inspected do
					v20 = `{v20}, {v21}`
				end

				chunkAndLogString(`RTN CONVERSATIONS INSPECTED{v20}`)
			end

			local filtered = Cryo.List.filter(channels_inspected, function(p3)
				return table.find(v19, p3)
			end)

			if #filtered == 0 then
				v:debug("No filtered existing conversation IDs found in ChatModerationTypeEligibility notification")

				return
			end

			if getFFlagDebugUnfilteredThreads() then
				local v20 = ""

				for _, v21 in filtered do
					v20 = `{v20}, {v21}`
				end

				chunkAndLogString(`RTN FILTERED CONVERSATIONS{v20}`)
			end

			v11(multiGetConversationDetails(filtered)):catch(function(p3)
				v:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->MultiGetConversationDetails, Status: " .. tostring(p3))
			end)

			if not joined.activeConversationId then
				return
			end

			if table.find(channels_inspected, joined.activeConversationId) then
				v11(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ joined.activeConversationId })):catch(function(p3)
					v:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->GetConversationsParticipantsMetadata, Status: " .. tostring(p3))
				end)
				v11(refreshConversationUnfilteredThreadsDetails(joined.activeConversationId, v10))
			end
		end)

		return function()
			if v20 and v20.disconnect then
				v20:disconnect()
			end
		end
	end, { v11, joined.activeConversationId, v19 })

	useEffect(function()
		local v20 = robloxEventReceiver:observeEvent("EligibilityStatusChanged", function(_, _)
			v:info("Received EligibilityStatusChanged notification")

			v11(AppChatNetworking.rodux.GetChatLandingModal.API(v10)):catch(function(p2)
				v:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p2)))
			end)
		end)

		return function()
			if v20 and v20.disconnect then
				v20:disconnect()
			end
		end
	end, { v11 })

	useChatTrustedConnectionsEvents({ activeConversationId = joined.activeConversationId })

	return {}
end

return ChatEventReceiver
