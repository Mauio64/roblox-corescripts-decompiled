local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
local LifecycleEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/LifecycleEvents")
local notificationTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type").NotificationTypeEnum
local useProperty = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/GuiObjectUtils").useProperty

local function InGameToastNotificationActionEventReceiver()
	local v5 = useProperty(Players, "LocalPlayer")

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.FriendRequestReceived,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
				then
					local senderUserId = HttpService:JSONDecode(data.visualItem.actionEventParams).senderUserId

					if senderUserId and v5 then
						local playerByUserId = Players:GetPlayerByUserId((tonumber(senderUserId)))

						if data.visualItem.eventName == "AcceptFriend" then
							v5:RequestFriendship(playerByUserId)
						elseif data.visualItem.eventName == "IgnoreFriend" then
							v5:RevokeFriendship(playerByUserId)
						end
					end
				end
			end
		)

		return function()
			callback()
		end
	end, { v5 })
end

return InGameToastNotificationActionEventReceiver
