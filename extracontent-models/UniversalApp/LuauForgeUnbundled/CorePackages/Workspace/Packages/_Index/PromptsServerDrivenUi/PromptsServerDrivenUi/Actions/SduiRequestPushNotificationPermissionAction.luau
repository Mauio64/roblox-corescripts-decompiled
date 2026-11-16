local requestPushNotificationPermission = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/NotificationsUpsell").requestPushNotificationPermission
local default = require("@game/CorePackages/Workspace/Packages/_Index/PromptsServerDrivenUi/LoggingProtocol").default
local sduiErrorType = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SduiCoreSystem").SduiErrors.SduiErrorType
local modalEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/NotificationsUpsell").ModalEventConstants
local pushUpsellEventConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/NotificationsUpsell").PushUpsellEventConfig

local fFlagPushPermissionRequestOpensAndroidSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SharedFlags").FFlagPushPermissionRequestOpensAndroidSettings

local function getOpenSettingsStatus(p2)
	if typeof(p2) == "table" and typeof(p2.openSettingsStatus) == "string" then
		return p2.openSettingsStatus
	end

	return nil
end

local function logRequestResult(p2, p3, p4)
	local openSettingsStatus

	if typeof(p4) == "table" and typeof(p4.openSettingsStatus) == "string" then
		openSettingsStatus = p4.openSettingsStatus
	end

	if openSettingsStatus == nil then
		default:logRobloxTelemetryEvent(
			pushUpsellEventConfig,
			{},
			{
				[modalEventConstants.ActionType] = p3,
				[modalEventConstants.EntryPoint] = p2
			},
			modalEventConstants.ModalContextSysUpsell
		)
	else
		default:logRobloxTelemetryEvent(
			pushUpsellEventConfig,
			{},
			{
				[modalEventConstants.ActionType] = modalEventConstants.SettingsOpened,
				[modalEventConstants.EntryPoint] = p2,
				[modalEventConstants.SettingsResult] = openSettingsStatus
			},
			modalEventConstants.ModalContextSettingsUpsell
		)
	end
end

return function(p2, p3, p4, p5)
	local source = (p2 and p2.actionParams or {}).source

	if source ~= nil and type(source) ~= "string" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "RequestPushNotificationPermission",
				message = "Invalid source",
				propName = "source"
			},
			p4.appPage
		)
		return
	end

	local v5 = source or "SDUI"
	default:logRobloxTelemetryEvent(
		pushUpsellEventConfig,
		{},
		{
			[modalEventConstants.ActionType] = modalEventConstants.Opened,
			[modalEventConstants.EntryPoint] = v5
		},
		modalEventConstants.ModalContextSysUpsell
	)

	if fFlagPushPermissionRequestOpensAndroidSettings then
		requestPushNotificationPermission({ allowOpenSettings = true }):andThen(function(p6)
			logRequestResult(v5, modalEventConstants.RequestSuccess, p6)
		end, function(p6)
			logRequestResult(v5, modalEventConstants.RequestFailed, p6)
		end)
	else
		requestPushNotificationPermission():andThen(function()
			default:logRobloxTelemetryEvent(
				pushUpsellEventConfig,
				{},
				{
					[modalEventConstants.ActionType] = modalEventConstants.RequestSuccess
				},
				modalEventConstants.ModalContextSysUpsell
			)
		end, function()
			default:logRobloxTelemetryEvent(
				pushUpsellEventConfig,
				{},
				{ [modalEventConstants.ActionType] = modalEventConstants.RequestFailed },
				modalEventConstants.ModalContextSysUpsell
			)
		end)
	end
end
