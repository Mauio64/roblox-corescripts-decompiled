local HttpService = game:GetService("HttpService")

local timers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialStopwatch/SocialLuaAnalytics").Analytics.Timing.Timers
require("@game/CorePackages/Workspace/Packages/_Index/SocialStopwatch/SocialStopwatch/Events")
local EventModes = require("@game/CorePackages/Workspace/Packages/_Index/SocialStopwatch/SocialStopwatch/EventModes")
local EventRegister = require("@game/CorePackages/Workspace/Packages/_Index/SocialStopwatch/SocialStopwatch/EventRegister")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/SocialStopwatch/LoggingProtocol")
local StopwatchTelemetryConfig = require("@game/CorePackages/Workspace/Packages/_Index/SocialStopwatch/SocialStopwatch/StopwatchTelemetryConfig")
require("@game/CorePackages/Workspace/Packages/_Index/SocialStopwatch/SocialStopwatch/Types")

return function()
	local v5 = {}
	local v6 = timers()
	local default = LoggingProtocol.default

	local v7 = "Get"
	local function fn(p2)
		local v8 = EventRegister[p2]

		if not v8 then
			error("Event not registered: " .. p2)
		end

		local v9 = v5[p2]

		if not v9 then
			default:logRobloxTelemetryEvent(StopwatchTelemetryConfig, { default.StandardizedFields.addOsInfo }, {
				eventName = `FailedOn{v7}{p2}`,
				count = 1
			})

			if v8.mode == EventModes.Strict then
				error(`Cannot {v7} an event that has not been started: {p2}`)
			end
		end

		if v9 and v6.getStartTimestamp(v9) then
			return {
				startTime = v6.getStartTimestamp(v9),
				id = v9,
				timeElapsed = v6.getTime(v9)
			}
		end

		return nil
	end

	local v8 = "Stop"
	local function fn2(p2)
		local v9 = EventRegister[p2]

		if not v9 then
			error("Event not registered: " .. p2)
		end

		local v10 = v5[p2]

		if not v10 then
			default:logRobloxTelemetryEvent(StopwatchTelemetryConfig, { default.StandardizedFields.addOsInfo }, {
				eventName = `FailedOn{v8}{p2}`,
				count = 1
			})

			if v9.mode == EventModes.Strict then
				error(`Cannot {v8} an event that has not been started: {p2}`)
			end
		end

		if v10 and v6.getStartTimestamp(v10) then
			return {
				startTime = v6.getStartTimestamp(v10),
				id = v10,
				timeElapsed = v6.getTime(v10)
			}
		end

		return nil
	end

	return {
		start = function(p2, p3)
			local v9 = EventRegister[p2]

			if not v9 then
				error("Event not registered: " .. p2)
			end

			local v10 = v6.start(HttpService:GenerateGUID(false), p3)

			if v5[p2] then
				default:logRobloxTelemetryEvent(StopwatchTelemetryConfig, { default.StandardizedFields.addOsInfo }, {
					eventName = `FailedOnStart{p2}`,
					count = 1
				})

				if v9.mode == EventModes.Strict then
					error("Cannot start event twice: " .. p2)
				end
			end

			v5[p2] = v10

			return { startTime = v6.getStartTimestamp(v10), id = v10 }
		end,
		get = fn,
		stop = function(p2)
			local v9 = fn2(p2)
			v5[p2] = nil
			return v9
		end,
		_unsafeClearEventLog = function()
			v5 = {}
		end
	}
end
