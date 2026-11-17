local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local AppChatNetworking = require(parent.AppChatNetworking)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local EventNames = require(AppChat.Analytics.EventNames)
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useRealtimePlatformChat = require(script.Parent.useRealtimePlatformChat)
local useUnreadMessagesDispatch = require(AppChat.Contexts.UnreadMessages.useUnreadMessagesDispatch)
local useChatIsVisible = require(AppChat.Hooks.useChatIsVisible)
local InExperienceAppChatModal = require(AppChat.App.InExperienceAppChatModal)

local GetUnreadMessageCountStore = require(AppChat.Stores.GetUnreadMessageCountStore)

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local function AppChatNotificationEventReceiver(p): nil
	local v2 = useAnalytics()

	local v3 = useUnreadMessagesDispatch()
	local v4 = useDispatch()
	local v5 = useSignalState(GetUnreadMessageCountStore(false).getUnreadMessageCount)

	local v6 = useChatIsVisible()
	local state, setState = React.useState(function()
		return InExperienceAppChatModal:getVisible()
	end)

	React.useEffect(function()
		local eventConnection = InExperienceAppChatModal.default.visibilitySignal.Event:Connect(setState)
		setState(InExperienceAppChatModal:getVisible())
		return function()
			eventConnection:Disconnect()
		end
	end, {})

	if not p.isInExperience then
		state = v6
	end

	React.useEffect(function()
		v:debug("Fetching conversation metadata to get unread count")

		v4(AppChatNetworking.rodux.GetConversationMetadata.API()):andThen(function(p2)
			local global_unread_message_count = p2.responseBody.global_unread_message_count
			v:info("Initial unread message count: {}", global_unread_message_count)

			if p.isInExperience then
				InExperienceAppChatModal:markInitialUnreadCountReceived(global_unread_message_count or 0)
			end

			v2.fireAnalyticsEvent(EventNames.preloadSocialTabDataEvent, {
				unreadConversationCount = global_unread_message_count
			})
		end):catch(function(p2)
			v:error("Failure in GetConversationMetadata. Error: {}", (tostring(p2)))
			v2.fireAnalyticsEvent(EventNames.preloadSocialTabDataFailedEvent, {})
		end)
	end, { v4, v2 })

	React.useEffect(function()
		v:info("Dispatching unread messsage count as {}", v5)
		v3(v5)
	end, { v3, v5 })

	useRealtimePlatformChat(function(p2)
		if p2.Type == "ChannelMetadataUpdated" or p2.Type == "ChannelMarkedRead" then
			v:info("Received event {}, fetching conversation metadata to get unread count", p2.Type)

			if state then
				v:info("Chat tab is visible during realtime event, calling clear endpoint")
				v4(AppChatNetworking.rodux.ClearGlobalUnreadCount.API()):catch(function(p3)
					v:error("Failure in ClearGlobalUnreadCount. Error: {}", (tostring(p3)))
				end)
			else
				v4(AppChatNetworking.rodux.GetConversationMetadata.API()):catch(function(p3)
					v:error("Failure in GetConversationMetadata. Error: {}", (tostring(p3)))
				end)
			end
		end
	end, { v4, state })

	RealtimeDelivery.useRealtimeConnectionStateChanged("CommunicationChannels", function(p2, p3)
		if p2 == Enum.ConnectionState.Connected and p3 then
			v:info("Connection re-established, fetching conversation metadata to get unread count")

			if state then
				v:info("Chat tab is visible during connection recovery, calling clear endpoint")
				v4(AppChatNetworking.rodux.ClearGlobalUnreadCount.API()):catch(function(p4)
					v:error("Failure in ClearGlobalUnreadCount. Error: {}", (tostring(p4)))
				end)
			else
				v4(AppChatNetworking.rodux.GetConversationMetadata.API()):catch(function(p4)
					v:error("Failure in GetConversationMetadata. Error: {}", (tostring(p4)))
				end)
			end
		end
	end, { v4, state })

	return nil
end

return React.memo(AppChatNotificationEventReceiver)
