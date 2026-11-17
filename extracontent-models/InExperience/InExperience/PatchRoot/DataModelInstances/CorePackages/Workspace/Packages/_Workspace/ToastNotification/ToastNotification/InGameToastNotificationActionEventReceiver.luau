local parent = script.Parent
local parent2 = parent.Parent
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MessageBusService = game:GetService("MessageBusService")

local React = require(parent2.React)
local LifecycleEvents = require(script.Parent.utils.LifecycleEvents)
local kind = require(parent.type)
local notificationTypeEnum = kind.NotificationTypeEnum
local GuiObjectUtils = require(parent2.GuiObjectUtils)
local Logger = require(parent.Logger)

local FFlagEnablePresenceOnlineInviteReceiver = require(parent.Flags.FFlagEnablePresenceOnlineInviteReceiver)

local useProperty = GuiObjectUtils.useProperty

local messageId = MessageBusService:GetMessageId("ToastNotifications", "PresenceOnlineToast")

local function InGameToastNotificationActionEventReceiver()
	local v = useProperty(Players, "LocalPlayer")
	local v2

	if FFlagEnablePresenceOnlineInviteReceiver then
		v2 = useProperty(game, "PlaceId")
	else
		v2 = nil
	end

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

	if FFlagEnablePresenceOnlineInviteReceiver then
		local NotificationsCommon = require(parent2.NotificationsCommon)
		local localizedStrings = NotificationsCommon.LocalizationHelper.getLocalizedStrings({
			inviteSuccess = "Feature.SocialContextToast.Message.InvitationConfirmation",
			inviteFailure = "Feature.SocialContextToast.Message.InvitationFailure"
		})

		local inviteSuccess = localizedStrings.inviteSuccess
		local inviteFailure = localizedStrings.inviteFailure

		React.useEffect(function()
			local flag = true
			local connection = MessageBusService:Subscribe(messageId, function(p)
				if type(p) ~= "table" then
					return
				end

				local senderUserId = p.senderUserId

				if not senderUserId or not v or not v2 or v2 <= 0 then
					return
				end

				local GameInvite = require(parent2.GameInvite)
				local postSendExperienceInvite = GameInvite.PostSendExperienceInvite
				local MockableProxyServices = require(parent2.MockableProxyServices)
				local guiService = MockableProxyServices.GuiService
				local HttpRequest = require(parent2.HttpRequest)
				postSendExperienceInvite(
					HttpRequest.config({
						requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
						maxRetryCount = 0
					}),
					tostring(senderUserId),
					tostring(v2),
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
		end, { v, v2, inviteSuccess, inviteFailure })
	end
end

return InGameToastNotificationActionEventReceiver
