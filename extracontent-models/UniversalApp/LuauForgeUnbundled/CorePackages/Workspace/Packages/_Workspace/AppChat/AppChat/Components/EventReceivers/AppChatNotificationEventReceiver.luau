local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RealtimeDelivery")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")
local useRealtimePlatformChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/useRealtimePlatformChat")
local useUnreadMessagesDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/UnreadMessages/useUnreadMessagesDispatch")
local useChatIsVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatIsVisible")
local InExperienceAppChatModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/InExperienceAppChatModal")

local fFlagExpChatEnableFriendsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagExpChatEnableFriendsTab

local GetUnreadMessageCountStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetUnreadMessageCountStore")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("AppChatNotificationEventReceiver")

local function AppChatNotificationEventReceiver(p2): nil
	local v6 = useAnalytics()

	local v7 = useUnreadMessagesDispatch()
	local v8 = useDispatch()
	local v9 = useSignalState(GetUnreadMessageCountStore(false).getUnreadMessageCount)

	local v10 = useChatIsVisible()
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

	if fFlagExpChatEnableFriendsTab and p2.isInExperience then
		v10 = state
	end

	React.useEffect(function()
		v5:debug("Fetching conversation metadata to get unread count")

		v8(AppChatNetworking.rodux.GetConversationMetadata.API()):andThen(function(p3)
			local global_unread_message_count = p3.responseBody.global_unread_message_count
			v5:info("Initial unread message count: {}", global_unread_message_count)

			if fFlagExpChatEnableFriendsTab and p2.isInExperience then
				InExperienceAppChatModal:markInitialUnreadCountReceived(global_unread_message_count or 0)
			end

			v6.fireAnalyticsEvent(EventNames.preloadSocialTabDataEvent, {
				unreadConversationCount = global_unread_message_count
			})
		end):catch(function(p3)
			v5:error("Failure in GetConversationMetadata. Error: {}", (tostring(p3)))
			v6.fireAnalyticsEvent(EventNames.preloadSocialTabDataFailedEvent, {})
		end)
	end, { v8, v6 })

	React.useEffect(function()
		v5:info("Dispatching unread messsage count as {}", v9)
		v7(v9)
	end, { v7, v9 })

	useRealtimePlatformChat(function(p3)
		if p3.Type == "ChannelMetadataUpdated" or p3.Type == "ChannelMarkedRead" then
			v5:info("Received event {}, fetching conversation metadata to get unread count", p3.Type)

			if v10 then
				v5:info("Chat tab is visible during realtime event, calling clear endpoint")
				v8(AppChatNetworking.rodux.ClearGlobalUnreadCount.API()):catch(function(p4)
					v5:error("Failure in ClearGlobalUnreadCount. Error: {}", (tostring(p4)))
				end)
			else
				v8(AppChatNetworking.rodux.GetConversationMetadata.API()):catch(function(p4)
					v5:error("Failure in GetConversationMetadata. Error: {}", (tostring(p4)))
				end)
			end
		end
	end, { v8, v10 })

	RealtimeDelivery.useRealtimeConnectionStateChanged("CommunicationChannels", function(p3, p4)
		if p3 == Enum.ConnectionState.Connected and p4 then
			v5:info("Connection re-established, fetching conversation metadata to get unread count")

			if v10 then
				v5:info("Chat tab is visible during connection recovery, calling clear endpoint")
				v8(AppChatNetworking.rodux.ClearGlobalUnreadCount.API()):catch(function(p5)
					v5:error("Failure in ClearGlobalUnreadCount. Error: {}", (tostring(p5)))
				end)
			else
				v8(AppChatNetworking.rodux.GetConversationMetadata.API()):catch(function(p5)
					v5:error("Failure in GetConversationMetadata. Error: {}", (tostring(p5)))
				end)
			end
		end
	end, { v8, v10 })

	return nil
end

return React.memo(AppChatNotificationEventReceiver)
