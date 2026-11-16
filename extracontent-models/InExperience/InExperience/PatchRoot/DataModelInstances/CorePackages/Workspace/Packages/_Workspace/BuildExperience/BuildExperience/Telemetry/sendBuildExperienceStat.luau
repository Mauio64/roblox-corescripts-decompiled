local TelemetryService = game:GetService("TelemetryService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")

local shouldSampleHundredthsPercent = require(BuildExperience.Telemetry.shouldSampleHundredthsPercent)

local function sendBuildExperienceStat(data)
	local sampleHundredthsPercent = data.sampleHundredthsPercent

	if sampleHundredthsPercent and not shouldSampleHundredthsPercent(sampleHundredthsPercent) then
		return
	end

	TelemetryService:LogStat(data.config, { customFields = data.customFields }, data.value)
end

return sendBuildExperienceStat
