local parent = script.Parent
local parent2 = parent.Parent
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local React = require(parent2.React)
local LifecycleEvents = require(script.Parent.utils.LifecycleEvents)
local kind = require(parent.type)
local notificationTypeEnum = kind.NotificationTypeEnum
local GuiObjectUtils = require(parent2.GuiObjectUtils)

local useProperty = GuiObjectUtils.useProperty

local function InGameToastNotificationActionEventReceiver()
	local v = useProperty(Players, "LocalPlayer")

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.FriendRequestReceived,
			function(data)
				if data and data.userActionType == "click" and data.notificationData and data.visualItem then
					local senderUserId = HttpService:JSONDecode(data.visualItem.actionEventParams).senderUserId

					if senderUserId and v then
						local playerByUserId = Players:GetPlayerByUserId((tonumber(senderUserId)))

						if data.visualItem.eventName == "AcceptFriend" then
							v:RequestFriendship(playerByUserId)
						elseif data.visualItem.eventName == "IgnoreFriend" then
							v:RevokeFriendship(playerByUserId)
						end
					end
				end
			end
		)

		return function()
			callback()
		end
	end, { v })
end

return InGameToastNotificationActionEventReceiver
