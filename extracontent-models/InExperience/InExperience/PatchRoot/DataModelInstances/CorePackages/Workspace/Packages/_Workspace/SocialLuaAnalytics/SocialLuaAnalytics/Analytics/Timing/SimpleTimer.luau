local Logger = require(script.Parent.Parent.Logger)

local function fn(p, p2) -- 1 equivalent call inferred from this helper
	return (p.UnixTimestampMillis - p2.UnixTimestampMillis) / 1000
end

local function SimpleTimer(p)
	local v = nil
	local now = nil
	local v2 = nil

	local thread = nil
	local timeoutThreshold

	if p then
		timeoutThreshold = p.timeoutThreshold or nil
	else
		timeoutThreshold = nil
	end

	local onReachingThreshold = p and p.onReachingThreshold or nil

	local function fn2() -- 1 equivalent call inferred from this helper
		if v and now then
			return now - v
		end

		return -1
	end

	local function fn3() -- 2 equivalent calls inferred from this helper
		if thread then
			task.cancel(thread)
		end
	end

	return {
		start = function(p2)
			if v then
				Logger:warning("Timer has been already started")
			else
				v = os.clock()
				v2 = p2 or DateTime.now()

				if p2 then
					v = fn(v2, DateTime.now()) -- inferred equivalent call
				end

				if timeoutThreshold then
					if not onReachingThreshold then
						return
					end

					local v3 = onReachingThreshold

					thread = task.delay(timeoutThreshold, function()
						thread = nil
						v3()
					end)
				end
			end
		end,
		getStartTimestamp = function()
			if v2 then
				return v2
			end

			Logger:warning("Timer has not been started yet")
			return nil
		end,
		stop = function()
			fn3() -- inferred equivalent call

			if v and not now then
				now = os.clock()
			elseif v then
				Logger:warning("Timer has been already stopped")
			else
				Logger:warning("Timer has not been started yet")
			end

			return fn2() -- inferred equivalent call
		end,
		clear = function()
			v = nil
			now = nil
			fn3() -- inferred equivalent call
		end,
		getTime = function()
			local now2 = nil

			if v and not now then
				now2 = os.clock()
			elseif v then
				Logger:warning("Timer has been already stopped")
			else
				Logger:warning("Timer has not been started yet")
			end

			if v and now2 then
				return now2 - v
			end

			return -1
		end
	}
end

return SimpleTimer
