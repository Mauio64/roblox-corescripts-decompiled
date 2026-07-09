local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local TelemetryService = game:GetService("TelemetryService")
local MetricsConstants = require(AccountRecovery.Analytics.MetricsConstants)

return {
	reportTwoStepVerificationChallengeIDIsNil = function() -- line: 7
		-- upvalues: TelemetryService (copy), MetricsConstants (copy)
		TelemetryService:LogCounter(MetricsConstants.TwoStepVerificationChallengeIDIsNilConfig)
	end
}
