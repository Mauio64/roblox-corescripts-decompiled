local parent = script:FindFirstAncestor("PromptsServerDrivenUi").Parent

local NotificationsUpsell = require(parent.NotificationsUpsell)
local requestPushNotificationPermission = NotificationsUpsell.requestPushNotificationPermission
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local NotificationsUpsell2 = require(parent.NotificationsUpsell)
local ModalEventConstants = NotificationsUpsell2.ModalEventConstants
local NotificationsUpsell3 = require(parent.NotificationsUpsell)
local PushUpsellEventConfig = NotificationsUpsell3.PushUpsellEventConfig

local SharedFlags = require(parent.SharedFlags)
local FFlagPushPermissionRequestOpensAndroidSettings = SharedFlags.FFlagPushPermissionRequestOpensAndroidSettings

local function getOpenSettingsStatus(p) -- 1 equivalent call inferred from this helper
	if typeof(p) == "table" and typeof(p.openSettingsStatus) == "string" then
		return p.openSettingsStatus
	end

	return nil
end

local function logRequestResult(p: string, p2: string, p3)
	local openSettingsStatus = getOpenSettingsStatus(p3) -- inferred equivalent call

	if openSettingsStatus == nil then
		default:logRobloxTelemetryEvent(
			PushUpsellEventConfig,
			{},
			{ [ModalEventConstants.ActionType] = p2, [ModalEventConstants.EntryPoint] = p },
			ModalEventConstants.ModalContextSysUpsell
		)
	else
		default:logRobloxTelemetryEvent(
			PushUpsellEventConfig,
			{},
			{
				[ModalEventConstants.ActionType] = ModalEventConstants.SettingsOpened,
				[ModalEventConstants.EntryPoint] = p,
				[ModalEventConstants.SettingsResult] = openSettingsStatus
			},
			ModalEventConstants.ModalContextSettingsUpsell
		)
	end
end

return function(p, _, p2, _)
	local source = (p and p.actionParams or {}).source

	if source ~= nil and type(source) ~= "string" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "RequestPushNotificationPermission",
				message = "Invalid source",
				propName = "source"
			},
			p2.appPage
		)
		return
	end

	local v = source or "SDUI"
	default:logRobloxTelemetryEvent(
		PushUpsellEventConfig,
		{},
		{
			[ModalEventConstants.ActionType] = ModalEventConstants.Opened,
			[ModalEventConstants.EntryPoint] = v
		},
		ModalEventConstants.ModalContextSysUpsell
	)

	if FFlagPushPermissionRequestOpensAndroidSettings then
		requestPushNotificationPermission({ allowOpenSettings = true }):andThen(function(p3)
			logRequestResult(v, ModalEventConstants.RequestSuccess, p3)
		end, function(p3)
			logRequestResult(v, ModalEventConstants.RequestFailed, p3)
		end)
	else
		requestPushNotificationPermission():andThen(function()
			default:logRobloxTelemetryEvent(
				PushUpsellEventConfig,
				{},
				{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess },
				ModalEventConstants.ModalContextSysUpsell
			)
		end, function()
			default:logRobloxTelemetryEvent(
				PushUpsellEventConfig,
				{},
				{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed },
				ModalEventConstants.ModalContextSysUpsell
			)
		end)
	end
end
