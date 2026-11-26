local TelemetryService = game:GetService("TelemetryService")

local module = require("@luauforge/bundled/grV")

return {
	reportAttempted = function(p2)
		TelemetryService:LogEvent(module.Attempted, {
			customFields = { username = p2, is_luafied = true }
		})
	end,
	reportSuccess = function(p2)
		TelemetryService:LogEvent(module.Success, {
			customFields = { username = p2, is_luafied = true }
		})
	end,
	reportFailure = function(p2, value)
		TelemetryService:LogEvent(module.Failure, {
			customFields = {
				username = p2,
				error_message = value or "unknown",
				is_luafied = true
			}
		})
	end,
	reportSkipped = function(p2)
		TelemetryService:LogEvent(module.Skipped, {
			customFields = { skip_reason = p2, is_luafied = true }
		})
	end
}
