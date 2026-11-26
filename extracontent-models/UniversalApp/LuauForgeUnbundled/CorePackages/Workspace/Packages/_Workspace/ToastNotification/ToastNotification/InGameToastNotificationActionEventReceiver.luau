local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MessageBusService = game:GetService("MessageBusService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
local LifecycleEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/LifecycleEvents")
local notificationTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type").NotificationTypeEnum
local GuiObjectUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/GuiObjectUtils")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Logger")

local FFlagEnablePresenceOnlineInviteReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Flags/FFlagEnablePresenceOnlineInviteReceiver")

local useProperty = GuiObjectUtils.useProperty

local messageId = MessageBusService:GetMessageId("ToastNotifications", "PresenceOnlineToast")

local function InGameToastNotificationActionEventReceiver()
	local v5 = useProperty(Players, "LocalPlayer")
	local v6 = if FFlagEnablePresenceOnlineInviteReceiver then useProperty(game, "PlaceId") else nil

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

	if FFlagEnablePresenceOnlineInviteReceiver then
		local localizedStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/NotificationsCommon").LocalizationHelper.getLocalizedStrings({
			inviteSuccess = "Feature.SocialContextToast.Message.InvitationConfirmation",
			inviteFailure = "Feature.SocialContextToast.Message.InvitationFailure"
		})

		local inviteSuccess = localizedStrings.inviteSuccess
		local inviteFailure = localizedStrings.inviteFailure

		React.useEffect(function()
			local flag = true
			local connection = MessageBusService:Subscribe(messageId, function(p2)
				if type(p2) ~= "table" then
					return
				end

				local senderUserId = p2.senderUserId

				if not senderUserId or not v5 or not v6 or v6 <= 0 then
					return
				end

				local postSendExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/GameInvite").PostSendExperienceInvite
				local guiService = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/MockableProxyServices").GuiService
				local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/HttpRequest")
				postSendExperienceInvite(
					HttpRequest.config({
						requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
						maxRetryCount = 0
					}),
					tostring(senderUserId),
					tostring(v6),
					"OnlineFriendPresence"
				):andThen(
					function()
						Logger:info("PresenceOnlineToast experience invite sent")

						if flag then
							guiService:SendNotification({ Title = inviteSuccess })
						end
					end,
					function()
						Logger:warning("PresenceOnlineToast experience invite failed")

						if flag then
							guiService:SendNotification({ Title = inviteFailure })
						end
					end
				)
			end, false, false)

			return function()
				flag = false
				connection:Disconnect()
			end
		end, { v5, v6, inviteSuccess, inviteFailure })
	end
end

return InGameToastNotificationActionEventReceiver
