local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Localization = require(parent.Localization)
local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local RoactNavigation = require(parent.RoactNavigation)
local RoactUtils = require(parent.RoactUtils)
local Cryo = require(parent.Cryo)
local AppChatNetworking = require(parent.AppChatNetworking)

local dependencyArray = RoactUtils.Hooks.dependencyArray
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
local v = Logger:new("AppChat.Realtime.ChatEventReceiver2")

local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local ChangedParticipants = require(AppChat.Conversations.Actions.ChangedParticipants)
local RoduxAliases = require(AppChat.Http.RoduxAliases)
local ReceivedUserTyping = require(AppChat.Conversations.Actions.ReceivedUserTyping)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local RenamedGroupConversation = require(AppChat.Conversations.Actions.RenamedGroupConversation)
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
local useChatTrustedConnectionsEvents = require(AppChat.Components.EventReceivers.useChatTrustedConnectionsEvents)
local SharedFlags = require(parent.SharedFlags)
local getFFlagDebugUnfilteredThreads = SharedFlags.getFFlagDebugUnfilteredThreads
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

function ChatEventReceiver2(p)
	useEffect(function()
		v:info("ChatEventReceiver2 mounted")
		return function()
			v:info("ChatEventReceiver2 unmounted")
		end
	end, {})
	local v3

	if FFlagAppChatUseSignalsForAppLoaded then
		v3 = useSignalState(GetAppLoadedStore(false).getAppLoaded)
	else
		v3 = useSelector(function(p2)
			return p2.ChatAppReducer.AppLoaded
		end)
	end

	local v4 = useSelector(function(p2)
		return p2.ChatAppReducer.Conversations
	end)

	local v5 = useSelector(function(p2)
		return p2.FormFactor
	end)

	local empty = Cryo.isEmpty(v4)
	local v6 = useLocalUserId()
	local v7 = useIsChatEnabled()
	local v8 = useIsGroupChatEnabled()
	local v9 = useIsInExperience()

	local v10 = useDispatch()
	local function fn(channelId, participants, title, lastUpdated) -- 1 equivalent call inferred from this helper
		v10(ChangedParticipants(channelId, participants, title, lastUpdated))
	end
	local function fn2() -- 1 equivalent call inferred from this helper
		return v10(fetchChatMetadata())
	end

	local function fn3(channelId) -- 2 equivalent calls inferred from this helper
		return v10(fetchLatestConversationDetails(channelId))
	end

	local function fn4() -- 1 equivalent call inferred from this helper
		v10(getAllFriendsAsync())
	end

	local fn5 = not FFlagAppChatPresenceStoreMigration and function()
		spawn(function()
			v10(getAllUserPresences())
		end)
	end or nil

	local function fn6(channelId, p2, now) -- 2 equivalent calls inferred from this helper
		return v10(getNewMessages(channelId, p2, now))
	end

	local function restartMessageReceiveTracking(channelId: string)
		if not FFlagAppChatPerfTracking then
			return
		end

		local v11 = { conversationId = tostring(channelId) }

		if FFlagAppChatMessageTTIMilestones then
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveTTI, v11)
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageReceiveTTI, v11)
		else
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveToRender, v11)
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageReceiveToRender, v11)
		end
	end
	local function fn7(userId, newAlias) -- 1 equivalent call inferred from this helper
		v10(RoduxAliases.Actions.AliasUpdated(userId, newAlias))
	end
	local function fn8(channelId, id) -- 1 equivalent call inferred from this helper
		v10(ReceivedUserTyping(channelId, id))
	end

	local function fn9() -- 2 equivalent calls inferred from this helper
		v10(paginateAndRefreshConversations())
	end

	local function fn10(channelId) -- 1 equivalent call inferred from this helper
		v10(RemovedConversation(channelId))
	end
	local function fn11(channelId, title, isDefaultTitle, lastUpdated) -- 1 equivalent call inferred from this helper
		v10(RenamedGroupConversation(channelId, title, isDefaultTitle, lastUpdated))
	end

	local joined = Cryo.Dictionary.join(v2, p)
	local v11 = useRef({})

	local v12 = useLocalization({
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		removedFromConversationToastTitle = "Feature.Chat.Message.RemovedFromConversation"
	})

	local networkErrorText = v12.networkErrorText
	local removedFromConversationToastTitle = v12.removedFromConversationToastTitle

	local v13 = useCallback(function(p2: string, p3)
		assert(v11.current, "table")
		v11.current[p2] = p3
	end, { v11.current })

	local v14 = useCallback(function()
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
		if not v7 and joined.activeConversationId and joined.rnBypassActionSignal then
			v:debug("Chat is disabled for our user, navigating away from active conversation")
			joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v5 == formFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, { v7, v5, joined.activeConversationId, joined.rnBypassActionSignal })
	local v15

	if joined.activeConversationId then
		v15 = v4[joined.activeConversationId]
	else
		v15 = nil
	end

	useEffect(function()
		if not v8 and v15 and joined.rnBypassActionSignal and v15.type == "group" then
			v:debug("Group chats are disabled and we are navigated to a group chat. Navigating to ChatLanding")

			joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v5 == formFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, { v8, v15, v5, joined.rnBypassActionSignal })

	RealtimeDelivery.useRealtimeNamespace("UserTagChangeNotification", function(data)
		v:info("Received UserTagChangeNotification: {}", data.Type)

		if data.Type == "UserTagUpdate" then
			fn7(tostring(data.UserId), data.NewAlias) -- inferred equivalent call
		end
	end, dependencyArray(fn7))

	RealtimeDelivery.useRealtimeNamespace("FriendshipNotifications", function(p2)
		local kind = p2.Type
		v:info("Received FriendshipNotifications notification: {}", kind)

		if kind == "FriendshipCreated" then
			fn9() -- inferred equivalent call
		elseif kind == "FriendshipDestroyed" then
			local v16 = nil

			if p2.EventArgs then
				local userId = tostring(p2.EventArgs.UserId1)
				local userId2 = tostring(p2.EventArgs.UserId2)

				if userId == v6 then
					v16 = userId2
					userId = "localUserId"
				end

				if userId2 == v6 then
					v16 = userId
					userId2 = "localUserId"
				end

				v10(FriendshipDestroyed({ userId1 = userId, userId2 = userId2 }))
			end

			if
				v15
				and v15.source == "friends"
				and v15.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION
				and Cryo.List.findWhere(v15.participants, function(p3): boolean
					return p3 == v16
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
	end, dependencyArray(v10, fn9, v6, v5, v15, joined.rnBypassActionSignal))

	local v16 = useCallback(function()
		if v3 then
			fn2():andThen(function(flag: boolean) -- inferred equivalent call
				if flag then
					v:trace("Chat is enabled for our user, refreshing conversations")
					fn9() -- inferred equivalent call
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
	end, { v3, fn9, fn4, fn5, fn2 })

	RealtimeDelivery.useRealtimeConnectionStateChanged("CommunicationChannels", function(p2, p3)
		v:info("CommunicationChannels connection state transitioned to {}", (tostring(p2)))

		if p2 == Enum.ConnectionState.Disconnected then
			v:info("CommunicationChannels disconnected, show network error toast.")
			v14()
		elseif p2 == Enum.ConnectionState.Connected and p3 then
			v:trace(
				"We missed some messages while we were disconnected. The chat app was previously {}",
				v3 and "loaded" or "unloaded"
			)

			v16()
		end
	end, dependencyArray(v16, v3, v14))

	RealtimeDelivery.useRealtimeNamespace("CommunicationChannels", function(data)
		if not (data.ChannelVertical == "PlatformChat" and table.find(
			CommunicationChannelsTypes.ChannelTypeAllowlist,
			data.ChannelType
		)) then
			return
		end

		v:info("Received CommunicationChannels notification: {}", data.Type)

		v13("CommunicationChannels", data.SequenceNumber)

		local channelId = data.ChannelId

		if data.Type == "ChannelDeleted" or data.Type == "RemovedFromChannel" or data.Type == "ChannelArchived" then
			fn10(channelId) -- inferred equivalent call
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

			if data.Actor.Id ~= tostring(v6) then
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
						fn11(channelId, title, data2.isDefaultTitle, lastUpdated) -- inferred equivalent call
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
							v10(FriendConversationCreated({
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
				fn6(channelId, data.Actor.Id == tostring(v6), tick()) -- inferred equivalent call
				return
			end

			local v17 = data.Actor.Id == tostring(v6)

			if not v17 and joined.activeConversationId and tostring(joined.activeConversationId) == channelId then
				restartMessageReceiveTracking(channelId)
			end

			fn6(channelId, v17, tick()) -- inferred equivalent call
		elseif data.Type == "ParticipantTyping" and data.IsTyping then
			fn8(channelId, data.Actor.Id) -- inferred equivalent call
		end
	end, dependencyArray(
		v6,
		v13,
		fn10,
		joined.activeConversationId,
		joined.rnBypassActionSignal,
		removedFromConversationToastTitle,
		fn3,
		fn11,
		fn,
		empty,
		fn6,
		fn8
	))

	local v17 = useMemo(function()
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
	RealtimeDelivery.useRealtimeNamespace("ChatModerationTypeEligibility", function(p2)
		v:debug("Received ChatModerationTypeEligibility notification")
		local channels_inspected = p2.channels_inspected

		if not channels_inspected or #channels_inspected == 0 then
			return
		end

		if getFFlagDebugUnfilteredThreads() then
			local v18 = ""

			for _, v19 in channels_inspected do
				v18 = `{v18}, {v19}`
			end

			chunkAndLogString(`RTN CONVERSATIONS INSPECTED{v18}`)
		end

		local filtered = Cryo.List.filter(channels_inspected, function(p3)
			return table.find(v17, p3)
		end)

		if #filtered == 0 then
			v:debug("No filtered existing conversation IDs found in ChatModerationTypeEligibility notification")

			return
		end

		if getFFlagDebugUnfilteredThreads() then
			local v18 = ""

			for _, v19 in filtered do
				v18 = `{v18}, {v19}`
			end

			chunkAndLogString(`RTN FILTERED CONVERSATIONS{v18}`)
		end

		v10(multiGetConversationDetails(filtered)):catch(function(p3)
			v:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->MultiGetConversationDetails, Status: " .. tostring(p3))
		end)

		if not joined.activeConversationId then
			return
		end

		if table.find(channels_inspected, joined.activeConversationId) then
			v10(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ joined.activeConversationId })):catch(function(p3)
				v:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->GetConversationsParticipantsMetadata, Status: " .. tostring(p3))
			end)
			v10(refreshConversationUnfilteredThreadsDetails(joined.activeConversationId, v9))
		end
	end, dependencyArray(v10, joined.activeConversationId, v17))

	RealtimeDelivery.useRealtimeNamespace("EligibilityStatusChanged", function(_)
		v:info("Received EligibilityStatusChanged notification")

		v10(AppChatNetworking.rodux.GetChatLandingModal.API(v9)):catch(function(p2)
			v:warning(
				"NetworkingChat failure in ChatEventReceiver->EligibilityStatusChanged->GetChatLandingModal request. Status: {}",
				(tostring(p2))
			)
		end)
	end, dependencyArray(v10, v9))

	useChatTrustedConnectionsEvents({ activeConversationId = joined.activeConversationId })

	return {}
end

return ChatEventReceiver2
