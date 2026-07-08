local HttpService = game:GetService("HttpService")
local SimpleTimer = require(script.Parent.SimpleTimer)
local Logger = require(script.Parent.Parent.Logger)

local function Timers(p1) -- line: 16
	-- upvalues: Logger (copy), HttpService (copy), SimpleTimer (copy)
	local t1 = {}

	local function v7(s1: string?) -- line: 38
		-- upvalues: HttpService (copy), t1 (copy), SimpleTimer (copy), p1 (copy), Logger (copy)
		local v12 = s1 or HttpService:GenerateGUID(false)

		if t1[v12] then
			Logger:warning("(Start) Timer with this key already exists: " .. tostring(v12))

			return v12
		end

		local v13 = t1
		local v14 = SimpleTimer
		local t2 = {
			timeoutThreshold = p1 and p1.timeoutThreshold or nil
		}
		local g18 = nil
		local v17 = nil

		if p1 then
			local onReachingThreshold = p1.onReachingThreshold

			v17 = if not onReachingThreshold then nil else function() -- line: 31
				-- upvalues: v12 (copy), t1 (copy), Logger (copy), onReachingThreshold (copy)
				local v27 = v12

				if not t1[v27] then
					Logger:warning("(Clear) Timer with this key doesn't exist: " .. tostring(v27))
				else
					t1[v27].clear()
					t1[v27] = nil
				end

				onReachingThreshold()
			end

			if v17 then
				g18 = true
			end
		end

		if not g18 then
			v17 = nil
		end

		g18 = false
		t2.onReachingThreshold = v17
		v13[v12] = v14(t2)

		return v12
	end

	return {
		start = function(s2: string?, p2) -- line: 52
			-- upvalues: v7 (copy), t1 (copy)
			local v21 = v7(s2)

			t1[v21].start(p2)

			return v21
		end,
		stop = function(s3: string) -- line: 59
			-- upvalues: t1 (copy), Logger (copy)
			if not t1[s3] then
				Logger:warning("(Stop) Timer with this key doesn't exist: " .. tostring(s3))

				return -1
			end

			local v23 = t1[s3].stop()

			if not t1[s3] then
				Logger:warning("(Clear) Timer with this key doesn't exist: " .. tostring(s3))

				return v23
			end

			t1[s3].clear()
			t1[s3] = nil

			return v23
		end,
		getTime = function(s4: string) -- line: 71
			-- upvalues: t1 (copy), Logger (copy)
			if not t1[s4] then
				Logger:warning("(getTime) Timer with this key doesn't exist: " .. tostring(s4))

				return -1
			end

			return t1[s4].getTime()
		end,
		getStartTimestamp = function(s5: string) -- line: 80
			-- upvalues: t1 (copy), Logger (copy)
			if not t1[s5] then
				Logger:warning("(startTimeStamp) Timer with this key doesn't exist: " .. tostring(s5))

				return nil
			end

			return t1[s5].getStartTimestamp()
		end
	}
end

return Timers
