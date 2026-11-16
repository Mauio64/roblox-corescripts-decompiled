local HttpService = game:GetService("HttpService")
local MessageBusService = game:GetService("MessageBusService")
local NotificationService = game:GetService("NotificationService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local ToastNotification = require(parent.ToastNotification)
local ToastNotificationsProtocol = require(parent.ToastNotificationsProtocol)

local GetCreatorAgentResumeStore = require(BuildExperience.Stores.GetCreatorAgentResumeStore)
local GetPlayButtonStore = require(BuildExperience.Stores.GetPlayButtonStore)
local getCurrentExperienceProject = require(BuildExperience.utils.getCurrentExperienceProject)
local AdsCampaignNotification = require(BuildExperience.utils.AdsCampaignNotification)
local openDeepLink = require(parent.BuildExperiencePlaytestLaunch.openDeepLink)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildAdUpsell = SharedFlags.FFlagBuildAdUpsell

local SharedFlags2 = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags2.FFlagBuildExperienceLibrary
local SharedFlags3 = require(parent.SharedFlags)
local FFlagConnectionRelaunchBuildPlaytest = SharedFlags3.FFlagConnectionRelaunchBuildPlaytest
local PlaytestRejoin

if FFlagBuildExperienceLibrary or FFlagConnectionRelaunchBuildPlaytest then
	PlaytestRejoin = require(parent.BuildExperiencePlaytestLaunch.PlaytestRejoin)
else
	PlaytestRejoin = nil
end

local ResumeNotification = CreatorAgentChat.ResumeNotification
local LifecycleEvents = ToastNotification.LifecycleEvents
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default
local ToastNotificationProtocolConstants = ToastNotificationsProtocol.ToastNotificationProtocolConstants

local function disconnect(connection) -- 1 equivalent call inferred from this helper
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
	local visualItem

	if typeof(data) == "table" then
		visualItem = data.visualItem
	end

	local actionEventParams

	if typeof(visualItem) == "table" then
		actionEventParams = visualItem.actionEventParams
	end

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

local function publishToast(classifyRtnDetail) -- 1 equivalent call inferred from this helper
	MessageBusService:Publish(
		ToastNotificationProtocolConstants.MESSAGE_DISPLAY_TOAST_NOTIF,
		ResumeNotification.buildToastNotification(classifyRtnDetail)
	)
end

local function routeToBuildChat(p, isInExperience: boolean, isBuildModeActive: boolean)
	if isInExperience and isBuildModeActive then
		local currentExperienceProject = getCurrentExperienceProject()

		if p.universeId ~= nil and currentExperienceProject.universeId == p.universeId then
			local playButtonStore = GetPlayButtonStore()
			playButtonStore.setResumeTarget({
				universeId = p.universeId,
				placeId = currentExperienceProject.placeId,
				sessionId = p.sessionId
			})

			playButtonStore.setIsActive(true)
			return
		end
	end

	openDeepLink(ResumeNotification.getResumeDeepLink(p), isInExperience)
end

local function BuildEventReceiver(data): nil
	local creatorAgentResumeStore = GetCreatorAgentResumeStore()
	local v = React.useMemo(function()
		return data.RobloxEventReceiver or RealtimeDelivery.RobloxEventReceiver.new(NotificationService)
	end, { data.RobloxEventReceiver })

	local isInExperience = data.isInExperience == true
	local isBuildModeActive = data.isBuildModeActive == true

	React.useEffect(function()
		if PlaytestRejoin == nil or isInExperience then
			return nil
		end

		return (PlaytestRejoin.listen())
	end, { isInExperience })

	if FFlagBuildAdUpsell then
		React.useEffect(function()
			return AdsCampaignNotification.connect(LifecycleEvents, function(p)
				openDeepLink(p, isInExperience)
			end, function(p)
				default:dismissNotification(p)
			end)
		end, { isInExperience })
	end

	React.useEffect(function()
		local v2 = v:observeEvent(ResumeNotification.CapRtnNamespace, function(p)
			local classifyRtnDetail = ResumeNotification.classifyRtnDetail(p)

			if classifyRtnDetail == nil then
				return
			end

			local activeTarget = creatorAgentResumeStore.getActiveTarget(false)

			if ResumeNotification.targetMatchesNotification(activeTarget, classifyRtnDetail) then
				return
			end

			publishToast(classifyRtnDetail) -- inferred equivalent call
		end)

		return function()
			disconnect(v2) -- inferred equivalent call
		end
	end, { v, creatorAgentResumeStore })

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			ResumeNotification.NotificationType,
			function(data2)
				if
					typeof(data2) ~= "table"
					or data2.userActionType ~= "click"
					or typeof(data2.visualItem) ~= "table"
					or data2.visualItem.eventName ~= ResumeNotification.ResumeEventName
					or typeof(data2.notificationData) ~= "table"
				then
					return
				end

				local v2 = decodeActionParams(data2)

				if v2 == nil then
					return
				end

				default:dismissNotification(data2.notificationData.id)
				routeToBuildChat(v2, isInExperience, isBuildModeActive)
			end
		)

		return function()
			callback()
		end
	end, { isInExperience, isBuildModeActive })

	return nil
end

return BuildEventReceiver
