local HttpService = game:GetService("HttpService")
local SimpleTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Timing/SimpleTimer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Logger")

local function Timers(p2)
	local v5 = {}

	local function fn(p3)
		local v6 = p3 or HttpService:GenerateGUID(false)

		if v5[v6] then
			Logger:warning("(Start) Timer with this key already exists: " .. tostring(v6))

			return v6
		end

		local v7 = v5
		local v9 = {
			timeoutThreshold = p2 and p2.timeoutThreshold or nil,
			onReachingThreshold = 0
		}
		local fn2

		if p2 then
			local onReachingThreshold = p2.onReachingThreshold
			fn2 = onReachingThreshold and function()
				local v10 = v6

				if v5[v10] then
					v5[v10].clear()
					v5[v10] = nil
				else
					Logger:warning("(Clear) Timer with this key doesn't exist: " .. tostring(v10))
				end

				onReachingThreshold()
			end or nil
		end

		v9.onReachingThreshold = fn2
		v7[v6] = SimpleTimer(v9)
		return v6
	end

	return {
		start = function(p3, p4)
			local v6 = fn(p3)
			v5[v6].start(p4)

			return v6
		end,
		stop = function(p3)
			if not v5[p3] then
				Logger:warning("(Stop) Timer with this key doesn't exist: " .. tostring(p3))
				return -1
			end

			local v6 = v5[p3].stop()

			if not v5[p3] then
				Logger:warning("(Clear) Timer with this key doesn't exist: " .. tostring(p3))
				return v6
			end

			v5[p3].clear()
			v5[p3] = nil

			return v6
		end,
		getTime = function(p3)
			if v5[p3] then
				return v5[p3].getTime()
			end

			Logger:warning("(getTime) Timer with this key doesn't exist: " .. tostring(p3))
			return -1
		end,
		getStartTimestamp = function(p3)
			if v5[p3] then
				return v5[p3].getStartTimestamp()
			end

			Logger:warning("(startTimeStamp) Timer with this key doesn't exist: " .. tostring(p3))
			return nil
		end
	}
end

return Timers
