local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Logger")

local function SimpleTimer(p2)
	local v5 = nil
	local now = nil
	local v6 = nil

	local thread = nil
	local timeoutThreshold = if p2 then p2.timeoutThreshold or nil else nil
	local onReachingThreshold = p2 and p2.onReachingThreshold or nil

	return {
		start = function(p3)
			if v5 then
				Logger:warning("Timer has been already started")
			else
				v5 = os.clock()
				v6 = p3 or DateTime.now()

				if p3 then
					local v7 = v6
					local now2 = DateTime.now()
					v5 = (v7.UnixTimestampMillis - now2.UnixTimestampMillis) / 1000
				end

				if timeoutThreshold then
					if not onReachingThreshold then
						return
					end

					local v7 = onReachingThreshold

					thread = task.delay(timeoutThreshold, function()
						thread = nil
						v7()
					end)
				end
			end
		end,
		getStartTimestamp = function()
			if v6 then
				return v6
			end

			Logger:warning("Timer has not been started yet")
			return nil
		end,
		stop = function()
			if thread then
				task.cancel(thread)
			end

			if v5 and not now then
				now = os.clock()
			elseif v5 then
				Logger:warning("Timer has been already stopped")
			else
				Logger:warning("Timer has not been started yet")
			end

			if v5 and now then
				return now - v5
			end

			return -1
		end,
		clear = function()
			v5 = nil
			now = nil

			if thread then
				task.cancel(thread)
			end
		end,
		getTime = function()
			local now2 = nil

			if v5 and not now then
				now2 = os.clock()
			elseif v5 then
				Logger:warning("Timer has been already stopped")
			else
				Logger:warning("Timer has not been started yet")
			end

			if v5 and now2 then
				return now2 - v5
			end

			return -1
		end
	}
end

return SimpleTimer
