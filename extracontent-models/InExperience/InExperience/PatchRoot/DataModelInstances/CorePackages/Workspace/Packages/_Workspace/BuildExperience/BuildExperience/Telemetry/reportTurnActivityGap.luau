local TelemetryService = game:GetService("TelemetryService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local SharedFlags = require(parent.SharedFlags)

local sendBuildExperienceStat = require(BuildExperience.Telemetry.sendBuildExperienceStat)

local FFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry

game:DefineFastInt("BuildExperienceTurnActivityGapMsThrottleHundredthsPercent", 0)

local v = {
	eventName = "buildExperienceTurnActivityGapMs",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2026, 6, 30 },
	description = "Milliseconds between visible chat-turn UI updates during a live CAS turn."
}

local function shouldSample(fastInt: number): boolean -- 1 equivalent call inferred from this helper
	return not (fastInt <= 0) and (fastInt >= 10000 or math.random(1, 10000) <= fastInt)
end

return {
	log = function(p: number, isFirstActivity: boolean, universeId: number?)
		if FFlagBuildExperiencePromptFailureTelemetry then
			sendBuildExperienceStat({
				config = v,
				sampleHundredthsPercent = game:GetFastInt("BuildExperienceTurnActivityGapMsThrottleHundredthsPercent"),
				value = math.max(0, (math.round(p))),
				customFields = { universeId = universeId, isFirstActivity = isFirstActivity }
			})

			return
		end

		if not shouldSample(game:GetFastInt("BuildExperienceTurnActivityGapMsThrottleHundredthsPercent")) then -- inferred equivalent call
			return
		end

		TelemetryService:LogStat(v, {
			customFields = { universeId = universeId, isFirstActivity = isFirstActivity }
		}, (math.max(0, (math.floor(p + 0.5)))))
	end,
	TurnActivityGapStatConfig = v
}
