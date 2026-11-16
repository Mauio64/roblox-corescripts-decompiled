local TelemetryService = game:GetService("TelemetryService")

local module = require("@luauforge/bundled/fJR")

return {
	reportTwoStepVerificationChallengeIDIsNil = function()
		TelemetryService:LogCounter(module.TwoStepVerificationChallengeIDIsNilConfig)
	end
}
