local RunService = game:GetService("RunService")
local TelemetryService = game:GetService("TelemetryService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Loggers").Logger

local defineFastInt = game:DefineFastInt("ExperienceDetailsMotionJitterHundredthsPercent", 0)

local v5 = {
	eventName = "ExperienceDetailsMotionJitterPercent",
	backends = { "RobloxTelemetryStat" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 6, 18 },
	description = "Reverse movement as a percentage of total experience details surface motion"
}

local function readPositionY(p2, p3)
	return p2[p3].Y
end

local function logMotionJitter(p2, p3, p4)
	logger:info("[useMotionJitterMetric] Logging motion jitter")

	if p4 == "settled" then
		TelemetryService:LogStat(v5, {
			standardizedFields = { "addOSInfo" },
			customFields = { surface = p3 }
		}, p2.jitterPx * 100 / p2.travelPx)
	else
		logger:warning("[useMotionJitterMetric] Should only log motion jitter for reason: settled")
	end
end

local function useMotionJitterMetric(p2, p3, p4, p5)
	React.useEffect(function()
		if defineFastInt <= 0 then
			return
		end

		local v6 = nil
		local v7 = nil

		local function flushMotion(p6)
			logger:info("[useMotionJitterMetric] Flushing motion metric for reason: " .. p6)

			if v7 then
				logMotionJitter(v7, p3, p6)
				v7 = nil
			end
		end

		local renderSteppedConnection = nil
		renderSteppedConnection = RunService.RenderStepped:Connect(function()
			local current = p2.current

			if current then
				local y = current[p5].Y

				if v6 == nil then
					if y >= 0 then
						v6 = y
					end
				else
					local v8 = y - v6
					v6 = y

					if math.abs(v8) <= 0.5 then
						if v7 then
							v7.settledFrames += 1

							if v7.settledFrames >= 6 then
								logger:info("[useMotionJitterMetric] Flushing motion metric for reason: settled")

								if v7 then
									logMotionJitter(v7, p3, "settled")
									v7 = nil
								end

								if renderSteppedConnection then
									renderSteppedConnection:Disconnect()
								end
							end
						end
					else
						if not v7 then
							v7 = { jitterPx = 0, travelPx = 0, settledFrames = 0 }
						end

						local v9 = v7
						v9.travelPx += math.abs(v8)
						v9.settledFrames = 0

						if v8 * (p4 and 1 or -1) < -0.5 then
							v9.jitterPx += math.abs(v8)
						end
					end
				end
			else
				logger:info("[useMotionJitterMetric] Flushing motion metric for reason: missingContent")

				if v7 then
					logger:info("[useMotionJitterMetric] Logging motion jitter")

					logger:warning("[useMotionJitterMetric] Should only log motion jitter for reason: settled")

					v7 = nil
				end

				v6 = nil
			end
		end)

		return function()
			logger:info("[useMotionJitterMetric] Flushing motion metric for reason: unmount")

			if v7 then
				logger:info("[useMotionJitterMetric] Logging motion jitter")

				logger:warning("[useMotionJitterMetric] Should only log motion jitter for reason: settled")

				v7 = nil
			end

			if renderSteppedConnection then
				renderSteppedConnection:Disconnect()
			end
		end
	end, { p2, p3, p4, p5 })
end

return useMotionJitterMetric
