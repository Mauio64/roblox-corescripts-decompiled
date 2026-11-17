local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("GameTileOverflowMenuActionThrottleHundrethsPercent", 0)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppGameTileDirectActionTelemetry = SharedFlags.FFlagLuaAppGameTileDirectActionTelemetry
local FFlagSduiGameTileDirectAction = SharedFlags.FFlagSduiGameTileDirectAction

local strictInterface = t.strictInterface
local v = {
	universeId = t.string,
	sortId = t.optional(t.string),
	actionType = t.string,
	menuItem = t.optional(t.string),
	availableMenuItems = t.optional(t.string),
	contentType = 0,
	isDirectAction = 0
}
local contentType

if FFlagLuaAppEnableNxMRoduxApportioning then
	contentType = t.optional(t.string)
end

v.contentType = contentType
local isDirectAction

if FFlagLuaAppGameTileDirectActionTelemetry or FFlagSduiGameTileDirectAction then
	isDirectAction = t.optional(t.boolean)
end

v.isDirectAction = isDirectAction
local v2 = strictInterface(v)

return function(customFields, eventContext: string)
	if not eventContext then
		DiscoveryEventErrorLogger.reportError("GameTileOverflowMenuActionInvalidInterface", "event is missing context")
	end

	local v3, v4 = v2(customFields)

	if not v3 then
		DiscoveryEventErrorLogger.reportError("GameTileOverflowMenuActionInvalidInterface", v4)
	end

	TelemetryService:LogEvent({
		eventName = "gameTileOverflowMenuAction",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 9, 23 },
		description = "User has taken an action with the Game Tile Overflow Menu"
	}, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
