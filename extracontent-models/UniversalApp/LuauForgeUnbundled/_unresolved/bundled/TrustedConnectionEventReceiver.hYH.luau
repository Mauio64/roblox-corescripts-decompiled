local MessageBusService = game:GetService("MessageBusService")
local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/hYI")

local React = require(CorePackages.Packages.React)
local module2 = require("@luauforge/bundled/dPI")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local v5 = module2.TrustedConnections.TrustedConnectionsStore.get()

local analytics = require("@luauforge/bundled/elw").Analytics
local useTCAnalytics = analytics.useTCAnalytics
local eventNames = analytics.EventNames

local messageId = MessageBusService:GetMessageId("ToastNotifications", "TrustedConnectionRequestReceived")

local function TrustedConnectionEventReceiver()
	local fireAnalyticsEvent = useTCAnalytics().fireAnalyticsEvent

	local v6 = useLocalization({
		somethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong",
		isATrustedFriendNowToast = "Feature.Friends.TrustedFriend.Toast.IsATrustedFriendNow"
	})

	React.useEffect(function()
		local connection = MessageBusService:Subscribe(messageId, function(p2)
			v5.acceptTrustedConnectionRequest(p2.senderUserId):andThen(function()
				fireAnalyticsEvent(eventNames.TCToastNotificationAcceptClicked, {
					friendId = p2.senderUserId
				})

				module.SetUIBloxToast({
					sequenceNumber = DateTime.now().UnixTimestamp,
					toastTitle = string.gsub(v6.isATrustedFriendNowToast, "{name}", p2.senderName)
				})
			end):catch(function(p3)
				module.SetUIBloxToast({
					sequenceNumber = DateTime.now().UnixTimestamp,
					toastTitle = v6.somethingIsWrongToast
				})
			end)
		end, false, true)

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { v6.somethingIsWrongToast, fireAnalyticsEvent, v6.isATrustedFriendNowToast })
end

return TrustedConnectionEventReceiver
