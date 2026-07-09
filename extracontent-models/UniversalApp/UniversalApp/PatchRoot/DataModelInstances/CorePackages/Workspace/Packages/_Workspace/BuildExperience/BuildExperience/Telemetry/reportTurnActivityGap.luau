local TelemetryService = game:GetService("TelemetryService")

game:DefineFastInt("BuildExperienceTurnActivityGapMsThrottleHundredthsPercent", 0)

local t1 = {
	eventName = "buildExperienceTurnActivityGapMs",
	description = "Milliseconds between visible chat-turn UI updates during a live CAS turn.",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2026,
		6,
		30
	}
}

local function shouldSample(n1: number) -- line: 15
	if n1 <= 0 then
		return false
	end

	if n1 >= 10000 then
		return true
	end

	return n1 >= math.random(1, 10000)
end

return {
	log = function(n2: number, b1: boolean, n3: number?) -- line: 25
		-- upvalues: TelemetryService (copy), t1 (copy)
		local FastInt = game:GetFastInt("BuildExperienceTurnActivityGapMsThrottleHundredthsPercent")

		if FastInt <= 0 or not (FastInt >= 10000) and not (FastInt >= math.random(1, 10000)) then
			return
		end

		TelemetryService:LogStat(t1, {
			customFields = {
				universeId = n3,
				isFirstActivity = b1
			}
		}, (math.max(0, (math.floor(n2 + 0.5)))))
	end,
	TurnActivityGapStatConfig = t1
}
