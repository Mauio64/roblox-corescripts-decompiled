local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RealtimeDelivery")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local dependencyArray = RoactUtils.Hooks.dependencyArray
local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useLocalization = Localization.Hooks.useLocalization
local useMemo = React.useMemo
local useRef = React.useRef
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local formFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FormFactor").Enums.FormFactor
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("AppChat.Realtime.ChatEventReceiver2")

local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local ChangedParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ChangedParticipants")
local RoduxAliases = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxAliases")
local ReceivedUserTyping = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedUserTyping")
local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")
local RenamedGroupConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RenamedGroupConversation")
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
local useChatTrustedConnectionsEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/useChatTrustedConnectionsEvents")
local getFFlagDebugUnfilteredThreads = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").getFFlagDebugUnfilteredThreads
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

function LUAUFORGE_MODULE_GLOBALS_hbs_ChatEventReceiver2(p2)
	useEffect(function()
		v5:info("ChatEventReceiver2 mounted")
		return function()
			v5:info("ChatEventReceiver2 unmounted")
		end
	end, {})
	local v7

	if FFlagAppChatUseSignalsForAppLoaded then
		v7 = useSignalState(GetAppLoadedStore(false).getAppLoaded)
	else
		v7 = useSelector(function(p3)
			return p3.ChatAppReducer.AppLoaded
		end)
	end

	local v8 = useSelector(function(p3)
		return p3.ChatAppReducer.Conversations
	end)

	local v9 = useSelector(function(p3)
		return p3.FormFactor
	end)

	local empty = Cryo.isEmpty(v8)
	local v10 = useLocalUserId()
	local v11 = useIsChatEnabled()
	local v12 = useIsGroupChatEnabled()
	local v13 = useIsInExperience()

	local v14 = useDispatch()
	local function fn(p3, p4, p5, p6)
		v14(ChangedParticipants(p3, p4, p5, p6))
	end
	local function fn2()
		return v14(fetchChatMetadata())
	end

	local function fn3(p3)
		return v14(fetchLatestConversationDetails(p3))
	end

	local function fn4()
		v14(getAllFriendsAsync())
	end

	local fn5 = not FFlagAppChatPresenceStoreMigration and function()
		spawn(function()
			v14(getAllUserPresences())
		end)
	end or nil

	local function fn6(p3, p4, p5)
		return v14(getNewMessages(p3, p4, p5))
	end

	local function restartMessageReceiveTracking(channelId)
		if not FFlagAppChatPerfTracking then
			return
		end

		local v15 = { conversationId = tostring(channelId) }

		if FFlagAppChatMessageTTIMilestones then
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveTTI, v15)
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageReceiveTTI, v15)
		else
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveToRender, v15)
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageReceiveToRender, v15)
		end
	end
	local function fn7(p3, p4)
		v14(RoduxAliases.Actions.AliasUpdated(p3, p4))
	end
	local function fn8(p3, p4)
		v14(ReceivedUserTyping(p3, p4))
	end

	local function fn9()
		v14(paginateAndRefreshConversations())
	end

	local function fn10(p3)
		v14(RemovedConversation(p3))
	end
	local function fn11(p3, p4, p5, p6)
		v14(RenamedGroupConversation(p3, p4, p5, p6))
	end

	local joined = Cryo.Dictionary.join(v6, p2)
	local v15 = useRef({})

	local v16 = useLocalization({
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		removedFromConversationToastTitle = "Feature.Chat.Message.RemovedFromConversation"
	})

	local networkErrorText = v16.networkErrorText
	local removedFromConversationToastTitle = v16.removedFromConversationToastTitle

	local v17 = useCallback(function(p3, p4)
		assert(v15.current, "table")
		v15.current[p3] = p4
	end, { v15.current })

	local v18 = useCallback(function()
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
		if not v11 and joined.activeConversationId and joined.rnBypassActionSignal then
			v5:debug("Chat is disabled for our user, navigating away from active conversation")
			joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v9 == formFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, { v11, v9, joined.activeConversationId, joined.rnBypassActionSignal })

	local v19 = if joined.activeConversationId then v8[joined.activeConversationId] else nil
	useEffect(function()
		if not v12 and v19 and joined.rnBypassActionSignal and v19.type == "group" then
			v5:debug("Group chats are disabled and we are navigated to a group chat. Navigating to ChatLanding")

			joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
				routeName = v9 == formFactor.WIDE and EnumScreens.EmptyConversation or EnumScreens.ChatLanding
			}))
		end
	end, { v12, v19, v9, joined.rnBypassActionSignal })

	RealtimeDelivery.useRealtimeNamespace("UserTagChangeNotification", function(data)
		v5:info("Received UserTagChangeNotification: {}", data.Type)

		if data.Type == "UserTagUpdate" then
			local userId = tostring(data.UserId)
			local newAlias = data.NewAlias
			v14(RoduxAliases.Actions.AliasUpdated(userId, newAlias))
		end
	end, dependencyArray(fn7))

	RealtimeDelivery.useRealtimeNamespace("FriendshipNotifications", function(p3)
		local kind = p3.Type
		v5:info("Received FriendshipNotifications notification: {}", kind)

		if kind == "FriendshipCreated" then
			v14(paginateAndRefreshConversations())
		elseif kind == "FriendshipDestroyed" then
			local v20 = nil

			if p3.EventArgs then
				local v21 = tostring(p3.EventArgs.UserId1)
				local v22 = tostring(p3.EventArgs.UserId2)

				if v21 == v10 then
					v20 = v22
					v21 = "localUserId"
				end

				if v22 == v10 then
					v20 = v21
					v22 = "localUserId"
				end

				v14(FriendshipDestroyed({ userId1 = v21, userId2 = v22 }))
			end

			if
				v19
				and v19.source == "friends"
				and v19.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION
				and Cryo.List.findWhere(v19.participants, function(p4): boolean
					return p4 == v20
				end)
			then
				local v21 = if v9 == formFactor.WIDE then EnumScreens.EmptyConversation else EnumScreens.ChatLanding
				joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
					routeName = v21
				}))
			end
		end
	end, dependencyArray(v14, fn9, v10, v9, v19, joined.rnBypassActionSignal))

	local v20 = useCallback(function()
		if v7 then
			v14(fetchChatMetadata()):andThen(function(p3)
				if p3 then
					v5:trace("Chat is enabled for our user, refreshing conversations")
					v14(paginateAndRefreshConversations())

					task.spawn(function()
						v14(getAllFriendsAsync())
					end)

					if not FFlagAppChatPresenceStoreMigration then
						fn5()
					end
				else
					v5:trace("Chat is disabled for our user, no need to refresh conversations")
				end
			end)
		end
	end, { v7, fn9, fn4, fn5, fn2 })

	RealtimeDelivery.useRealtimeConnectionStateChanged("CommunicationChannels", function(p3, p4)
		v5:info("CommunicationChannels connection state transitioned to {}", (tostring(p3)))

		if p3 == Enum.ConnectionState.Disconnected then
			v5:info("CommunicationChannels disconnected, show network error toast.")
			v18()
		elseif p3 == Enum.ConnectionState.Connected and p4 then
			v5:trace(
				"We missed some messages while we were disconnected. The chat app was previously {}",
				v7 and "loaded" or "unloaded"
			)

			v20()
		end
	end, dependencyArray(v20, v7, v18))

	RealtimeDelivery.useRealtimeNamespace("CommunicationChannels", function(data)
		if not (data.ChannelVertical == "PlatformChat" and table.find(CommunicationChannelsTypes.ChannelTypeAllowlist, data.ChannelType)) then
			return
		end

		v5:info("Received CommunicationChannels notification: {}", data.Type)

		v17("CommunicationChannels", data.SequenceNumber)

		local channelId = data.ChannelId

		if
			data.Type == "ChannelDeleted"
			or data.Type == "RemovedFromChannel"
			or data.Type == "ChannelArchived"
		then
			v14(RemovedConversation(channelId))

			local activeConversationId = joined.activeConversationId

			if
				activeConversationId ~= nil
				and tostring(activeConversationId) == data.ChannelId
				and joined.rnBypassActionSignal
			then
				local v21 = if v9 == formFactor.WIDE then EnumScreens.EmptyConversation else EnumScreens.ChatLanding
				joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
					routeName = v21
				}))
			end

			if data.Actor.Id ~= tostring(v10) then
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
				v14(fetchLatestConversationDetails(channelId)):andThen(function(data2)
					local title = data2.title
					local lastUpdated = data2.lastUpdated

					if data.Type == "ChannelUpdated" then
						v14(RenamedGroupConversation(channelId, title, data2.isDefaultTitle, lastUpdated))
					else
						v14(ChangedParticipants(channelId, data2.participants, title, lastUpdated))
					end
				end):catch(function(p3)
					v5:warning(`Failure in RobloxEventReceiver->{data.Type}, Status: {tostring(p3)}`)
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
					v14(fetchLatestConversationDetails(channelId)):andThen(function(data2)
						local v21 = (data.Type == "ChannelCreated" or data.Type == "ChannelUnarchived")
							and data2.type == "one_to_one"
							and ConversationChannels.getFriendConversationId(data2.participants)

						if v21 then
							v14(FriendConversationCreated({
								newConversationId = data2.id,
								oldFriendConversationId = v21
							}))

							if joined.activeConversationId == v21 then
								joined.rnBypassActionSignal:fire(RoactNavigation.Actions.navigate({
									routeName = EnumScreens.ChatConversation,
									params = { conversationId = data2.id }
								}))
							end
						end
					end):catch(function(p3)
						v5:warning(
							"Failure in RobloxEventReceiver->{}, Status: {}",
							data.Type,
							(tostring(p3))
						)
					end)
				end)
			end
		elseif data.Type == "MessageCreated" or data.Type == "SystemMessageCreated" then
			if FFlagAppChatPerfTracking then
				local v21 = data.Actor.Id == tostring(v10)

				if
					not v21
					and joined.activeConversationId
					and tostring(joined.activeConversationId) == channelId
				then
					restartMessageReceiveTracking(channelId)
				end

				v14(getNewMessages(channelId, v21, (tick())))
			else
				v14(getNewMessages(channelId, data.Actor.Id == tostring(v10), (tick())))
			end
		elseif data.Type == "ParticipantTyping" and data.IsTyping then
			v14(ReceivedUserTyping(channelId, data.Actor.Id))
		end
	end, dependencyArray(
		v10,
		v17,
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

	local v21 = useMemo(function()
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
	RealtimeDelivery.useRealtimeNamespace("ChatModerationTypeEligibility", function(p3)
		v5:debug("Received ChatModerationTypeEligibility notification")
		local channels_inspected = p3.channels_inspected

		if not channels_inspected or #channels_inspected == 0 then
			return
		end

		if getFFlagDebugUnfilteredThreads() then
			local v22 = ""

			for k, v23 in channels_inspected do
				v22 = `{v22}, {v23}`
			end

			chunkAndLogString(`RTN CONVERSATIONS INSPECTED{v22}`)
		end

		local filtered = Cryo.List.filter(channels_inspected, function(p4)
			return table.find(v21, p4)
		end)

		if #filtered == 0 then
			v5:debug("No filtered existing conversation IDs found in ChatModerationTypeEligibility notification")

			return
		end

		if getFFlagDebugUnfilteredThreads() then
			local v22 = ""

			for k, v23 in filtered do
				v22 = `{v22}, {v23}`
			end

			chunkAndLogString(`RTN FILTERED CONVERSATIONS{v22}`)
		end

		v14(multiGetConversationDetails(filtered)):catch(function(p4)
			v5:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->MultiGetConversationDetails, Status: " .. tostring(p4))
		end)

		if not joined.activeConversationId then
			return
		end

		if table.find(channels_inspected, joined.activeConversationId) then
			v14(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ joined.activeConversationId })):catch(function(p4)
				v5:warning("NetworkingChat failure in " .. "ChatEventReceiver->ChatModerationTypeEligibility->GetConversationsParticipantsMetadata, Status: " .. tostring(p4))
			end)
			v14(refreshConversationUnfilteredThreadsDetails(joined.activeConversationId, v13))
		end
	end, dependencyArray(v14, joined.activeConversationId, v21))

	RealtimeDelivery.useRealtimeNamespace("EligibilityStatusChanged", function(p3)
		v5:info("Received EligibilityStatusChanged notification")

		v14(AppChatNetworking.rodux.GetChatLandingModal.API(v13)):catch(function(p4)
			v5:warning(
				"NetworkingChat failure in ChatEventReceiver->EligibilityStatusChanged->GetChatLandingModal request. Status: {}",
				(tostring(p4))
			)
		end)
	end, dependencyArray(v14, v13))

	useChatTrustedConnectionsEvents({ activeConversationId = joined.activeConversationId })

	return {}
end

return LUAUFORGE_MODULE_GLOBALS_hbs_ChatEventReceiver2
