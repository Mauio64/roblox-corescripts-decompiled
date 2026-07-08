local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local HttpService = game:GetService("HttpService")
local Constants = require(SquadsCore.Common.Constants)
local createOrJoinSquad = require(SquadsCore.Thunks.createOrJoinSquad)
local GetScheduledSquadsStore = require(SquadsCore.Stores.GetScheduledSquadsStore)
local EventNames = require(SquadsCore.Analytics.EventNames)
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local SquadToastActionsAndStates = require(SquadsCore.Enums.SquadToastActionsAndStates)
local SquadToastType = require(SquadsCore.Enums.SquadToastType)
local React = require(SquadsCoreParent.React)
local RealtimeDelivery = require(SquadsCoreParent.RealtimeDelivery)
local ToastNotification = require(SquadsCoreParent.ToastNotification)
local ToastNotificationsProtocol = require(SquadsCoreParent.ToastNotificationsProtocol)
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch
local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

local function SquadScheduledSquadEventReceiver() -- line: 26
	-- upvalues: useDispatch (copy), React (copy), SquadExternalContractContext (copy), default (copy), NotificationTypeEnum (copy), LifecycleEvents (copy), Constants (copy), HttpService (copy), EventNames (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), createOrJoinSquad (copy), RealtimeDelivery (copy), GetScheduledSquadsStore (copy)
	local v20 = useDispatch()
	local v21 = React.useContext(SquadExternalContractContext)
	local v22 = v21.useIsChatEnabled()

	React.useEffect(function() -- line: 31
		-- upvalues: default (copy), NotificationTypeEnum (copy), v22 (copy)
		local v23 = default:listenToDisplayNotification(function(p1) -- line: 33
			-- upvalues: NotificationTypeEnum (copy), v22 (copy), default (copy)
			if (p1.notificationType == NotificationTypeEnum.ScheduledSquadHappeningNow or p1.notificationType == NotificationTypeEnum.ScheduledSquadReminder) and not v22 then
				default:dismissNotification(p1.notificationId)
			end
		end)

		return function() -- line: 45
			-- upvalues: v23 (copy)
			v23:Disconnect()
		end
	end, { v22 })
	React.useEffect(function() -- line: 51
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), Constants (copy), HttpService (copy), v21 (copy), EventNames (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), v20 (copy), createOrJoinSquad (copy)
		local v24 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.ScheduledSquadHappeningNow, function(p2) -- line: 55
			-- upvalues: Constants (copy), HttpService (copy), v21 (copy), EventNames (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), v20 (copy), createOrJoinSquad (copy)
			if p2 and (p2.userActionType == "click" and p2.visualItem and p2.visualItem.actionEventParams and p2.visualItem.visualItemName == Constants.JOIN_SQUAD) then
				local data = HttpService:JSONDecode(p2.visualItem.actionEventParams)

				v21.fireSquadAnalytics(EventNames.SquadToastActions, {
					parentChannelId = data.parentChannelId,
					toastAction = SquadToastActionsAndStates.ScheduledSquadHappeningNowJoinParty,
					toastType = SquadToastType.ScheduledSquadHappeningNow
				})
				v20(createOrJoinSquad(data.parentChannelId, v21.setSquadPrompt, v21.fireSquadAnalytics, v21.squadLocation, HttpService:GenerateGUID(false), function() -- line: 77
				end, (tostring(data.scheduledGroupUpId))))
			end
		end)

		return function() -- line: 85
			-- upvalues: v24 (copy)
			v24()
		end
	end, {
		v20,
		v21.setSquadPrompt,
		v21.fireSquadAnalytics,
		v21.squadLocation
	})
	RealtimeDelivery.useRealtimeNamespace(Constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE, function(p3) -- line: 97
		-- upvalues: Constants (copy), GetScheduledSquadsStore (copy)
		if p3.Type == Constants.SCHEDULED_GROUP_UP_CHANGED_RTN_TYPE then
			local v26 = GetScheduledSquadsStore(false)

			for _, v in ipairs(p3.ScheduledGroupUpIds) do
				v26.fetchAndCacheScheduledSquadStatus(v)
			end
		end
	end, {})
end

return SquadScheduledSquadEventReceiver
