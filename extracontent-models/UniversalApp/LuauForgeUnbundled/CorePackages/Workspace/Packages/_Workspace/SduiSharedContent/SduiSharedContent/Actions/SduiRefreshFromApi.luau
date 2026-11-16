local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedUtilities")
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.RefreshFromApi, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local configKey = actionParams.configKey

	if typeof(configKey) ~= "string" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RefreshFromApi,
				message = `Invalid or missing configKey: {configKey}`,
				propName = "configKey"
			},
			p4.appPage
		)
		return
	end

	local surfaceKey = actionParams.surfaceKey

	if typeof(surfaceKey) ~= "string" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RefreshFromApi,
				message = `Invalid or missing surfaceKey: {surfaceKey}`,
				propName = "surfaceKey"
			},
			p4.appPage
		)
		return
	end

	local loadTimer = sduiLoadTimer.createLoadTimer(surfaceKey)
	loadTimer.start("refresh")
	return getSduiApiStore().refreshFromApi({
		configKey = configKey,
		loadTimer = loadTimer
	}):finally(function()
		loadTimer.logRefreshComplete()
	end)
end
