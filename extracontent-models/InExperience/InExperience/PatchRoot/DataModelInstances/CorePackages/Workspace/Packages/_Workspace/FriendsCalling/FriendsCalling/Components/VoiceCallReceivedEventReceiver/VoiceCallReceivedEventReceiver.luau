local FriendsCalling = script:FindFirstAncestor("FriendsCalling")
local parent = FriendsCalling.Parent

local HttpService = game:GetService("HttpService")

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local ToastNotification = require(parent.ToastNotification)
local ToastNotificationsProtocol = require(parent.ToastNotificationsProtocol)

local CallingStatus = require(FriendsCalling.Enums.CallingStatus)
local FFlagFriendsCallingServiceLuaMigration = require(parent.SharedFlags.FFlagFriendsCallingServiceLuaMigration)

local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local useEventConnection = ReactUtils.useEventConnection
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

local function VoiceCallReceivedEventReceiver(p): nil
	local callingService = p.callingService or game:GetService("CallingService")
	local friendsCallingService

	if FFlagFriendsCallingServiceLuaMigration then
		friendsCallingService = p.friendsCallingService or game:GetService("FriendsCallingService")
	else
		friendsCallingService = nil
	end

	local ref = React.useRef({})

	local function forgetToast(notificationId: string) -- 1 equivalent call inferred from this helper
		for k, v in ref.current do
			if v == notificationId then
				ref.current[k] = nil
				break
			end
		end
	end

	React.useEffect(function()
		local connection = default:listenToDisplayNotification(function(data)
			if data == nil or data.notificationType ~= NotificationTypeEnum.VoiceCallReceived then
				return
			end

			local callData = HttpService:JSONDecode(data.lifecycleData).callData
			local callId = HttpService:JSONDecode(callData).callId
			local status = callingService:GetCallingState(callId).status
			local v

			if data.content == nil then
				v = false
			else
				v = data.content.currentState == "missed"
			end

			if status == nil then
				ref.current[callId] = data.notificationId

				if FFlagFriendsCallingServiceLuaMigration then
					friendsCallingService:ReceiveCall(callData)
				else
					callingService:ReceiveIncomingCall(callData)
				end
			elseif status == CallingStatus.Ringing then
				ref.current[callId] = data.notificationId
			elseif status == CallingStatus.Missed then
				if not v then
					default:updateNotification(data.notificationId, "missed")
				end
			else
				default:dismissNotification(data.notificationId)
			end
		end)

		local connection2 = default:listenToDismissNotification(function(p2)
			if p2 ~= nil then
				forgetToast(p2.notificationId) -- inferred equivalent call
			end
		end)

		return function()
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { callingService, friendsCallingService })

	local v = React.useCallback(function(p2)
		local v = ref.current[p2.callId]

		if not (v ~= nil and p2.status ~= CallingStatus.Ringing) then
			return
		end

		if p2.status == CallingStatus.Missed then
			ref.current[p2.callId] = nil
			default:updateNotification(v, "missed")
		else
			ref.current[p2.callId] = nil
			default:dismissNotification(v)
		end
	end, {})

	useEventConnection(callingService.OnCallingStateChange, v)

	React.useEffect(function()
		return LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			NotificationTypeEnum.VoiceCallReceived,
			function(p2)
				local visualItem = p2 and p2.visualItem

				if p2 == nil or p2.userActionType ~= "click" or visualItem == nil then
					return
				end

				local callId = HttpService:JSONDecode(HttpService:JSONDecode(visualItem.actionEventParams).callData).callId

				if visualItem.visualItemName == "AnswerCall" then
					if FFlagFriendsCallingServiceLuaMigration then
						friendsCallingService:AnswerCall(callId)
					else
						callingService:AnswerIncomingCall(callId)
					end
				elseif visualItem.visualItemName == "DeclineCall" then
					if FFlagFriendsCallingServiceLuaMigration then
						friendsCallingService:EndCall(callId, "ToastEndAction")
					else
						callingService:EndCall(callId, "ToastEndAction")
					end
				end
			end
		)
	end, { callingService, friendsCallingService })

	return nil
end

return VoiceCallReceivedEventReceiver
