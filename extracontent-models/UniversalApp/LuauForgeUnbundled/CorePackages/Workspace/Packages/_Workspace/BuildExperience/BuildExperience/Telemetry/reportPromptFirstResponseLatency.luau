local FIntBuildExperiencePromptFirstResponseMsThrottleHundredthsPercent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FIntBuildExperiencePromptFirstResponseMsThrottleHundredthsPercent")
local sendBuildExperienceStat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceStat")

local v5 = {
	eventName = "buildExperiencePromptFirstResponseMs",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2026, 10, 8 },
	description = "Milliseconds from sending a Build chat prompt to its first visible response (agent text or tool activity), including backend retries."
}

local function reportPromptFirstResponseLatency(p2, p3)
	sendBuildExperienceStat({
		config = v5,
		sampleHundredthsPercent = FIntBuildExperiencePromptFirstResponseMsThrottleHundredthsPercent,
		value = math.max(0, (math.round(p2))),
		customFields = { stalled = p3 }
	})
end

return reportPromptFirstResponseLatency
