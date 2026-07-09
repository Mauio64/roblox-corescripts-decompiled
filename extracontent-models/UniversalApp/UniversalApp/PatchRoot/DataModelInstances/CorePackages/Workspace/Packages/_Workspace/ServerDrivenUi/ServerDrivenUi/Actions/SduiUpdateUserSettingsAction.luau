local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local updateUserSettings = require(Parent.LegallySensitiveContent).updateUserSettings
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p1, _, p3, _) -- line: 14
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), updateUserSettings (copy)
	local v10 = p1 and p1.actionParams or nil

	if v10 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.UpdateUserSettings
		}, p3.appPage)

		return
	end

	assert(v10, "actionParams must exist")

	local settings = v10.settings

	if typeof(settings) ~= "table" or next(settings) == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = SduiActionType.UpdateUserSettings,
			message = `Invalid settings { settings }`
		}, p3.appPage)

		return
	end

	local auditData = v10.auditData

	if auditData ~= nil and typeof(auditData) ~= "string" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = SduiActionType.UpdateUserSettings,
			message = `Invalid auditData { auditData }`
		}, p3.appPage)

		return
	end

	local ok, result = pcall(function() -- line: 48
		-- upvalues: updateUserSettings (copy), settings (copy), auditData (copy), p3 (copy), SduiErrorType (copy), SduiActionType (copy)
		updateUserSettings(settings, auditData):catch(function(p5) -- line: 49
			-- upvalues: p3 (copy), SduiErrorType (copy), SduiActionType (copy)
			p3.dependencies.logger.reportError(SduiErrorType.FailedToExecuteAction, {
				name = SduiActionType.UpdateUserSettings,
				message = tostring(p5)
			}, p3.appPage)
		end)
	end)

	if not ok then
		p3.dependencies.logger.reportError(SduiErrorType.FailedToExecuteAction, {
			name = SduiActionType.UpdateUserSettings,
			message = tostring(result)
		}, p3.appPage)

		return
	end
end
