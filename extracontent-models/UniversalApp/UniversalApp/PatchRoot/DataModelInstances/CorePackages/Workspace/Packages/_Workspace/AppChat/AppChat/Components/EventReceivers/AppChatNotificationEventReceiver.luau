local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local RealtimeDelivery = require(AppChatParent.RealtimeDelivery)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local EventNames = require(AppChat.Analytics.EventNames)
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useRealtimePlatformChat = require(script.Parent.useRealtimePlatformChat)
local useUnreadMessagesDispatch = require(AppChat.Contexts.UnreadMessages.useUnreadMessagesDispatch)
local useChatIsVisible = require(AppChat.Hooks.useChatIsVisible)
local InExperienceAppChatModal = require(AppChat.App.InExperienceAppChatModal)
local FFlagExpChatEnableFriendsTab = require(AppChatParent.SharedFlags).FFlagExpChatEnableFriendsTab
local v15 = require(AppChat.Logger):new(script.Name)

local function AppChatNotificationEventReceiver(t1: {[any]: any}) -- line: 24
	-- upvalues: useAnalytics (copy), useUnreadMessagesDispatch (copy), useDispatch (copy), useSelector (copy), useChatIsVisible (copy), React (copy), InExperienceAppChatModal (copy), FFlagExpChatEnableFriendsTab (copy), v15 (copy), AppChatNetworking (copy), EventNames (copy), useRealtimePlatformChat (copy), RealtimeDelivery (copy)
	local v18 = useAnalytics()
	local v19 = useUnreadMessagesDispatch()
	local v20 = useDispatch()
	local v21 = useSelector(function(p1) -- line: 29
		return p1.ChatAppReducer.unreadMessageCount
	end)
	local v22 = useChatIsVisible()
	local v23, v24 = React.useState(function() -- line: 34
		-- upvalues: InExperienceAppChatModal (copy)
		return InExperienceAppChatModal:getVisible()
	end)

	React.useEffect(function() -- line: 38
		-- upvalues: InExperienceAppChatModal (copy), v24 (copy)
		local connection = InExperienceAppChatModal.default.visibilitySignal.Event:Connect(v24)

		v24(InExperienceAppChatModal:getVisible())

		return function() -- line: 41
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local v25 = if not FFlagExpChatEnableFriendsTab or not t1.isInExperience then v22 else v23

	React.useEffect(function() -- line: 53
		-- upvalues: v15 (copy), v20 (copy), AppChatNetworking (copy), v18 (copy), EventNames (copy)
		v15:debug("Fetching conversation metadata to get unread count")
		v20(AppChatNetworking.rodux.GetConversationMetadata.API()):andThen(function(p2) -- line: 57
			-- upvalues: v15 (copy), v18 (copy), EventNames (copy)
			local global_unread_message_count = p2.responseBody.global_unread_message_count

			v15:info("Initial unread message count: {}", global_unread_message_count)
			v18.fireAnalyticsEvent(EventNames.preloadSocialTabDataEvent, {
				unreadConversationCount = global_unread_message_count
			})
		end):catch(function(p3) -- line: 65
			-- upvalues: v15 (copy), v18 (copy), EventNames (copy)
			v15:error("Failure in GetConversationMetadata. Error: {}", (tostring(p3)))
			v18.fireAnalyticsEvent(EventNames.preloadSocialTabDataFailedEvent, {})
		end)
	end, {
		v20,
		v18
	})
	React.useEffect(function() -- line: 71
		-- upvalues: v15 (copy), v21 (copy), v19 (copy)
		v15:info("Dispatching unread messsage count as {}", v21)
		v19(v21)
	end, {
		v19,
		v21
	})
	useRealtimePlatformChat(function(p4) -- line: 76
		-- upvalues: v15 (copy), v25 (copy), v20 (copy), AppChatNetworking (copy)
		if p4.Type == "ChannelMetadataUpdated" or p4.Type == "ChannelMarkedRead" then
			v15:info("Received event {}, fetching conversation metadata to get unread count", p4.Type)

			if v25 then
				v15:info("Chat tab is visible during realtime event, calling clear endpoint")
				v20(AppChatNetworking.rodux.ClearGlobalUnreadCount.API()):catch(function(p5) -- line: 84
					-- upvalues: v15 (copy)
					v15:error("Failure in ClearGlobalUnreadCount. Error: {}", (tostring(p5)))
				end)

				return
			end

			v20(AppChatNetworking.rodux.GetConversationMetadata.API()):catch(function(p6) -- line: 88
				-- upvalues: v15 (copy)
				v15:error("Failure in GetConversationMetadata. Error: {}", (tostring(p6)))
			end)
		end
	end, {
		v20,
		v25
	})
	RealtimeDelivery.useRealtimeConnectionStateChanged("CommunicationChannels", function(p7, p8) -- line: 98
		-- upvalues: v15 (copy), v25 (copy), v20 (copy), AppChatNetworking (copy)
		if p7 == Enum.ConnectionState.Connected and p8 then
			v15:info("Connection re-established, fetching conversation metadata to get unread count")

			if v25 then
				v15:info("Chat tab is visible during connection recovery, calling clear endpoint")
				v20(AppChatNetworking.rodux.ClearGlobalUnreadCount.API()):catch(function(p9) -- line: 104
					-- upvalues: v15 (copy)
					v15:error("Failure in ClearGlobalUnreadCount. Error: {}", (tostring(p9)))
				end)

				return
			end

			v20(AppChatNetworking.rodux.GetConversationMetadata.API()):catch(function(p10) -- line: 108
				-- upvalues: v15 (copy)
				v15:error("Failure in GetConversationMetadata. Error: {}", (tostring(p10)))
			end)
		end
	end, {
		v20,
		v25
	})

	return nil
end

return React.memo(AppChatNotificationEventReceiver)
