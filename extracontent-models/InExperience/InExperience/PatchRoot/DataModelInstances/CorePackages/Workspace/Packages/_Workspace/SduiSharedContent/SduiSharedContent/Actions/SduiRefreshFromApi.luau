local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.RefreshFromApi, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local configKey = actionParams.configKey

	if typeof(configKey) ~= "string" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.RefreshFromApi,
				message = `Invalid or missing configKey: {configKey}`,
				propName = "configKey"
			},
			p2.appPage
		)
		return
	end

	local surfaceKey = actionParams.surfaceKey

	if typeof(surfaceKey) ~= "string" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.RefreshFromApi,
				message = `Invalid or missing surfaceKey: {surfaceKey}`,
				propName = "surfaceKey"
			},
			p2.appPage
		)
		return
	end

	local loadTimer = SduiLoadTimer.createLoadTimer(surfaceKey)
	loadTimer.start("refresh")
	return getSduiApiStore().refreshFromApi({ configKey = configKey, loadTimer = loadTimer }):finally(function()
		loadTimer.logRefreshComplete()
	end)
end
