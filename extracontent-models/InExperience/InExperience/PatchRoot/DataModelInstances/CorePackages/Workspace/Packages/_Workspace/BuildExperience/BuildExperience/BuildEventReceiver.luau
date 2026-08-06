local HttpService = game:GetService("HttpService")
local MessageBusService = game:GetService("MessageBusService")
local NotificationService = game:GetService("NotificationService")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local default = require(BuildExperienceParent.LinkingProtocol).LinkingProtocol.default
local React = require(BuildExperienceParent.React)
local RealtimeDelivery = require(BuildExperienceParent.RealtimeDelivery)
local ToastNotification = require(BuildExperienceParent.ToastNotification)
local ToastNotificationsProtocol = require(BuildExperienceParent.ToastNotificationsProtocol)
local GetCreatorAgentResumeStore = require(BuildExperience.Stores.GetCreatorAgentResumeStore)
local GetPlayButtonStore = require(BuildExperience.Stores.GetPlayButtonStore)
local getCurrentExperienceProject = require(BuildExperience.utils.getCurrentExperienceProject)
local leaveExperience = require(BuildExperience.utils.leaveExperience)
local ResumeNotification = CreatorAgentChat.ResumeNotification
local LifecycleEvents = ToastNotification.LifecycleEvents
local default2 = ToastNotificationsProtocol.ToastNotificationProtocol.default
local ToastNotificationProtocolConstants = ToastNotificationsProtocol.ToastNotificationProtocolConstants

local function disconnect(p1) -- line: 38
	if p1 == nil then
		return
	end

	if typeof(p1.Disconnect) == "function" then
		p1:Disconnect()

		return
	end

	if typeof(p1.disconnect) == "function" then
		p1:disconnect()
	end
end
local function decodeActionParams(p2) -- line: 49
	-- upvalues: HttpService (copy)
	local v27 = if typeof(p2) ~= "table" then nil else p2.visualItem
	local v28 = if typeof(v27) ~= "table" then nil else v27.actionEventParams

	if typeof(v28) ~= "string" or v28 == "" then
		return nil
	end

	local ok, result = pcall(HttpService.JSONDecode, HttpService, v28)

	if not ok or typeof(result) ~= "table" then
		return nil
	end

	local sessionId = result.sessionId

	if typeof(sessionId) ~= "string" or sessionId == "" then
		return nil
	end

	local kind = result.kind

	if kind ~= "turn_end" and kind ~= "local_tool_call" then
		return nil
	end

	local universeId = result.universeId

	return {
		kind = kind,
		sessionId = sessionId,
		universeId = if typeof(universeId) ~= "number" then nil else universeId
	}
end
local function publishToast(t1: {[any]: any}) -- line: 79
	-- upvalues: MessageBusService (copy), ToastNotificationProtocolConstants (copy), ResumeNotification (copy)
	MessageBusService:Publish(ToastNotificationProtocolConstants.MESSAGE_DISPLAY_TOAST_NOTIF, ResumeNotification.buildToastNotification(t1))
end
local function routeToBuildChat(t2: {[any]: any}, b1: boolean, b2: boolean) -- line: 86
	-- upvalues: getCurrentExperienceProject (copy), GetPlayButtonStore (copy), ResumeNotification (copy), leaveExperience (copy), default (copy)
	if b1 and b2 then
		local v38 = getCurrentExperienceProject()

		if t2.universeId ~= nil and v38.universeId == t2.universeId then
			local v39 = GetPlayButtonStore()

			v39.setResumeTarget({
				universeId = t2.universeId,
				placeId = v38.placeId,
				sessionId = t2.sessionId
			})
			v39.setIsActive(true)

			return
		end
	end

	local v40 = ResumeNotification.getResumeDeepLink(t2)

	if b1 then
		leaveExperience(function() -- line: 103
			-- upvalues: default (copy), v40 (copy)
			default:detectURL(v40)
		end)

		return
	end

	default:detectURL(v40)
end
local function BuildEventReceiver(t3: {[any]: any}) -- line: 111
	-- upvalues: GetCreatorAgentResumeStore (copy), React (copy), RealtimeDelivery (copy), NotificationService (copy), ResumeNotification (copy), MessageBusService (copy), ToastNotificationProtocolConstants (copy), LifecycleEvents (copy), decodeActionParams (copy), default2 (copy), routeToBuildChat (copy)
	local v42 = GetCreatorAgentResumeStore()
	local v43 = React.useMemo(function() -- line: 113
		-- upvalues: t3 (copy), RealtimeDelivery (copy), NotificationService (copy)
		return t3.RobloxEventReceiver or RealtimeDelivery.RobloxEventReceiver.new(NotificationService)
	end, { t3.RobloxEventReceiver })
	local v44 = t3.isInExperience == true
	local v45 = t3.isBuildModeActive == true

	React.useEffect(function() -- line: 120
		-- upvalues: v43 (copy), ResumeNotification (copy), v42 (copy), MessageBusService (copy), ToastNotificationProtocolConstants (copy)
		local v46 = v43:observeEvent(ResumeNotification.CapRtnNamespace, function(p3) -- line: 121
			-- upvalues: ResumeNotification (copy), v42 (copy), MessageBusService (copy), ToastNotificationProtocolConstants (copy)
			local v49 = ResumeNotification.classifyRtnDetail(p3)

			if v49 == nil then
				return
			end

			local v50 = v42.getActiveTarget(false)

			if ResumeNotification.targetMatchesNotification(v50, v49) then
				return
			end

			MessageBusService:Publish(ToastNotificationProtocolConstants.MESSAGE_DISPLAY_TOAST_NOTIF, ResumeNotification.buildToastNotification(v49))
		end)

		return function() -- line: 135
			-- upvalues: v46 (copy)
			local v51 = v46

			if v51 == nil then
				return
			end

			if typeof(v51.Disconnect) == "function" then
				v51:Disconnect()

				return
			end

			if typeof(v51.disconnect) == "function" then
				v51:disconnect()
			end
		end
	end, {
		v43,
		v42
	})
	React.useEffect(function() -- line: 140
		-- upvalues: LifecycleEvents (copy), ResumeNotification (copy), decodeActionParams (copy), default2 (copy), routeToBuildChat (copy), v44 (copy), v45 (copy)
		local v47 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, ResumeNotification.NotificationType, function(p4) -- line: 144
			-- upvalues: ResumeNotification (copy), decodeActionParams (copy), default2 (copy), routeToBuildChat (copy), v44 (copy), v45 (copy)
			if typeof(p4) ~= "table" or (p4.userActionType ~= "click" or typeof(p4.visualItem) ~= "table" or p4.visualItem.eventName ~= ResumeNotification.ResumeEventName or typeof(p4.notificationData) ~= "table") then
				return
			end

			local v53 = decodeActionParams(p4)

			if v53 == nil then
				return
			end

			default2:dismissNotification(p4.notificationData.id)
			routeToBuildChat(v53, v44, v45)
		end)

		return function() -- line: 165
			-- upvalues: v47 (copy)
			v47()
		end
	end, {
		v44,
		v45
	})

	return nil
end

return BuildEventReceiver
