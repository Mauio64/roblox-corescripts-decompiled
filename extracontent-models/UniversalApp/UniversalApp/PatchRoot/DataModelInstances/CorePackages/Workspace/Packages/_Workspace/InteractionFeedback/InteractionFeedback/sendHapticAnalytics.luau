local TelemetryService = game:GetService("TelemetryService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Parent = script:FindFirstAncestor("InteractionFeedback").Parent
local t = require(Parent.t)
local flaggedMutedError = require(Parent.Loggers).flaggedMutedError
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v7 = game:DefineFastInt("HapticTriggerAttemptThrottleHundredthsPercent", 0)
local FFlagLuaAppFixExplicitFeedbackTelemetry = require(Parent.SharedFlags).FFlagLuaAppFixExplicitFeedbackTelemetry
local v9 = t.interface({
	hapticType = t.string,
	contextKey = t.string,
	interactionType = t.string,
	ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t.string else nil
})

return function(p1, s1: string) -- line: 24
	-- upvalues: FFlagLuaAppFixExplicitFeedbackTelemetry (copy), DiscoveryEventErrorLogger (copy), v9 (copy), flaggedMutedError (copy), v7 (copy), UserGameSettings (copy), TelemetryService (copy)
	if FFlagLuaAppFixExplicitFeedbackTelemetry and not s1 then
		DiscoveryEventErrorLogger.reportError("HapticTriggerAttemptInvalidInterface", "event is missing context")
	end

	local v12, v13 = v9(p1)

	if not v12 then
		if FFlagLuaAppFixExplicitFeedbackTelemetry then
			DiscoveryEventErrorLogger.reportError("HapticTriggerAttemptInvalidInterface", v13)
		else
			flaggedMutedError("HapticTriggerAttemptInvalidInterface", v13)
		end
	end

	local t1 = {
		eventName = "hapticTriggerAttempt",
		description = "User has taken an action that may have triggered haptic feedback",
		backends = { "EventIngest" },
		throttlingPercentage = v7,
		lastUpdated = {
			25,
			10,
			21
		}
	}
	local HapticStrength = UserGameSettings.HapticStrength

	p1.hapticEnabledByUser = HapticStrength > 0
	p1.hapticStrength = HapticStrength
	TelemetryService:LogEvent(t1, {
		eventContext = if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else s1,
		standardizedFields = {
			"addOSInfo",
			"addSessionInfo"
		},
		customFields = p1
	})
end
