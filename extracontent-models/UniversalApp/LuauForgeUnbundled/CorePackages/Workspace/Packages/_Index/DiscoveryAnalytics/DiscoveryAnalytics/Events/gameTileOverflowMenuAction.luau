local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("GameTileOverflowMenuActionThrottleHundrethsPercent", 0)

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags")
local fFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local fFlagLuaAppGameTileDirectActionTelemetry = SharedFlags.FFlagLuaAppGameTileDirectActionTelemetry
local fFlagSduiGameTileDirectAction = SharedFlags.FFlagSduiGameTileDirectAction

local strictInterface = t.strictInterface
local v5 = {
	universeId = t.string,
	sortId = t.optional(t.string),
	actionType = t.string,
	menuItem = t.optional(t.string),
	availableMenuItems = t.optional(t.string),
	contentType = 0,
	isDirectAction = 0
}
local v6 = if fFlagLuaAppEnableNxMRoduxApportioning then t.optional(t.string) else nil
v5.contentType = v6

local v7 = if fFlagLuaAppGameTileDirectActionTelemetry or fFlagSduiGameTileDirectAction then t.optional(t.boolean) else nil
v5.isDirectAction = v7
local v8 = strictInterface(v5)

return function(p2, p3)
	if not p3 then
		discoveryEventErrorLogger.reportError(
			"GameTileOverflowMenuActionInvalidInterface",
			"event is missing context"
		)
	end

	local v9, v10 = v8(p2)

	if not v9 then
		discoveryEventErrorLogger.reportError("GameTileOverflowMenuActionInvalidInterface", v10)
	end

	TelemetryService:LogEvent({
		eventName = "gameTileOverflowMenuAction",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 9, 23 },
		description = "User has taken an action with the Game Tile Overflow Menu"
	}, {
		eventContext = p3,
		standardizedFields = { "addSessionInfo" },
		customFields = p2
	})
end
