local HttpService = game:GetService("HttpService")
local MessageBusService = game:GetService("MessageBusService")
local NotificationService = game:GetService("NotificationService")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RealtimeDelivery")
local ToastNotification = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ToastNotification")
local ToastNotificationsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ToastNotificationsProtocol")

local GetCreatorAgentResumeStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetCreatorAgentResumeStore")
local GetPlayButtonStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetPlayButtonStore")
local getCurrentExperienceProject = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/getCurrentExperienceProject")
local AdsCampaignNotification = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/AdsCampaignNotification")
local openDeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/openDeepLink")
local fFlagBuildAdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildAdUpsell

local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceLibrary
local fFlagConnectionRelaunchBuildPlaytest = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagConnectionRelaunchBuildPlaytest
local v5

if fFlagBuildExperienceLibrary or fFlagConnectionRelaunchBuildPlaytest then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/PlaytestRejoin")
else
	v5 = nil
end

local resumeNotification = CreatorAgentChat.ResumeNotification
local lifecycleEvents = ToastNotification.LifecycleEvents
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default
local toastNotificationProtocolConstants = ToastNotificationsProtocol.ToastNotificationProtocolConstants

local function disconnect(connection)
	if connection == nil then
		return
	end

	if typeof(connection.Disconnect) == "function" then
		connection:Disconnect()
	elseif typeof(connection.disconnect) == "function" then
		connection:disconnect()
	end
end

local function decodeActionParams(data)
	local visualItem = if typeof(data) == "table" then data.visualItem else nil
	local actionEventParams = if typeof(visualItem) == "table" then visualItem.actionEventParams else nil

	if typeof(actionEventParams) ~= "string" or actionEventParams == "" then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, actionEventParams)

	if not success or typeof(result) ~= "table" then
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

	if typeof(universeId) ~= "number" then
		universeId = nil
	end

	return { kind = kind, sessionId = sessionId, universeId = universeId }
end

local function publishToast(p2)
	MessageBusService:Publish(
		toastNotificationProtocolConstants.MESSAGE_DISPLAY_TOAST_NOTIF,
		resumeNotification.buildToastNotification(p2)
	)
end

local function routeToBuildChat(p2, isInExperience, isBuildModeActive)
	if isInExperience and isBuildModeActive then
		local v6 = getCurrentExperienceProject()

		if p2.universeId ~= nil and v6.universeId == p2.universeId then
			local v7 = GetPlayButtonStore()
			v7.setResumeTarget({
				universeId = p2.universeId,
				placeId = v6.placeId,
				sessionId = p2.sessionId
			})

			v7.setIsActive(true)
			return
		end
	end

	openDeepLink(resumeNotification.getResumeDeepLink(p2), isInExperience)
end

local function BuildEventReceiver(data): nil
	local v6 = GetCreatorAgentResumeStore()
	local v7 = React.useMemo(function()
		return data.RobloxEventReceiver or RealtimeDelivery.RobloxEventReceiver.new(NotificationService)
	end, { data.RobloxEventReceiver })

	local isInExperience = data.isInExperience == true
	local isBuildModeActive = data.isBuildModeActive == true

	React.useEffect(function()
		if v5 == nil or isInExperience then
			return nil
		end

		return (v5.listen())
	end, { isInExperience })

	if fFlagBuildAdUpsell then
		React.useEffect(function()
			return AdsCampaignNotification.connect(lifecycleEvents, function(p2)
				openDeepLink(p2, isInExperience)
			end, function(p2)
				default:dismissNotification(p2)
			end)
		end, { isInExperience })
	end

	React.useEffect(function()
		local v8 = v7:observeEvent(resumeNotification.CapRtnNamespace, function(p2)
			local classifyRtnDetail = resumeNotification.classifyRtnDetail(p2)

			if classifyRtnDetail == nil then
				return
			end

			local activeTarget = v6.getActiveTarget(false)

			if resumeNotification.targetMatchesNotification(activeTarget, classifyRtnDetail) then
				return
			end

			MessageBusService:Publish(
				toastNotificationProtocolConstants.MESSAGE_DISPLAY_TOAST_NOTIF,
				resumeNotification.buildToastNotification(classifyRtnDetail)
			)
		end)

		return function()
			local connection = v8

			if connection == nil then
				return
			end

			if typeof(connection.Disconnect) == "function" then
				connection:Disconnect()
			elseif typeof(connection.disconnect) == "function" then
				connection:disconnect()
			end
		end
	end, { v7, v6 })

	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			resumeNotification.NotificationType,
			function(data2)
				if
					typeof(data2) ~= "table"
					or data2.userActionType ~= "click"
					or typeof(data2.visualItem) ~= "table"
					or data2.visualItem.eventName ~= resumeNotification.ResumeEventName
					or typeof(data2.notificationData) ~= "table"
				then
					return
				end

				local v8 = decodeActionParams(data2)

				if v8 == nil then
					return
				end

				default:dismissNotification(data2.notificationData.id)
				routeToBuildChat(v8, isInExperience, isBuildModeActive)
			end
		)

		return function()
			callback()
		end
	end, { isInExperience, isBuildModeActive })

	return nil
end

return BuildEventReceiver
