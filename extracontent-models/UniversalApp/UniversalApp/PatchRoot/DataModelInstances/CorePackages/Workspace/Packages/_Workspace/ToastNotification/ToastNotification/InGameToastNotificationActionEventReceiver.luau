local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local React = require(scriptParentParent.React)
local LifecycleEvents = require(script.Parent.utils.LifecycleEvents)
local NotificationTypeEnum = require(scriptParent.type).NotificationTypeEnum
local useProperty = require(scriptParentParent.GuiObjectUtils).useProperty

local function InGameToastNotificationActionEventReceiver() -- line: 18
	-- upvalues: useProperty (copy), Players (copy), React (copy), LifecycleEvents (copy), NotificationTypeEnum (copy), HttpService (copy)
	local v10 = useProperty(Players, "LocalPlayer")

	React.useEffect(function() -- line: 21
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), HttpService (copy), v10 (copy), Players (copy)
		local v11 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.FriendRequestReceived, function(p1) -- line: 25
			-- upvalues: HttpService (copy), v10 (copy), Players (copy)
			if p1 and (p1.userActionType == "click" and p1.notificationData and p1.visualItem) then
				local senderUserId = HttpService:JSONDecode(p1.visualItem.actionEventParams).senderUserId

				if senderUserId and v10 then
					local PlayerByUserId = Players:GetPlayerByUserId((tonumber(senderUserId)))

					if p1.visualItem.eventName == "AcceptFriend" then
						v10:RequestFriendship(PlayerByUserId)

						return
					end

					if p1.visualItem.eventName == "IgnoreFriend" then
						v10:RevokeFriendship(PlayerByUserId)
					end
				end
			end
		end)

		return function() -- line: 45
			-- upvalues: v11 (copy)
			v11()
		end
	end, { v10 })
end

return InGameToastNotificationActionEventReceiver
