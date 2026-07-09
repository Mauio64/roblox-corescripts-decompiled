local TelemetryService = game:GetService("TelemetryService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local IosAuthServiceSignupPasswordSave = require(Modules.LuaApp.Analytics.RobloxTelemetryConfigs.IosAuthServiceSignupPasswordSave)

return {
	reportAttempted = function(s1: string) -- line: 10
		-- upvalues: TelemetryService (copy), IosAuthServiceSignupPasswordSave (copy)
		local t1 = {
			is_luafied = true,
			username = s1
		}

		TelemetryService:LogEvent(IosAuthServiceSignupPasswordSave.Attempted, {
			customFields = t1
		})
	end,
	reportSuccess = function(s2: string) -- line: 18
		-- upvalues: TelemetryService (copy), IosAuthServiceSignupPasswordSave (copy)
		local t2 = {
			is_luafied = true,
			username = s2
		}

		TelemetryService:LogEvent(IosAuthServiceSignupPasswordSave.Success, {
			customFields = t2
		})
	end,
	reportFailure = function(s3: string, s4: string?) -- line: 26
		-- upvalues: TelemetryService (copy), IosAuthServiceSignupPasswordSave (copy)
		local t3 = {
			is_luafied = true,
			username = s3,
			error_message = s4 or "unknown"
		}

		TelemetryService:LogEvent(IosAuthServiceSignupPasswordSave.Failure, {
			customFields = t3
		})
	end,
	reportSkipped = function(s5: string) -- line: 35
		-- upvalues: TelemetryService (copy), IosAuthServiceSignupPasswordSave (copy)
		local t4 = {
			is_luafied = true,
			skip_reason = s5
		}

		TelemetryService:LogEvent(IosAuthServiceSignupPasswordSave.Skipped, {
			customFields = t4
		})
	end
}
