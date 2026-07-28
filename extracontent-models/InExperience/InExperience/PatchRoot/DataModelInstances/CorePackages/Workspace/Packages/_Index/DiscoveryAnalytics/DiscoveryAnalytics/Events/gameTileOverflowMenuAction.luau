local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("GameTileOverflowMenuActionThrottleHundrethsPercent", 0)
local FFlagLuaAppFixExplicitFeedbackTelemetry = require(Parent.SharedFlags).FFlagLuaAppFixExplicitFeedbackTelemetry
local v7 = t.strictInterface({
	ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t.string else nil,
	universeId = t.string,
	sortId = t.optional(t.string),
	actionType = t.string,
	menuItem = t.optional(t.string),
	availableMenuItems = t.optional(t.string)
})

return function(p1, s1: string) -- line: 22
	-- upvalues: FFlagLuaAppFixExplicitFeedbackTelemetry (copy), DiscoveryEventErrorLogger (copy), v7 (copy), v5 (copy), TelemetryService (copy)
	if FFlagLuaAppFixExplicitFeedbackTelemetry and not s1 then
		DiscoveryEventErrorLogger.reportError("GameTileOverflowMenuActionInvalidInterface", "event is missing context")
	end

	local v10, v11 = v7(p1)

	if not v10 then
		DiscoveryEventErrorLogger.reportError("GameTileOverflowMenuActionInvalidInterface", v11)
	end

	local t1 = {
		eventName = "gameTileOverflowMenuAction",
		description = "User has taken an action with the Game Tile Overflow Menu",
		backends = { "EventIngest" },
		throttlingPercentage = v5,
		lastUpdated = {
			25,
			10,
			15
		}
	}

	TelemetryService:LogEvent(t1, {
		eventContext = if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else s1,
		standardizedFields = { "addSessionInfo" },
		customFields = p1
	})
end
