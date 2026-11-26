local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/ReactUtils")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/Loggers").Logger:new("VoiceCallReceivedEventReceiver")
local ToastNotification = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/ToastNotification")
local ToastNotificationsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/ToastNotificationsProtocol")

local CallingStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Enums/CallingStatus")
local FFlagFriendsCallingServiceLuaMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/SharedFlags/FFlagFriendsCallingServiceLuaMigration")

local lifecycleEvents = ToastNotification.LifecycleEvents
local notificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local useEventConnection = ReactUtils.useEventConnection
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

local function VoiceCallReceivedEventReceiver(p2): nil
	local callingService = p2.callingService or game:GetService("CallingService")
	local friendsCallingService

	if FFlagFriendsCallingServiceLuaMigration then
		friendsCallingService = p2.friendsCallingService or game:GetService("FriendsCallingService")
	else
		friendsCallingService = nil
	end

	local ref = React.useRef({})

	local function forgetToast(p3)
		for k, v6 in ref.current do
			if v6 == p3 then
				ref.current[k] = nil
				break
			end
		end
	end

	React.useEffect(function()
		local connection = default:listenToDisplayNotification(function(data)
			if data == nil or data.notificationType ~= notificationTypeEnum.VoiceCallReceived then
				return
			end

			local callData = HttpService:JSONDecode(data.lifecycleData).callData
			local callId = HttpService:JSONDecode(callData).callId
			local status = callingService:GetCallingState(callId).status
			local v6 = not (data.content == nil) and data.content.currentState == "missed"

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
				if not v6 then
					default:updateNotification(data.notificationId, "missed")
				end
			else
				default:dismissNotification(data.notificationId)
			end
		end)

		local connection2 = default:listenToDismissNotification(function(p3)
			if p3 ~= nil then
				local notificationId = p3.notificationId

				for k, v6 in ref.current do
					if v6 == notificationId then
						ref.current[k] = nil
						return
					end
				end
			end
		end)

		return function()
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { callingService, friendsCallingService })

	local v6 = React.useCallback(function(p3)
		local v7 = ref.current[p3.callId]

		if not (v7 ~= nil and p3.status ~= CallingStatus.Ringing) then
			return
		end

		if p3.status == CallingStatus.Missed then
			ref.current[p3.callId] = nil
			default:updateNotification(v7, "missed")
		else
			ref.current[p3.callId] = nil
			default:dismissNotification(v7)
		end
	end, {})

	useEventConnection(callingService.OnCallingStateChange, v6)

	React.useEffect(function()
		return lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.VoiceCallReceived,
			function(p3)
				local visualItem = p3 and p3.visualItem

				if p3 == nil or p3.userActionType ~= "click" or visualItem == nil then
					return
				end

				local callId = HttpService:JSONDecode(HttpService:JSONDecode(visualItem.actionEventParams).callData).callId

				if visualItem.visualItemName == "AnswerCall" then
					if FFlagFriendsCallingServiceLuaMigration then
						for i, child in friendsCallingService:GetChildren() do
							if
								child.ClassName == "FriendsCallingInstance"
								and child.CallId ~= ""
								and child.CallId ~= callId
							then
								v5:warning("Answering {} while {} is still up", callId, child.CallId)
								break
							end
						end

						friendsCallingService:AnswerCall(callId)
					else
						local callingState = callingService:GetCallingState()

						if callingState.callId ~= nil and callingState.callId ~= callId then
							v5:warning("Answering {} while {} is still up", callId, callingState.callId)
						end

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
