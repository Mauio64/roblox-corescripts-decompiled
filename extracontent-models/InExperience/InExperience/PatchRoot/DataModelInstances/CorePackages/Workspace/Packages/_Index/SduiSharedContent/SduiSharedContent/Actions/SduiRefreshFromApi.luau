local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p1, _, p3) -- line: 17
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), SduiLoadTimer (copy), getSduiApiStore (copy)
	local v11 = p1 and p1.actionParams or nil

	if v11 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.RefreshFromApi
		}, p3.appPage)

		return
	end

	assert(v11, "actionParams must exist")

	local configKey = v11.configKey

	if typeof(configKey) ~= "string" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "configKey",
			name = SduiActionType.RefreshFromApi,
			message = `Invalid or missing configKey: { configKey }`
		}, p3.appPage)

		return
	end

	local surfaceKey = v11.surfaceKey

	if typeof(surfaceKey) ~= "string" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "surfaceKey",
			name = SduiActionType.RefreshFromApi,
			message = `Invalid or missing surfaceKey: { surfaceKey }`
		}, p3.appPage)

		return
	end

	local v14 = SduiLoadTimer.createLoadTimer(surfaceKey)

	v14.start("refresh")

	return getSduiApiStore().refreshFromApi({
		configKey = configKey,
		loadTimer = v14
	}):finally(function() -- line: 59
		-- upvalues: v14 (copy)
		v14.logRefreshComplete()
	end)
end
