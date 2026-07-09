local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("GameTile").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("NotInterestedFeedbackFormActionThrottleHundredthsPercent", 0)
local FFlagLuaAppFixExplicitFeedbackTelemetry = require(Parent.SharedFlags).FFlagLuaAppFixExplicitFeedbackTelemetry
local v7 = t.strictInterface({
	ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t.string else nil,
	universeId = t.string,
	sortId = t.optional(t.string),
	actionType = t.string
})
local t1 = {
	eventName = "notInterestedFeedbackFormAction",
	description = "User has taken an action with the Not Interested Feedback Form",
	backends = { "EventIngest" },
	throttlingPercentage = v5,
	lastUpdated = {
		25,
		10,
		22
	}
}

return function(p1, s1: string) -- line: 30
	-- upvalues: FFlagLuaAppFixExplicitFeedbackTelemetry (copy), DiscoveryEventErrorLogger (copy), v7 (copy), TelemetryService (copy), t1 (copy)
	if FFlagLuaAppFixExplicitFeedbackTelemetry and not s1 then
		DiscoveryEventErrorLogger.reportError("NotInterestedFeedbackFormActionInvalidInterface", "event is missing context")
	end

	local v11, v12 = v7(p1)

	if not v11 then
		DiscoveryEventErrorLogger.reportError("NotInterestedFeedbackFormActionInvalidInterface", v12)
	end

	TelemetryService:LogEvent(t1, {
		eventContext = if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else s1,
		standardizedFields = { "addSessionInfo" },
		customFields = p1
	})
end
