local SocialStopwatch = script:FindFirstAncestor("SocialStopwatch")
local parent = SocialStopwatch.Parent
local HttpService = game:GetService("HttpService")

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Timers = SocialLuaAnalytics.Analytics.Timing.Timers
require(SocialStopwatch.Events)
local EventModes = require(SocialStopwatch.EventModes)
local EventRegister = require(SocialStopwatch.EventRegister)
local LoggingProtocol = require(parent.LoggingProtocol)
local StopwatchTelemetryConfig = require(SocialStopwatch.StopwatchTelemetryConfig)
require(script.Parent.Types)

return function()
	local v = {}
	local timers = Timers()
	local default = LoggingProtocol.default

	local v2 = "Get"

	local function fn(p) -- 3 equivalent calls inferred from this helper
		local v3 = EventRegister[p]

		if not v3 then
			error("Event not registered: " .. p)
		end

		return v3
	end

	local function fn2(p)
		local v3 = fn(p) -- inferred equivalent call
		local id = v[p]

		if not id then
			default:logRobloxTelemetryEvent(StopwatchTelemetryConfig, { default.StandardizedFields.addOsInfo }, {
				eventName = `FailedOn{v2}{p}`,
				count = 1
			})

			if v3.mode == EventModes.Strict then
				error(`Cannot {v2} an event that has not been started: {p}`)
			end
		end

		if id and timers.getStartTimestamp(id) then
			return {
				startTime = timers.getStartTimestamp(id),
				id = id,
				timeElapsed = timers.getTime(id)
			}
		end

		return nil
	end

	local v3 = "Stop"
	local function fn3(p)
		local v4 = fn(p) -- inferred equivalent call
		local id = v[p]

		if not id then
			default:logRobloxTelemetryEvent(StopwatchTelemetryConfig, { default.StandardizedFields.addOsInfo }, {
				eventName = `FailedOn{v3}{p}`,
				count = 1
			})

			if v4.mode == EventModes.Strict then
				error(`Cannot {v3} an event that has not been started: {p}`)
			end
		end

		if id and timers.getStartTimestamp(id) then
			return {
				startTime = timers.getStartTimestamp(id),
				id = id,
				timeElapsed = timers.getTime(id)
			}
		end

		return nil
	end

	return {
		start = function(p, p2)
			local v4 = fn(p) -- inferred equivalent call
			local id = timers.start(HttpService:GenerateGUID(false), p2)

			if v[p] then
				default:logRobloxTelemetryEvent(StopwatchTelemetryConfig, { default.StandardizedFields.addOsInfo }, {
					eventName = `FailedOnStart{p}`,
					count = 1
				})

				if v4.mode == EventModes.Strict then
					error("Cannot start event twice: " .. p)
				end
			end

			v[p] = id

			return { startTime = timers.getStartTimestamp(id), id = id }
		end,
		get = fn2,
		stop = function(p)
			local v4 = fn3(p)
			v[p] = nil
			return v4
		end,
		_unsafeClearEventLog = function()
			v = {}
		end
	}
end
