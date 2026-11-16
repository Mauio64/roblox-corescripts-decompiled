local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local FIntMenuButtonsThrottleHundredthsPercent = require(RobloxGui.Modules.Settings.Flags.FIntMenuButtonsThrottleHundredthsPercent)

return {
	eventName = "experienceMenuLeaveGame",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = FIntMenuButtonsThrottleHundredthsPercent,
	lastUpdated = { 25, 4, 23 },
	description = "Report when leave button in experience menu is activated"
}
