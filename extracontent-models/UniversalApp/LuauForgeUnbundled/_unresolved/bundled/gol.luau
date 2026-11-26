local TelemetryService = game:GetService("TelemetryService")

local module = require("@luauforge/bundled/gom")

return {
	reportTwoStepVerificationChallengeIDIsNil = function()
		TelemetryService:LogCounter(module.TwoStepVerificationChallengeIDIsNilConfig)
	end
}
