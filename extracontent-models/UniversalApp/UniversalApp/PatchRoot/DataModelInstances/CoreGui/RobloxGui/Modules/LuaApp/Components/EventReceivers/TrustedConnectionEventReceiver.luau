local MessageBusService = game:GetService("MessageBusService")
local CorePackages = game:GetService("CorePackages")
local NotificationModalsManager = require(CorePackages.Workspace.Packages.NotificationModalsManager)
local React = require(CorePackages.Packages.React)
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local v7 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()
local Analytics = require(CorePackages.Workspace.Packages.TrustedContacts).Analytics
local useTCAnalytics = Analytics.useTCAnalytics
local EventNames = Analytics.EventNames
local v11 = game:DefineFastFlag("TCNotifFixDependencyArray", false)
local MessageId = MessageBusService:GetMessageId("ToastNotifications", "TrustedConnectionRequestReceived")

local function TrustedConnectionEventReceiver() -- line: 19
	-- upvalues: useTCAnalytics (copy), useLocalization (copy), React (copy), MessageBusService (copy), MessageId (copy), v7 (copy), EventNames (copy), NotificationModalsManager (copy), v11 (copy)
	local fireAnalyticsEvent = useTCAnalytics().fireAnalyticsEvent
	local v15 = useLocalization({
		somethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong",
		isATrustedFriendNowToast = "Feature.Friends.TrustedFriend.Toast.IsATrustedFriendNow"
	})

	React.useEffect(function() -- line: 28
		-- upvalues: MessageBusService (copy), MessageId (copy), v7 (copy), fireAnalyticsEvent (copy), EventNames (copy), NotificationModalsManager (copy), v15 (copy)
		local v16 = MessageBusService:Subscribe(MessageId, function(p1) -- line: 31
			-- upvalues: v7 (copy), fireAnalyticsEvent (copy), EventNames (copy), NotificationModalsManager (copy), v15 (copy)
			v7.acceptTrustedConnectionRequest(p1.senderUserId):andThen(function() -- line: 33
				-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), p1 (copy), NotificationModalsManager (copy), v15 (copy)
				fireAnalyticsEvent(EventNames.TCToastNotificationAcceptClicked, {
					friendId = p1.senderUserId
				})
				NotificationModalsManager.SetUIBloxToast({
					sequenceNumber = DateTime.now().UnixTimestamp,
					toastTitle = string.gsub(v15.isATrustedFriendNowToast, "{name}", p1.senderName)
				})
			end):catch(function(_) -- line: 46
				-- upvalues: NotificationModalsManager (copy), v15 (copy)
				NotificationModalsManager.SetUIBloxToast({
					sequenceNumber = DateTime.now().UnixTimestamp,
					toastTitle = v15.somethingIsWrongToast
				})
			end)
		end, false, true)

		return function() -- line: 57
			-- upvalues: v16 (copy)
			if v16 then
				v16:Disconnect()
			end
		end
	end, {
		v15.somethingIsWrongToast,
		fireAnalyticsEvent,
		if not v11 then nil else v15.isATrustedFriendNowToast
	})
end

return TrustedConnectionEventReceiver
