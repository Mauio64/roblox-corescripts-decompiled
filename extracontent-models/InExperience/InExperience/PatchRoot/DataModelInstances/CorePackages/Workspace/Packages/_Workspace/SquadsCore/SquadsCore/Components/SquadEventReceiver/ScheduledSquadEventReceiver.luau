local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local HttpService = game:GetService("HttpService")

local Constants = require(SquadsCore.Common.Constants)
local createOrJoinSquad = require(SquadsCore.Thunks.createOrJoinSquad)
local GetScheduledSquadsStore = require(SquadsCore.Stores.GetScheduledSquadsStore)
local EventNames = require(SquadsCore.Analytics.EventNames)

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local SquadToastActionsAndStates = require(SquadsCore.Enums.SquadToastActionsAndStates)
local SquadToastType = require(SquadsCore.Enums.SquadToastType)

local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local ToastNotification = require(parent.ToastNotification)
local ToastNotificationsProtocol = require(parent.ToastNotificationsProtocol)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum

local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

local function SquadScheduledSquadEventReceiver()
	local v = useDispatch()
	local v2 = React.useContext(SquadExternalContractContext)
	local v3 = v2.useIsChatEnabled()

	React.useEffect(function()
		local connection = default:listenToDisplayNotification(function(p)
			if
				(p.notificationType == NotificationTypeEnum.ScheduledSquadHappeningNow or p.notificationType == NotificationTypeEnum.ScheduledSquadReminder)
				and not v3
			then
				default:dismissNotification(p.notificationId)
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, { v3 })

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			NotificationTypeEnum.ScheduledSquadHappeningNow,
			function(p)
				if
					p
					and p.userActionType == "click"
					and p.visualItem
					and p.visualItem.actionEventParams
					and p.visualItem.visualItemName == Constants.JOIN_SQUAD
				then
					local jsonDecode = HttpService:JSONDecode(p.visualItem.actionEventParams)

					v2.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = jsonDecode.parentChannelId,
						toastAction = SquadToastActionsAndStates.ScheduledSquadHappeningNowJoinParty,
						toastType = SquadToastType.ScheduledSquadHappeningNow
					})

					v(createOrJoinSquad(
						jsonDecode.parentChannelId,
						v2.setSquadPrompt,
						v2.fireSquadAnalytics,
						v2.squadLocation,
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
	end, { v, v2.setSquadPrompt, v2.fireSquadAnalytics, v2.squadLocation })

	RealtimeDelivery.useRealtimeNamespace(Constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE, function(p)
		if p.Type == Constants.SCHEDULED_GROUP_UP_CHANGED_RTN_TYPE then
			local scheduledSquadsStore = GetScheduledSquadsStore(false)

			for _, scheduledGroupUpId in ipairs(p.ScheduledGroupUpIds) do
				scheduledSquadsStore.fetchAndCacheScheduledSquadStatus(scheduledGroupUpId)
			end
		end
	end, {})
end

return SquadScheduledSquadEventReceiver
