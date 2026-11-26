local TelemetryService = game:GetService("TelemetryService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")

local sendBuildExperienceStat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceStat")

local fFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry

game:DefineFastInt("BuildExperienceTurnActivityGapMsThrottleHundredthsPercent", 0)

local v5 = {
	eventName = "buildExperienceTurnActivityGapMs",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2026, 6, 30 },
	description = "Milliseconds between visible chat-turn UI updates during a live CAS turn."
}

local function shouldSample(p2): boolean
	if p2 <= 0 then
		return false
	end

	if p2 >= 10000 then
		return true
	end

	return math.random(1, 10000) <= p2
end

return {
	log = function(p2, p3, p4)
		if fFlagBuildExperiencePromptFailureTelemetry then
			sendBuildExperienceStat({
				config = v5,
				sampleHundredthsPercent = game:GetFastInt("BuildExperienceTurnActivityGapMsThrottleHundredthsPercent"),
				value = math.max(0, (math.round(p2))),
				customFields = { universeId = p4, isFirstActivity = p3 }
			})

			return
		end

		local fastInt = game:GetFastInt("BuildExperienceTurnActivityGapMsThrottleHundredthsPercent")
		local v6 = not (fastInt <= 0) and (fastInt >= 10000 or math.random(1, 10000) <= fastInt)

		if not v6 then
			return
		end

		TelemetryService:LogStat(v5, {
			customFields = { universeId = p4, isFirstActivity = p3 }
		}, (math.max(0, (math.floor(p2 + 0.5)))))
	end,
	TurnActivityGapStatConfig = v5
}
