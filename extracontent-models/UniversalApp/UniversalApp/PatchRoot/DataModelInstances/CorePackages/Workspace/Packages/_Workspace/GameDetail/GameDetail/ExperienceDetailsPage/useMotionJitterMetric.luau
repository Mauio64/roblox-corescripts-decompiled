local Parent = script:FindFirstAncestor("GameDetail").Parent
local RunService = game:GetService("RunService")
local TelemetryService = game:GetService("TelemetryService")
local React = require(Parent.React)
local Logger = require(Parent.Loggers).Logger
local v6 = game:DefineFastInt("ExperienceDetailsMotionJitterHundredthsPercent", 0)
local t1 = {
	eventName = "ExperienceDetailsMotionJitterPercent",
	description = "Reverse movement as a percentage of total experience details surface motion",
	backends = { "RobloxTelemetryStat" },
	throttlingPercentage = v6,
	lastUpdated = {
		2026,
		6,
		18
	}
}

local function readPositionY(p1, s1: string) -- line: 32
	return p1[s1].Y
end
local function logMotionJitter(t2: {[any]: any}, s2: string, s3: string) -- line: 36
	-- upvalues: Logger (copy), TelemetryService (copy), t1 (copy)
	Logger:info("[useMotionJitterMetric] Logging motion jitter")

	if s3 ~= "settled" then
		Logger:warning("[useMotionJitterMetric] Should only log motion jitter for reason: settled")

		return
	end

	TelemetryService:LogStat(t1, {
		standardizedFields = { "addOSInfo" },
		customFields = {
			surface = s2
		}
	}, t2.jitterPx * 100 / t2.travelPx)
end
local function useMotionJitterMetric(p2, s4: string, b1: boolean, s5: string) -- line: 52
	-- upvalues: React (copy), v6 (copy), Logger (copy), logMotionJitter (copy), RunService (copy)
	React.useEffect(function() -- line: 58
		-- upvalues: v6 (copy), Logger (copy), logMotionJitter (copy), s4 (copy), RunService (copy), p2 (copy), s5 (copy), b1 (copy)
		if v6 <= 0 then
			return
		end

		local u20 = nil
		local u21 = nil

		local function flushMotion(s6: string) -- line: 66
			-- upvalues: Logger (copy), u21 (ref), logMotionJitter (copy), s4 (copy)
			Logger:info("[useMotionJitterMetric] Flushing motion metric for reason: " .. s6)

			if u21 then
				logMotionJitter(u21, s4, s6)
				u21 = nil
			end
		end

		local connection = nil

		connection = RunService.RenderStepped:Connect(function() -- line: 75
			-- upvalues: p2 (copy), Logger (copy), u21 (ref), s4 (copy), u20 (ref), s5 (copy), logMotionJitter (copy), connection (ref), b1 (copy)
			local current = p2.current

			if not current then
				Logger:info("[useMotionJitterMetric] Flushing motion metric for reason: missingContent")

				if u21 then
					local _ = u21
					local _ = s4

					Logger:info("[useMotionJitterMetric] Logging motion jitter")
					Logger:warning("[useMotionJitterMetric] Should only log motion jitter for reason: settled")
					u21 = nil
				end

				u20 = nil

				return
			end

			local Y = current[s5].Y

			if u20 == nil then
				if Y >= 0 then
					u20 = Y
				end

				return
			end

			local v29 = Y - u20

			u20 = Y

			if math.abs(v29) <= 0.5 then
				if u21 then
					local v30 = u21

					v30.settledFrames = v30.settledFrames + 1

					if u21.settledFrames >= 6 then
						Logger:info("[useMotionJitterMetric] Flushing motion metric for reason: settled")

						if u21 then
							logMotionJitter(u21, s4, "settled")
							u21 = nil
						end

						if connection then
							connection:Disconnect()
						end
					end
				end

				return
			end

			if not u21 then
				u21 = {
					jitterPx = 0,
					travelPx = 0,
					settledFrames = 0
				}
			end

			local v31 = u21

			v31.travelPx = v31.travelPx + math.abs(v29)
			v31.settledFrames = 0

			if v29 * (not b1 and -1 or 1) < -0.5 then
				v31.jitterPx = v31.jitterPx + math.abs(v29)
			end
		end)

		return function() -- line: 122
			-- upvalues: Logger (copy), u21 (ref), s4 (copy), connection (ref)
			Logger:info("[useMotionJitterMetric] Flushing motion metric for reason: unmount")

			if u21 then
				local _ = u21
				local _ = s4

				Logger:info("[useMotionJitterMetric] Logging motion jitter")
				Logger:warning("[useMotionJitterMetric] Should only log motion jitter for reason: settled")
				u21 = nil
			end

			if connection then
				connection:Disconnect()
			end
		end
	end, {
		p2,
		s4,
		b1,
		s5
	})
end

return useMotionJitterMetric
