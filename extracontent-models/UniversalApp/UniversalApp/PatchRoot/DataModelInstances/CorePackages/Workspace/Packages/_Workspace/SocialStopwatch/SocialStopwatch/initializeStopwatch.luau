local SocialStopwatch = script:FindFirstAncestor("SocialStopwatch")
local SocialStopwatchParent = SocialStopwatch.Parent
local HttpService = game:GetService("HttpService")
local Timers = require(SocialStopwatchParent.SocialLuaAnalytics).Analytics.Timing.Timers

require(SocialStopwatch.Events)

local EventModes = require(SocialStopwatch.EventModes)
local EventRegister = require(SocialStopwatch.EventRegister)
local LoggingProtocol = require(SocialStopwatchParent.LoggingProtocol)
local StopwatchTelemetryConfig = require(SocialStopwatch.StopwatchTelemetryConfig)

require(script.Parent.Types)

return function() -- line: 21
	-- upvalues: Timers (copy), LoggingProtocol (copy), EventRegister (copy), StopwatchTelemetryConfig (copy), EventModes (copy), HttpService (copy)
	local t1 = {}
	local v10 = Timers()
	local default = LoggingProtocol.default
	local s1 = "Get"
	local s2 = "Stop"

	local function v14(p1) -- line: 35
		-- upvalues: EventRegister (copy), t1 (ref), default (copy), StopwatchTelemetryConfig (copy), s2 (copy), EventModes (copy), v10 (copy)
		local v22 = EventRegister[p1]

		if not v22 then
			error("Event not registered: " .. p1)
		end

		local v23 = t1[p1]

		if not v23 then
			default:logRobloxTelemetryEvent(StopwatchTelemetryConfig, { default.StandardizedFields.addOsInfo }, {
				count = 1,
				eventName = `FailedOn{ s2 }{ p1 }`
			})

			if v22.mode == EventModes.Strict then
				error(`Cannot { s2 } an event that has not been started: { p1 }`)
			end
		end

		if v23 and v10.getStartTimestamp(v23) then
			return {
				startTime = v10.getStartTimestamp(v23),
				id = v23,
				timeElapsed = v10.getTime(v23)
			}
		end

		return nil
	end

	return {
		start = function(p2, p3) -- line: 65
			-- upvalues: EventRegister (copy), v10 (copy), HttpService (copy), t1 (ref), default (copy), StopwatchTelemetryConfig (copy), EventModes (copy)
			local v26 = EventRegister[p2]

			if not v26 then
				error("Event not registered: " .. p2)
			end

			local v27 = v10.start(HttpService:GenerateGUID(false), p3)

			if t1[p2] then
				default:logRobloxTelemetryEvent(StopwatchTelemetryConfig, { default.StandardizedFields.addOsInfo }, {
					count = 1,
					eventName = `FailedOnStart{ p2 }`
				})

				if v26.mode == EventModes.Strict then
					error("Cannot start event twice: " .. p2)
				end
			end

			t1[p2] = v27

			return {
				startTime = v10.getStartTimestamp(v27),
				id = v27
			}
		end,
		get = function(p4) -- line: 35
			-- upvalues: EventRegister (copy), t1 (ref), default (copy), StopwatchTelemetryConfig (copy), s1 (copy), EventModes (copy), v10 (copy)
			local v19 = EventRegister[p4]

			if not v19 then
				error("Event not registered: " .. p4)
			end

			local v20 = t1[p4]

			if not v20 then
				default:logRobloxTelemetryEvent(StopwatchTelemetryConfig, { default.StandardizedFields.addOsInfo }, {
					count = 1,
					eventName = `FailedOn{ s1 }{ p4 }`
				})

				if v19.mode == EventModes.Strict then
					error(`Cannot { s1 } an event that has not been started: { p4 }`)
				end
			end

			if v20 and v10.getStartTimestamp(v20) then
				return {
					startTime = v10.getStartTimestamp(v20),
					id = v20,
					timeElapsed = v10.getTime(v20)
				}
			end

			return nil
		end,
		stop = function(p5) -- line: 90
			-- upvalues: v14 (copy), t1 (ref)
			local v29 = v14(p5)

			t1[p5] = nil

			return v29
		end,
		_unsafeClearEventLog = function() -- line: 95
			-- upvalues: t1 (ref)
			t1 = {}
		end
	}
end
