local HttpService = game:GetService("HttpService")
local SimpleTimer = require(script.Parent.SimpleTimer)
local Logger = require(script.Parent.Parent.Logger)

local function Timers(p)
	local v = {}

	local function fn(p2: string, onReachingThreshold) -- 1 equivalent call inferred from this helper
		if onReachingThreshold then
			return function()
				fn3(p2) -- inferred equivalent call
				onReachingThreshold()
			end
		end

		return nil
	end

	local function fn2(p2: string?)
		local selected = p2 or HttpService:GenerateGUID(false)

		if v[selected] then
			Logger:warning("(Start) Timer with this key already exists: " .. tostring(selected))

			return selected
		end

		local v2 = {
			timeoutThreshold = p and p.timeoutThreshold or nil,
			onReachingThreshold = 0
		}
		local onReachingThreshold

		if p then
			onReachingThreshold = fn(selected, p.onReachingThreshold) -- inferred equivalent call
		end

		v2.onReachingThreshold = onReachingThreshold
		v[selected] = SimpleTimer(v2)
		return selected
	end

	local function fn3(p2: string) -- 2 equivalent calls inferred from this helper
		if not v[p2] then
			Logger:warning("(Clear) Timer with this key doesn't exist: " .. tostring(p2))
			return
		end

		v[p2].clear()
		v[p2] = nil
	end

	return {
		start = function(p2: string?, p3)
			local v2 = fn2(p2)
			v[v2].start(p3)

			return v2
		end,
		stop = function(p2: string)
			if not v[p2] then
				Logger:warning("(Stop) Timer with this key doesn't exist: " .. tostring(p2))
				return -1
			end

			local v2 = v[p2].stop()
			fn3(p2) -- inferred equivalent call
			return v2
		end,
		getTime = function(p2: string)
			if v[p2] then
				return v[p2].getTime()
			end

			Logger:warning("(getTime) Timer with this key doesn't exist: " .. tostring(p2))
			return -1
		end,
		getStartTimestamp = function(p2: string)
			if v[p2] then
				return v[p2].getStartTimestamp()
			end

			Logger:warning("(startTimeStamp) Timer with this key doesn't exist: " .. tostring(p2))
			return nil
		end
	}
end

return Timers
