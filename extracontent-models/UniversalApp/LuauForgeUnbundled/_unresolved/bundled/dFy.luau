local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local Navigation = require("@game/CorePackages/Workspace/Packages/Navigation")
local module3 = require("@luauforge/bundled/dFz")
local module4 = require("@luauforge/bundled/dFA")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local fFlagSignalsNavProjected = SharedFlags.FFlagSignalsNavProjected
local v5 = if SharedFlags.FFlagSignalsNavPendingLock then require("@luauforge/bundled/hTO") else nil

local v6 = {
	eventName = "SignalsNavPendingLockFailsafeRelease",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 11, 10 },
	description = "A pending navigation command was released by the failsafe because RoactNavigation never reported it; expected to be near zero. Labels: action_type, target_route, committed (RoactNavigation committed it but the release did not run), app_hidden (the app was hidden after it was dispatched).",
	links = ""
}

local function onPendingFailsafeRelease(p2, p3, p4)
	local lastHiddenAt = v5.getLastHiddenAt()
	local default = LoggingProtocol.default
	local v9 = {
		action_type = tostring(p2.type),
		target_route = module3.resolveNavigationTarget(p2) or "none",
		committed = tostring(p3),
		app_hidden = 0
	}
	local v10 = not (lastHiddenAt == nil) and p4 <= lastHiddenAt
	v9.app_hidden = tostring(v10)
	default:logRobloxTelemetryCounter(v6, 1, v9)
end

local v7

if fFlagSignalsNavProjected then
	v7 = Navigation.createProjectedNavigationObject(module4.router, {
		onPendingFailsafeRelease = onPendingFailsafeRelease
	})
else
	v7 = Navigation.createSignalsNavigationObject(module4.router)
end

if fFlagSignalsNavP2NavigationPrimitives then
	module3.AppNavigationRegistry.register(v7)
end

return v7
