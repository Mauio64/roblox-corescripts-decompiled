local Logger = require(script.Parent.Parent.Logger)

local function SimpleTimer(t1: {[any]: any}?) -- line: 23
	-- upvalues: Logger (copy)
	local elapsed = nil
	local elapsed2 = nil
	local u8 = nil
	local u9 = nil
	local v10 = t1 and t1.timeoutThreshold or nil
	local v11 = t1 and t1.onReachingThreshold or nil

	return {
		start = function(p1) -- line: 79
			-- upvalues: elapsed (ref), u8 (ref), v10 (copy), v11 (copy), u9 (ref), Logger (copy)
			if not elapsed then
				elapsed = os.clock()
				u8 = p1 or DateTime.now()

				if p1 then
					local v15 = u8
					local dateTime = DateTime.now()

					elapsed = (v15.UnixTimestampMillis - dateTime.UnixTimestampMillis) / 1000
				end

				if v10 then
					if not v11 then
						return
					end

					local v17 = v11

					u9 = task.delay(v10, function() -- line: 73
						-- upvalues: u9 (ref), v17 (copy)
						u9 = nil
						v17()
					end)

					return
				end
			else
				Logger:warning("Timer has been already started")
			end
		end,
		getStartTimestamp = function() -- line: 106
			-- upvalues: u8 (ref), Logger (copy)
			if not u8 then
				Logger:warning("Timer has not been started yet")

				return nil
			end

			return u8
		end,
		stop = function() -- line: 92
			-- upvalues: u9 (ref), elapsed (ref), elapsed2 (ref), Logger (copy)
			if u9 then
				task.cancel(u9)
			end

			if elapsed and not elapsed2 then
				elapsed2 = os.clock()
			elseif not elapsed then
				Logger:warning("Timer has not been started yet")
			else
				Logger:warning("Timer has been already stopped")
			end

			if elapsed and elapsed2 then
				return elapsed2 - elapsed
			end

			return -1
		end,
		clear = function() -- line: 60
			-- upvalues: elapsed (ref), elapsed2 (ref), u9 (ref)
			elapsed = nil
			elapsed2 = nil

			if u9 then
				task.cancel(u9)
			end
		end,
		getTime = function() -- line: 40
			-- upvalues: elapsed (ref), elapsed2 (ref), Logger (copy)
			local elapsed3 = nil

			if elapsed and not elapsed2 then
				elapsed3 = os.clock()
			elseif not elapsed then
				Logger:warning("Timer has not been started yet")
			else
				Logger:warning("Timer has been already stopped")
			end

			if elapsed and elapsed3 then
				return elapsed3 - elapsed
			end

			return -1
		end
	}
end

return SimpleTimer
