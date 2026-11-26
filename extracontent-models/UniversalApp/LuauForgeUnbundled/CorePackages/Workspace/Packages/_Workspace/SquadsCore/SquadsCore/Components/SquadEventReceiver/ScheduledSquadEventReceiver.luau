local HttpService = game:GetService("HttpService")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants")
local createOrJoinSquad = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/createOrJoinSquad")
local GetScheduledSquadsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetScheduledSquadsStore")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/EventNames")

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local SquadToastActionsAndStates = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadToastActionsAndStates")
local SquadToastType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadToastType")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RealtimeDelivery")
local ToastNotification = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ToastNotification")
local ToastNotificationsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ToastNotificationsProtocol")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch

local lifecycleEvents = ToastNotification.LifecycleEvents
local notificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum

local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

local function SquadScheduledSquadEventReceiver()
	local v5 = useDispatch()
	local v6 = React.useContext(SquadExternalContractContext)
	local v7 = v6.useIsChatEnabled()

	React.useEffect(function()
		local connection = default:listenToDisplayNotification(function(p2)
			if
				(p2.notificationType == notificationTypeEnum.ScheduledSquadHappeningNow or p2.notificationType == notificationTypeEnum.ScheduledSquadReminder)
				and not v7
			then
				default:dismissNotification(p2.notificationId)
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, { v7 })

	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.ScheduledSquadHappeningNow,
			function(p2)
				if
					p2
					and p2.userActionType == "click"
					and p2.visualItem
					and p2.visualItem.actionEventParams
					and p2.visualItem.visualItemName == Constants.JOIN_SQUAD
				then
					local jsonDecode = HttpService:JSONDecode(p2.visualItem.actionEventParams)

					v6.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = jsonDecode.parentChannelId,
						toastAction = SquadToastActionsAndStates.ScheduledSquadHappeningNowJoinParty,
						toastType = SquadToastType.ScheduledSquadHappeningNow
					})

					v5(createOrJoinSquad(
						jsonDecode.parentChannelId,
						v6.setSquadPrompt,
						v6.fireSquadAnalytics,
						v6.squadLocation,
						HttpService:GenerateGUID(false),
						function() end,
						(tostring(jsonDecode.scheduledGroupUpId))
					))
				end
			end
		)

		return function()
			callback()
		end
	end, { v5, v6.setSquadPrompt, v6.fireSquadAnalytics, v6.squadLocation })

	RealtimeDelivery.useRealtimeNamespace(Constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE, function(p2)
		if p2.Type == Constants.SCHEDULED_GROUP_UP_CHANGED_RTN_TYPE then
			local v8 = GetScheduledSquadsStore(false)

			for i, scheduledGroupUpId in ipairs(p2.ScheduledGroupUpIds) do
				v8.fetchAndCacheScheduledSquadStatus(scheduledGroupUpId)
			end
		end
	end, {})
end

return SquadScheduledSquadEventReceiver
