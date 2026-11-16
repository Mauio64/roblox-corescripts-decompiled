local parent = script:FindFirstAncestor("GameDetail").Parent

local RunService = game:GetService("RunService")
local TelemetryService = game:GetService("TelemetryService")

local React = require(parent.React)
local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger

local defineFastInt = game:DefineFastInt("ExperienceDetailsMotionJitterHundredthsPercent", 0)

local v = {
	eventName = "ExperienceDetailsMotionJitterPercent",
	backends = { "RobloxTelemetryStat" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 6, 18 },
	description = "Reverse movement as a percentage of total experience details surface motion"
}

local function readPositionY(current, p: string) -- 1 equivalent call inferred from this helper
	return current[p].Y
end

local function logMotionJitter(p, surface: string, p2: string)
	Logger:info("[useMotionJitterMetric] Logging motion jitter")

	if p2 == "settled" then
		TelemetryService:LogStat(v, {
			standardizedFields = { "addOSInfo" },
			customFields = { surface = surface }
		}, p.jitterPx * 100 / p.travelPx)
	else
		Logger:warning("[useMotionJitterMetric] Should only log motion jitter for reason: settled")
	end
end

local function useMotionJitterMetric(p, p2: string, flag: boolean, p3: string)
	React.useEffect(function()
		if defineFastInt <= 0 then
			return
		end

		local v2 = nil
		local v3 = nil

		local function flushMotion(p4: string)
			Logger:info("[useMotionJitterMetric] Flushing motion metric for reason: " .. p4)

			if v3 then
				logMotionJitter(v3, p2, p4)
				v3 = nil
			end
		end

		local renderSteppedConnection = nil
		renderSteppedConnection = RunService.RenderStepped:Connect(function()
			local current = p.current

			if current then
				local positionY = readPositionY(current, p3) -- inferred equivalent call

				if v2 == nil then
					if positionY >= 0 then
						v2 = positionY
					end
				else
					local v4 = positionY - v2
					v2 = positionY

					if math.abs(v4) <= 0.5 then
						if v3 then
							v3.settledFrames += 1

							if v3.settledFrames >= 6 then
								Logger:info("[useMotionJitterMetric] Flushing motion metric for reason: settled")

								if v3 then
									logMotionJitter(v3, p2, "settled")
									v3 = nil
								end

								if renderSteppedConnection then
									renderSteppedConnection:Disconnect()
								end
							end
						end
					else
						if not v3 then
							v3 = { jitterPx = 0, travelPx = 0, settledFrames = 0 }
						end

						local v5 = v3
						v5.travelPx += math.abs(v4)
						v5.settledFrames = 0

						if v4 * (flag and 1 or -1) < -0.5 then
							v5.jitterPx += math.abs(v4)
						end
					end
				end
			else
				Logger:info("[useMotionJitterMetric] Flushing motion metric for reason: missingContent")

				if v3 then
					Logger:info("[useMotionJitterMetric] Logging motion jitter")

					Logger:warning("[useMotionJitterMetric] Should only log motion jitter for reason: settled")

					v3 = nil
				end

				v2 = nil
			end
		end)

		return function()
			Logger:info("[useMotionJitterMetric] Flushing motion metric for reason: unmount")

			if v3 then
				Logger:info("[useMotionJitterMetric] Logging motion jitter")

				Logger:warning("[useMotionJitterMetric] Should only log motion jitter for reason: settled")

				v3 = nil
			end

			if renderSteppedConnection then
				renderSteppedConnection:Disconnect()
			end
		end
	end, { p, p2, flag, p3 })
end

return useMotionJitterMetric
